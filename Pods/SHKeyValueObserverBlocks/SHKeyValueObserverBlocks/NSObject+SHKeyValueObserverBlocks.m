//
//
//  Created by Seivan Heidari on 5/16/13.
//  Copyright (c) 2013 Seivan Heidari. All rights reserved.
//

#import "NSObject+SHKeyValueObserverBlocks.h"
#import <objc/runtime.h>
#import <RSSwizzle.h>

typedef NS_OPTIONS(NSUInteger, SHKeyValueObserverBlockType) {
  SHKeyValueObserverBlockTypeDefault,
  SHKeyValueObserverBlockTypeSplat
};



@interface SHKeyValueObserverBlockHandler : NSObject
@property(nonatomic,strong) NSMutableArray * keyPaths;
@property(nonatomic,copy)   NSString * blockIdentifier;
@property(nonatomic,copy)   id block;
@property(nonatomic,assign) SHKeyValueObserverBlockType blockType;
@end

@implementation SHKeyValueObserverBlockHandler

@end



@interface SHKeyValueObserver : NSObject
@property(nonatomic,strong) NSHashTable  * bindingTargets;
@property(nonatomic,strong) NSMapTable   * bindingsIdentifiers;
@property(nonatomic,strong) NSMutableDictionary  * blocks;
@property(nonatomic,weak)   NSObject * target;
@property(nonatomic,readonly, getter = isObserving) BOOL observing;
+(instancetype)observerWithTarget:(NSObject *)theTarget;
@end

@implementation SHKeyValueObserver

+(instancetype)observerWithTarget:(NSObject *)theTarget; {
  SHKeyValueObserver * keyValueObserver = [[[self class] alloc] init];
  keyValueObserver.target = theTarget;
  keyValueObserver.blocks = @{}.mutableCopy;
  keyValueObserver.bindingsIdentifiers = [NSMapTable weakToStrongObjectsMapTable];
  keyValueObserver.bindingTargets = [NSHashTable weakObjectsHashTable];
  return keyValueObserver;
  
}

-(BOOL)isObserving; {
  return (self.blocks.count > 0 || self.bindingsIdentifiers.count > 0);
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context; {
  NSString * contextUUID  = (__bridge NSString *)(context);
  SHKeyValueObserverBlockHandler * blockHandler = self.blocks[contextUUID];
  switch (blockHandler.blockType) {
    case SHKeyValueObserverBlockTypeSplat:
      ((SHKeyValueObserverSplatBlock)blockHandler.block)(
                                                         ((NSNumber *)change[NSKeyValueChangeKindKey]).unsignedIntegerValue,
                                                         change[NSKeyValueChangeOldKey],
                                                         change[NSKeyValueChangeNewKey],
                                                         change[NSKeyValueChangeIndexesKey]
                                                         );
      break;
      
    case SHKeyValueObserverBlockTypeDefault:
      ((SHKeyValueObserverDefaultBlock)blockHandler.block)(keyPath,change);
      break;
      
    default:
      break;
  }
  
}

-(void)dealloc; {
  
}

@end



@interface SHKeyValueObserverBlocksManager : NSObject
@property(nonatomic,strong) NSMutableSet * disabledClassesForAutoRemoving;
@property(nonatomic,strong) NSMapTable   * mapBlocks;

+(instancetype)sharedManager;
-(void)SH_memoryDebugger;
@end



@implementation SHKeyValueObserverBlocksManager

#pragma mark - Init & Dealloc
-(instancetype)init; {
  self = [super init];
  if (self) {
    self.mapBlocks            = [NSMapTable weakToStrongObjectsMapTable];
    self.disabledClassesForAutoRemoving = [NSMutableSet set];
//    [self SH_memoryDebugger];
  }
  
  return self;
}

+(instancetype)sharedManager; {
  static SHKeyValueObserverBlocksManager *_sharedInstance;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedInstance = [[SHKeyValueObserverBlocksManager alloc] init];
    
  });
  
  return _sharedInstance;
  
}



#pragma mark - Debugger
-(void)SH_memoryDebugger; {
  __weak typeof(self) weakSelf = self;
  double delayInSeconds = 2.0;
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    
    NSLog(@"MAP %@",weakSelf.mapBlocks);
    [weakSelf SH_memoryDebugger];
  });
}


@end


@interface NSObject (SHKeyValueObserverBlocksPrivate)
@property(nonatomic,readonly) NSString               * SH_identifier;
@property(nonatomic,setter = SH_setKeyValueObserver:) SHKeyValueObserver   * SH_keyValueObserver;


-(NSString *)SH_addObserverWithBlockType:(SHKeyValueObserverBlockType)theBlockType
                             forKeyPaths:(NSArray *)theKeyPaths
                             withOptions:(NSKeyValueObservingOptions)theOptions
                                   block:(id)theBlock;
-(void)SH_removeBindingsWithIdentifier:(NSString *)theIdentifier;

@end

//static char SHKeyValueObserverBlocksContext;
@implementation NSObject (SHKeyValueObserverBlocks)

#pragma mark - Config
+(BOOL)SH_isAutoRemovingObservers; {
  return [[[SHKeyValueObserverBlocksManager sharedManager] disabledClassesForAutoRemoving] containsObject:[self class]] == NO;
}
+(void)SH_setAutoRemovingObservers:(BOOL)isAutoRemovingObservers; {
  if(isAutoRemovingObservers) [[[SHKeyValueObserverBlocksManager sharedManager] disabledClassesForAutoRemoving] removeObject:[self class]];
  else [[[SHKeyValueObserverBlocksManager sharedManager] disabledClassesForAutoRemoving] addObject:[self class]];
}

#pragma mark - Properties
-(NSDictionary *)SH_observedKeyPaths; {
  NSDictionary * blocks = self.SH_keyValueObserver.blocks.copy;
  if(blocks == nil) blocks = @{};
  return blocks;
}


#pragma mark - Add Observers


-(NSString *)SH_addObserverForKeyPath:(NSString *)theKeyPath
                                block:(SHKeyValueObserverSplatBlock)theBlock; {
  
  return [self SH_addObserverWithBlockType:SHKeyValueObserverBlockTypeSplat
                               forKeyPaths:@[theKeyPath]
                               withOptions:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                                     block:theBlock];
}

-(NSString *)SH_addObserverForKeyPaths:(NSArray *)theKeyPaths
                           withOptions:(NSKeyValueObservingOptions)theOptions
                                 block:(SHKeyValueObserverDefaultBlock)theBlock; {
  
  return [self SH_addObserverWithBlockType:SHKeyValueObserverBlockTypeDefault forKeyPaths:theKeyPaths withOptions:theOptions block:theBlock];
  
}


-(NSString *)SH_addObserverWithBlockType:(SHKeyValueObserverBlockType)theBlockType
                             forKeyPaths:(NSArray *)theKeyPaths
                             withOptions:(NSKeyValueObservingOptions)theOptions
                                   block:(id)theBlock; {
  
  NSParameterAssert(theKeyPaths);
  NSParameterAssert(theKeyPaths.count > 0);
  NSParameterAssert(theBlock);
  
  NSString * identifier = [NSString stringWithFormat:@"%@_%@_%@_%@",
                           NSStringFromClass([self class]),
                           [theKeyPaths componentsJoinedByString:@"_"],
                           [[NSUUID UUID] UUIDString],
                           @(theOptions).stringValue];
  
  
  __weak typeof(self) weakSelf = self;
  SHKeyValueObserver * observer = self.SH_keyValueObserver;
  if(observer == nil) observer = [SHKeyValueObserver observerWithTarget:self];
  SHKeyValueObserverBlockHandler * blockHandler = SHKeyValueObserverBlockHandler.new;
  blockHandler.block = theBlock;
  blockHandler.blockIdentifier = identifier;
  blockHandler.keyPaths = theKeyPaths.mutableCopy;
  blockHandler.blockType = theBlockType;
  observer.blocks[identifier] = blockHandler;
  
  self.SH_keyValueObserver = observer;
  
  if([[self class] SH_isAutoRemovingObservers]) {
    SEL selector = NSSelectorFromString(@"dealloc");
    [RSSwizzle
     swizzleInstanceMethod:selector
     inClass:[self class]
     newImpFactory:^id(RSSwizzleInfo *swizzleInfo) {
       // This block will be used as the new implementation.
       return ^void(__unsafe_unretained id self){
         [self SH_removeAllObservers];
         
         for (NSObject * key in [self SH_keyValueObserver].bindingsIdentifiers) {
           [key SH_removeAllObserversWithIdentifiers:[[self SH_keyValueObserver].bindingsIdentifiers objectForKey:key]];
         }
         
         
         // You MUST always cast implementation to the correct function pointer.
         int (*originalIMP)(__unsafe_unretained id, SEL);
         originalIMP = (__typeof(originalIMP))[swizzleInfo getOriginalImplementation];
         // Calling original implementation.
         originalIMP(self,selector);
         // Returning modified return value.
         
       };
     }
     mode:RSSwizzleModeOncePerClassAndSuperclasses
     key:(__bridge const void *)(self.SH_identifier)];
    
  }
  
  [theKeyPaths enumerateObjectsUsingBlock:^(NSString * keyPath, __unused NSUInteger idx, __unused BOOL *stop) {
    [weakSelf addObserver:observer forKeyPath:keyPath
                  options:theOptions
                  context:(__bridge void *)(identifier)];
  }];
  
  return identifier;
  
}

-(NSArray *)SH_setBindingObserverKeyPath:(NSString *)theKeyPath
                                toObject:(NSObject *)theObject
                             withKeyPath:(NSString *)theOtherKeyPath; {
  //Got to get a better name, and also a better solution than the BOOL flag
  __block BOOL isAvailableForKVO = YES;
  
  SHKeyValueObserverBindingTransformBlock validationBlock = ^id(NSObject * object, NSString * keyPath, NSObject * newValue, BOOL *shouldAbort) {
    if(isAvailableForKVO){
      isAvailableForKVO = NO;
      *shouldAbort = NO;
    }
    else {
      isAvailableForKVO = YES;
      *shouldAbort = YES;
    }
    return newValue;
  };
  
  return @[
           [self SH_setBindingUniObserverKeyPath:theKeyPath toObject:theObject withKeyPath:theOtherKeyPath transformValueBlock:validationBlock],
           [theObject SH_setBindingUniObserverKeyPath:theOtherKeyPath toObject:self withKeyPath:theKeyPath transformValueBlock:validationBlock]
           ];

}


-(NSString *)SH_setBindingUniObserverKeyPath:(NSString *)theKeyPath
                                    toObject:(NSObject *)theObject
                                 withKeyPath:(NSString *)theOtherKeyPath; {
  return [self SH_setBindingUniObserverKeyPath:theKeyPath toObject:theObject withKeyPath:theOtherKeyPath transformValueBlock:^id(NSObject *object, NSString *keyPath, NSObject * newValue, BOOL *shouldAbort) {
    return newValue;
  }];
}

-(NSString *)SH_setBindingUniObserverKeyPath:(NSString *)theKeyPath
                                    toObject:(NSObject *)theObject
                                 withKeyPath:(NSString *)theOtherKeyPath
                             transformValueBlock:(SHKeyValueObserverBindingTransformBlock)theBlock; {
  NSParameterAssert(theKeyPath);
  NSParameterAssert(theOtherKeyPath);
  NSParameterAssert(theObject);
  NSParameterAssert(theBlock);
  
  if(self == theObject) NSParameterAssert([theKeyPath isEqualToString:theOtherKeyPath] == NO);
  
  __weak typeof(self) weakSelf = self;
  __weak typeof(theObject) weakObserver = theObject;
  
  
  NSString * identifier = [self SH_addObserverForKeyPath:theKeyPath block:^(NSKeyValueChange changeType, NSObject * oldValue, NSObject * newValue, NSIndexPath *indexPath) {
    BOOL shouldAbort = NO;
    if(changeType != NSKeyValueChangeSetting) newValue = [weakSelf valueForKeyPath:theKeyPath];
    else if ([newValue isEqual:[NSNull null]]) newValue = nil;
    id value = theBlock(weakSelf, theKeyPath, newValue, &shouldAbort);
    if(shouldAbort == NO)[weakObserver setValue:value forKeyPath:theOtherKeyPath];
  }];
  
  
  //Add self with theObject and add theObject with self for removal later.
  SHKeyValueObserver * observer = theObject.SH_keyValueObserver;
  if(observer == nil) observer = [SHKeyValueObserver observerWithTarget:theObject];
  
  //Set the identifier for self with theObject
  [observer.bindingsIdentifiers setObject:[@[].mutableCopy arrayByAddingObjectsFromArray:
                                           [observer.bindingsIdentifiers objectForKey:self]]
                                   forKey:self];
  theObject.SH_keyValueObserver = observer;
  
  //Set theObject with self as a binded target
  [self.SH_keyValueObserver.bindingTargets addObject:theObject];
  
  
  return identifier;

};





#pragma mark - Remove Observers
-(void)SH_removeAllObserversWithIdentifiers:(NSArray *)theIdentifiers; {
  //__weak
  typeof(self) weakSelf = self;
  [theIdentifiers enumerateObjectsUsingBlock:^(NSString * identifier, __unused NSUInteger idx, __unused BOOL *stop) {
    SHKeyValueObserverBlockHandler * blockHandler = weakSelf.SH_keyValueObserver.blocks[identifier];
    [blockHandler.keyPaths enumerateObjectsUsingBlock:^(NSString * keyPath, __unused NSUInteger idx, __unused BOOL *stop) {
      [weakSelf removeObserver:weakSelf.SH_keyValueObserver forKeyPath:keyPath context:(__bridge void *)(identifier)];
    }];
    [weakSelf.SH_keyValueObserver.blocks removeObjectForKey:identifier];
    [weakSelf SH_removeBindingsWithIdentifier:identifier];
    
  }];
  self.SH_keyValueObserver = self.SH_keyValueObserver;
  
}

-(void)SH_removeAllObserversForKeyPaths:(NSArray *)theKeyPaths; {
  __weak typeof(self) weakSelf = self;
  NSMutableArray * identifiersToRemove = @[].mutableCopy;
  
  [theKeyPaths enumerateObjectsUsingBlock:^(NSString * keyPath, __unused NSUInteger idx, __unused BOOL *stop) {
    
    [self.SH_keyValueObserver.blocks enumerateKeysAndObjectsUsingBlock:^(NSString * identifier, SHKeyValueObserverBlockHandler * keyValueObserverBlockHandler, __unused BOOL *stop) {
      
      if([keyValueObserverBlockHandler.keyPaths containsObject:keyPath]) {
        [weakSelf removeObserver:weakSelf.SH_keyValueObserver forKeyPath:keyPath context:(__bridge void *)(identifier)];
        [keyValueObserverBlockHandler.keyPaths removeObject:keyPath];
        [weakSelf SH_removeBindingsWithIdentifier:identifier];
      }
      
      if(keyValueObserverBlockHandler.keyPaths.count == 0)
        [identifiersToRemove addObject:identifier];
    }];
    
  }];
  
  [identifiersToRemove enumerateObjectsUsingBlock:^(NSString * identifier, __unused NSUInteger idx, __unused BOOL *stop) {
    [weakSelf.SH_keyValueObserver.blocks removeObjectForKey:identifier];
  }];
  
  
  self.SH_keyValueObserver = self.SH_keyValueObserver;
}

-(void)SH_removeAllObservers; {
  NSArray * identifiers = self.SH_keyValueObserver.blocks.allKeys;
  [self SH_removeAllObserversWithIdentifiers:identifiers];
  
}

#pragma mark - Privates

-(void)SH_removeBindingsWithIdentifier:(NSString *)theIdentifier; {
  __weak typeof(self) weakSelf = nil;
  [self.SH_keyValueObserver.bindingTargets.allObjects enumerateObjectsUsingBlock:^(NSObject * bindedTarget, __unused NSUInteger idx, __unused BOOL *stop) {
    NSMutableArray * bindedIdentifiers = [bindedTarget.SH_keyValueObserver.bindingsIdentifiers objectForKey:weakSelf];
    [bindedIdentifiers removeObject:theIdentifier];
    bindedTarget.SH_keyValueObserver = bindedTarget.SH_keyValueObserver;
    if(bindedTarget.SH_keyValueObserver.isObserving == NO )[weakSelf.SH_keyValueObserver.bindingTargets removeObject:bindedTarget];
  }];
  
}
#pragma mark - Helpers

static char *kDisgustingSwizzledVariableKey;
-(NSString *)SH_identifier; {
  NSString * _identifier = objc_getAssociatedObject(self, kDisgustingSwizzledVariableKey);
  if(_identifier == nil) {
    _identifier = [NSString stringWithFormat:@"%@_%@",self, [[NSUUID UUID] UUIDString]];
    objc_setAssociatedObject(self, kDisgustingSwizzledVariableKey, _identifier, OBJC_ASSOCIATION_COPY);
  }
  return _identifier;
}


#pragma mark - Properties


-(SHKeyValueObserver *)SH_keyValueObserver; {
  return [SHKeyValueObserverBlocksManager.sharedManager.mapBlocks objectForKey:self.SH_identifier];
}

-(void)SH_setKeyValueObserver:(SHKeyValueObserver *)SH_keyValueObserver; {
  if(SH_keyValueObserver.isObserving)
    [SHKeyValueObserverBlocksManager.sharedManager.mapBlocks setObject:SH_keyValueObserver forKey:self.SH_identifier];
  else
    [SHKeyValueObserverBlocksManager.sharedManager.mapBlocks removeObjectForKey:self.SH_identifier];
  
  
}

@end
