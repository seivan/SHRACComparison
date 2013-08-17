//
//  UIViewController+SHSegueBlock.h
//  Example
//
//  Created by Seivan Heidari on 5/16/13.
//  Copyright (c) 2013 Seivan Heidari. All rights reserved.
//


@interface NSInvocation (SHInvocation)
+(BOOL)SH_performInvocationOnTarget:(id)theTarget
                       withSelector:(SEL)theSelector
                       andArguments:(NSArray *)theArguments;
@end
