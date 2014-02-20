#SHKeyValueObserverBlocks

[![Build Status](https://travis-ci.org/seivan/SHKeyValueObserverBlocks.png?branch=master)](https://travis-ci.org/seivan/SHKeyValueObserverBlocks)
[![Version](https://cocoapod-badges.herokuapp.com/v/SHKeyValueObserverBlocks/badge.png)](http://cocoadocs.org/docsets/SHKeyValueObserverBlocks)
[![Platform](https://cocoapod-badges.herokuapp.com/p/SHKeyValueObserverBlocks/badge.png)](http://cocoadocs.org/docsets/SHKeyValueObserverBlocks)

> This pod is used by [`SHFoundationAdditions`](https://github.com/seivan/SHFoundationAdditions) as part of many components covering to plug the holes missing from Foundation.
There is also [`for UIKit`](https://github.com/seivan/SHUIKitBlocks) and others on the way; CoreLocation, GameKit, MapKit and other aspects of an iOS application's architecture.

##Overview

Data-Bindings & Key Value Observing with blocks on top of NSObject.
Blocks are hold with a weak reference so you don't have to cleanup when your object is gone.
There is an automatic Swizzling config that you can toggle on a per class basis. 


##Installation

```ruby
pod 'SHKeyValueObserverBlocks'
```


##Setup

Put this either in specific files or your project prefix file
```objective-c
#import "NSObject+SHKeyValueObserverBlocks.h"
```
or
```objective-c
#import "SHKeyValueObserverBlocks.h"
```

##Usage

##### Adding Observer on an NSArray to keep track of your data source
```objective-c
  NSString * path = @"languagesArray";
  NSString * identifier = [self SH_addObserverForKeyPath:path 
                                                  block:^(
                                                  NSKeyValueChange changeType, 
                                                  NSObject * oldValue, 
                                                  NSObject * newValue, 
                                                  NSIndexPath *indexPath) {
    switch (changeType) {
      case NSKeyValueChangeSetting:
        NSLog(@"Setting %@", newValue);
        break;
      case NSKeyValueChangeInsertion:
        NSLog(@"Inserting %@", newValue);
        break;
      case NSKeyValueChangeRemoval:
        NSLog(@"Removal %@", oldValue);
        break;
      case NSKeyValueChangeReplacement:
        NSLog(@"ChangeReplacement %@", newValue);
        break;
      default:
        break;
    }
  }];
  
  NSLog(@"Starting with NSArray");

  self.languagesArray = @[@"Python"];
  [[self mutableArrayValueForKey:path] addObject:@"C++"];
  [[self mutableArrayValueForKey:path] addObject:@"Objective-c"];
  [[self mutableArrayValueForKey:path] replaceObjectAtIndex:0 withObject:@"Ruby"];
  [[self mutableArrayValueForKey:path] removeObject:@"C++"];
  NSLog(@"%@", self.languagesArray);

```

##### Set a uni directional binding with a transform block

```objective-c
NSString * identifier =  [self SH_setBindingUniObserverKeyPath:@"playersDictionary" 
                                                      toObject:self
                                                   withKeyPath:@"othersDictionary"
                                           transformValueBlock:^id(
                                           NSObject *object, 
                                           NSString *keyPath, 
                                           NSObject * newValue, 
                                           BOOL *shouldAbort) {
    return newValue.mutableCopy ;
  }];

```

##### Set a bi-directional binding

```objective-c
NSArray * identifiers = [self.model SH_setBindingObserverKeyPath:@"errors" 
                                                        toObject:self 
                                                     withKeyPath:@"errors"];
```

##### Can use the macro SHKey() for using selectors as a keyPath for autocomplete goodness. 

```objective-c
NSArray * identifiers = [self.model SH_setBindingObserverKeyPath:@"errors" 
                                                        toObject:self 
                                                     withKeyPath:SHKey(errors)"];
```



##[API](https://github.com/seivan/SHKeyValueObserverBlocks/blob/develop/SHKeyValueObserverBlocks/NSObject%2BSHKeyValueObserverBlocks.h)

```objective-c

#pragma mark - Block Definitions

typedef void (^SHKeyValueObserverSplatBlock)(NSKeyValueChange changeType,
                                             id<NSObject> oldValue, id<NSObject> newValue,
                                             NSIndexPath * indexPath);

typedef void (^SHKeyValueObserverDefaultBlock)(NSString * keyPath,
                                               NSDictionary * change);

typedef id(^SHKeyValueObserverBindingTransformBlock)(NSObject * object,
                                                     NSString * keyPath,
                                                     id<NSObject> newValue,
                                                     BOOL *shouldAbort);

@interface NSObject (SHKeyValueObserverBlocks)

#pragma mark - Config
+(BOOL)SH_isAutoRemovingObservers;
+(void)SH_setAutoRemovingObservers:(BOOL)isAutoRemovingObservers;

#pragma mark - Properties
@property(nonatomic,readonly) NSDictionary * SH_observedKeyPaths;

#pragma mark - Add Observers

-(NSString *)SH_addObserverForKeyPath:(NSString *)theKeyPath
                                 block:(SHKeyValueObserverSplatBlock)theBlock;


-(NSString *)SH_addObserverForKeyPaths:(NSArray *)theKeyPaths
                           withOptions:(NSKeyValueObservingOptions)theOptions
                                 block:(SHKeyValueObserverDefaultBlock)theBlock;


#pragma mark - Set Bindings


-(NSArray *)SH_setBindingObserverKeyPath:(NSString *)theKeyPath
                                toObject:(NSObject *)theObject
                             withKeyPath:(NSString *)theOtherKeyPath;

-(NSString *)SH_setBindingUniObserverKeyPath:(NSString *)theKeyPath
                                    toObject:(NSObject *)theObject
                                 withKeyPath:(NSString *)theOtherKeyPath;

-(NSString *)SH_setBindingUniObserverKeyPath:(NSString *)theKeyPath
                                    toObject:(NSObject *)theObject
                                 withKeyPath:(NSString *)theOtherKeyPath
                             transformValueBlock:(SHKeyValueObserverBindingTransformBlock)theBlock;



#pragma mark - Remove Observers
-(void)SH_removeAllObserversWithIdentifiers:(NSArray *)theIdentifiers;
-(void)SH_removeAllObserversForKeyPaths:(NSArray *)theKeyPaths;
-(void)SH_removeAllObservers;


@end

```

##Credit

Thanks to [Yan Rabovik](https://twitter.com/rabovik) for [RSSwizzle](https://github.com/rabovik/RSSwizzle)

##Contact

If you end up using SHKeyValueObserverBlocks in a project, I'd love to hear about it.

email: [seivan.heidari@icloud.com](mailto:seivan.heidari@icloud.com)  
twitter: [@seivanheidari](https://twitter.com/seivanheidari)

## License

SHKeyValueObserverBlocks is © 2013 [Seivan](http://www.github.com/seivan) and may be freely
distributed under the [MIT license](http://opensource.org/licenses/MIT).
See the [`LICENSE.md`](https://github.com/seivan/SHKeyValueObserverBlocks/blob/master/LICENSE.md) file.
