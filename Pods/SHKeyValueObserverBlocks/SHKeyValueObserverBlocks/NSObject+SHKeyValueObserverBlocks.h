//
//  UIViewController+SHSegueBlock.h
//  Example
//
//  Created by Seivan Heidari on 5/16/13.
//  Copyright (c) 2013 Seivan Heidari. All rights reserved.
//

#pragma mark -
#pragma mark Block Defs



typedef void (^SHKeyValueObserverBlock)(id weakSelf, NSString *keyPath, NSDictionary *change);

@interface NSObject (SHKeyValueObserverBlocks)

#pragma mark - Configuration

+(BOOL)SH_isAutoRemovingObservers;
+(void)SH_setAutoRemovingObservers:(BOOL)shouldRemoveObservers;




#pragma mark - Add Observers

-(NSString *)SH_addObserverForKeyPaths:(NSArray *)theKeyPaths
                                 block:(SHKeyValueObserverBlock)theBlock;

-(NSString *)SH_addObserverForKeyPaths:(NSArray *)theKeyPaths
                           withOptions:(NSKeyValueObservingOptions)theOptions
                                 block:(SHKeyValueObserverBlock)theBlock;



#pragma mark - Helpers
-(BOOL)SH_handleObserverForKeyPath:(NSString *)theKeyPath
                        withChange:(NSDictionary *)theChange
                           context:(void *)context;



#pragma mark -Remove Observers
-(void)SH_removeObserversForKeyPaths:(NSArray *)theKeyPaths
                         withIdentifiers:(NSArray *)theIdentifiers;

-(void)SH_removeObserversWithIdentifiers:(NSArray *)theIdentifiers;

-(void)SH_removeObserversForKeyPaths:(NSArray *)theKeyPaths;

-(void)SH_removeAllObservers;

@end
