# SHInvocation

[![Build Status](https://travis-ci.org/seivan/SHInvocation.png?branch=master)](https://travis-ci.org/seivan/SHInvocation)
[![Version](https://cocoapod-badges.herokuapp.com/v/SHInvocation/badge.png)](http://cocoadocs.org/docsets/SHInvocation)
[![Platform](https://cocoapod-badges.herokuapp.com/p/SHInvocation/badge.png)](http://cocoadocs.org/docsets/SHInvocation)

> This pod is used by [`SHFoundationAdditions`](https://github.com/seivan/SHFoundationAdditions) as part of many components covering to plug the holes missing from Foundation, UIKit, CoreLocation, GameKit, MapKit and other aspects of an iOS application's architecture.

Overview
--------

SHInvocation is a category on top of NSInvocation to allow executing selectors with multiple 

##Installation

```ruby
pod 'SHInvocation'
```


##Setup

Put this either in specific classes or your project prefix file

```objective-c
#import "NSInvocation+SHInvocation.h"
```

or

```objective-c
#import "SHInvocation.h"
```

##API


```objective-c
+(BOOL)SH_performInvocationOnTarget:(id)theTarget
                       withSelector:(SEL)theSelector
                       andArguments:(NSArray *)theArguments;
```

##USAGE

```objective-c
  NSString * firstArgument  = @"My first Argument";
  NSArray  * secondArgument = @[firstArgument, firstArgument, firstArgument];
  
 BOOL didInvoke = [NSInvocation SH_performInvocationOnTarget:self 
                                                withSelector:@selector(passTheFirstArgument:passTheSecondArgument:) 
                                                andArguments:@[firstArgument, secondArgument]];
  
  NSParameterAssert(didInvoke);
  NSParameterAssert([self.firstArgument  isEqualToString:firstArgument]);
  NSParameterAssert([self.secondArgument isEqual:secondArgument]);

``` 


##Contact


If you end up using SHInvocation in a project, I'd love to hear about it.

email: [seivan.heidari@icloud.com](mailto:seivan.heidari@icloud.com)  
twitter: [@seivanheidari](https://twitter.com/seivanheidari)

##License

SHInvocation is © 2013 [Seivan](http://www.github.com/seivan) and may be freely
distributed under the [MIT license](http://opensource.org/licenses/MIT).
See the [`LICENSE.md`](https://github.com/seivan/SHInvocation/blob/master/LICENSE.md) file.