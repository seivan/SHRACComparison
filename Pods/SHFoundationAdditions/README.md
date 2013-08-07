# SHFoundationAdditions

[![Build Status](https://travis-ci.org/seivan/SHFoundationAdditions.png?branch=master)](https://travis-ci.org/seivan/SHFoundationAdditions)
[![Version](http://cocoapod-badges.herokuapp.com/v/SHFoundationAdditions/badge.png)](http://cocoadocs.org/docsets/SHFoundationAdditions)
[![Platform](http://cocoapod-badges.herokuapp.com/p/SHFoundationAdditions/badge.png)](http://cocoadocs.org/docsets/SHFoundationAdditions)


##### Additional prefixed categories for Foundation framework __without__ libffi and optional swizzle.


`SHFoundationAdditions` adds enumeration and KVO blocks without any hacks or libffi dependencies.
Observers will remove themselves once the object gets deallocated. You can toggle it off. 

> This pod is part of a many components covering to plug the holes missing from Foundation, UIKit, CoreLocation, GameKit, MapKit and other aspects of an iOS application's architecture. 

- [SHUIKitBlocks](https://github.com/seivan/SHUIKitBlocks)
- [SHTestCaseAdditions](https://github.com/seivan/SHTestCaseAdditions)
- [SHGameCenter](https://github.com/seivan/SHGameCenter)
- [SHMessageUIBlocks](https://github.com/seivan/SHMessageUIBlocks)

##Install
```ruby
pod 'SHFoundationAdditions'
```

##Dependency Status

| Library        | Tests           | Version  | Platform  |
| ------------- |:-------------:| -----:|  -----:| 
| [SHKeyValueObserverBlocks](https://github.com/seivan/SHKeyValueObserverBlocks)| [![Build Status](https://travis-ci.org/seivan/SHKeyValueObserverBlocks.png?branch=master)](https://travis-ci.org/seivan/SHKeyValueObserverBlocks)| [![Version](http://cocoapod-badges.herokuapp.com/v/SHKeyValueObserverBlocks/badge.png)](http://cocoadocs.org/docsets/SHKeyValueObserverBlocks) | [![Platform](http://cocoapod-badges.herokuapp.com/p/SHKeyValueObserverBlocks/badge.png)](http://cocoadocs.org/docsets/SHKeyValueObserverBlocks) |
| [SHFastEnumerationProtocols](https://github.com/seivan/SHFastEnumerationProtocols)| [![Build Status](https://travis-ci.org/seivan/SHFastEnumerationProtocols.png?branch=master)](https://travis-ci.org/seivan/SHFastEnumerationProtocols)| [![Version](http://cocoapod-badges.herokuapp.com/v/SHFastEnumerationProtocols/badge.png)](http://cocoadocs.org/docsets/SHFastEnumerationProtocols) | [![Platform](http://cocoapod-badges.herokuapp.com/p/SHFastEnumerationProtocols/badge.png)](http://cocoadocs.org/docsets/SHFastEnumerationProtocols) |
| [SHObjectUserInfo](https://github.com/seivan/SHObjectUserInfo)| [![Build Status](https://travis-ci.org/seivan/SHObjectUserInfo.png?branch=master)](https://travis-ci.org/seivan/SHObjectUserInfo)| [![Version](http://cocoapod-badges.herokuapp.com/v/SHObjectUserInfo/badge.png)](http://cocoadocs.org/docsets/SHObjectUserInfo) | [![Platform](http://cocoapod-badges.herokuapp.com/p/SHObjectUserInfo/badge.png)](http://cocoadocs.org/docsets/SHObjectUserInfo) |


##Import

>Per Library

```objective-c
#import "<Library>.h"
```

>For everything

```objective-c
#import "SHFoundationAdditions.h"
```

##Contact


If you end up using SHFoundationAdditions in a project, I'd love to hear about it.

email: [seivan.heidari@icloud.com](mailto:seivan.heidari@icloud.com)  
twitter: [@seivanheidari](https://twitter.com/seivanheidari)

##License

SHFoundationAdditions is © 2013 [Seivan](http://www.github.com/seivan) and may be freely
distributed under the [MIT license](http://opensource.org/licenses/MIT).
See the [`LICENSE.md`](https://github.com/seivan/SHFoundationAdditions/blob/master/LICENSE.md) file.
