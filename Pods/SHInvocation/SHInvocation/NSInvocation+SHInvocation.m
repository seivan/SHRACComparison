//
//  UIViewController+SHSegueBlock.m
//  Example
//
//  Created by Seivan Heidari on 5/16/13.
//  Copyright (c) 2013 Seivan Heidari. All rights reserved.
//

#import "NSInvocation+SHInvocation.h"

@implementation NSInvocation (SHInvocation)

+(BOOL)SH_performInvocationOnTarget:(id)theTarget
                       withSelector:(SEL)theSelector
                       andArguments:(NSArray *)theArguments; {
  
  NSParameterAssert(theSelector);
  NSParameterAssert(theTarget);
  NSParameterAssert(theArguments);
  NSParameterAssert(theArguments.count > 0);
  
  BOOL didInvoke = NO;
  if([theTarget respondsToSelector:theSelector]){
    NSMethodSignature * signature = [theTarget methodSignatureForSelector:theSelector];
    NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:theTarget];
    [invocation setSelector:theSelector];
    [theArguments enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
      idx += 2;
      [invocation setArgument:&obj atIndex:idx];
    }];
    [invocation invoke];
    didInvoke = YES;
  }
  return didInvoke;
}


@end
