//
//  SHViewController.m
//  SHRACComparison
//
//  Created by Seivan Heidari on 8/7/13.
//  Copyright (c) 2013 Seivan Heidari. All rights reserved.
//

#import "SHViewController.h"

#import "SHFoundationAdditions.h"
#import "SHUIKitBlocks.h"

@interface SHUser : NSObject
+(void)loginWithGroupSignal:(dispatch_group_t)theSignal;
+(void)fetchFriendsWithGroupSignal:(dispatch_group_t)theSignal;
@end

@implementation SHUser

+(void)loginWithGroupSignal:(dispatch_group_t)theSignal; {
  dispatch_group_enter(theSignal);
  double delayInSeconds = 2.0;
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    dispatch_group_leave(theSignal);
  });
}

+(void)fetchFriendsWithGroupSignal:(dispatch_group_t)theSignal; {
  [self loginWithGroupSignal:theSignal];
}

@end

@interface SHViewController ()
@property(nonatomic,strong) NSString * username;

@property(nonatomic,strong) NSString * password;
@property(nonatomic,strong) NSString * passwordConfirm;

@property(nonatomic,assign) BOOL       createEnabled;

@property(nonatomic,strong) UIButton * btnSample;

@property(nonatomic,assign) BOOL       didLogin;


-(void)firstSample;
-(void)secondSample;
-(void)thirdSample;
-(void)fourthSample;
-(void)fifthSample;
-(void)sixthSample;
@end

@implementation SHViewController

-(void)viewDidAppear:(BOOL)animated; {
  [self firstSample];
  [self secondSample];
  [self thirdSample];
  [self fourthSample];
  [self fifthSample];
  [self sixthSample];
}

-(void)firstSample; {
  self.username = @"First Name";
  
  NSString * identifier = [self SH_addObserverForKeyPaths:@[@"username"] withOptions:0
                            block:^(id weakSelf, NSString *keyPath, NSDictionary *change) {
                              NSLog(@"%@", ((SHViewController *)weakSelf).username);
                            }];
  
  self.username = @"Second Name";
  
  [self SH_removeObserversWithIdentifiers:@[identifier]];
}

-(void)secondSample; {
  [self SH_addObserverForKeyPaths:@[@"username"] withOptions:0 block:^(id weakSelf, NSString *keyPath, NSDictionary *change) {
  
    SHViewController * caller = ((SHViewController *)weakSelf);
    if([caller.username hasPrefix:@"j"])
      NSLog(@"%@", caller.username);
    
  }];
  
  self.username = @"Second Name";
  self.username = @"jSecond Name";


}

-(void)thirdSample; {
  __weak typeof(self) caller = self;
  SHKeyValueObserverBlock block = ^(id weakSelf, NSString *keyPath, NSDictionary *change) {
    caller.createEnabled = [caller.password isEqualToString:caller.passwordConfirm];
  };
  [self SH_addObserverForKeyPaths:@[@"password", @"passwordConfirm"] withOptions:0 block:block];
  
  self.passwordConfirm = @"LOL";
  self.password = @"ZOL";
  NSLog(@"%d", self.createEnabled);

  self.passwordConfirm = @"LOL";
  self.password = @"LOL";
  
  NSLog(@"%d", self.createEnabled);

  self.passwordConfirm = @"LOL";
  self.password = @"ZOL";

  NSLog(@"%d", self.createEnabled);
  
}

-(void)fourthSample; {
  self.btnSample = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [self.btnSample SH_addControlEventTouchUpInsideWithBlock:^(UIControl *sender) {
    NSLog(@"button was pressed!");
  }];
  
  [self.btnSample sendActionsForControlEvents:UIControlEventTouchUpInside];
  [self.btnSample SH_removeAllControlEventsBlocks];
}

-(void)fifthSample; {
  [self.btnSample SH_addControlEventTouchUpInsideWithBlock:^(UIControl *sender) {
    dispatch_group_t groupSignal = dispatch_group_create();
    [SHUser loginWithGroupSignal:groupSignal];
    dispatch_group_notify(groupSignal, dispatch_get_main_queue(), ^{ self.didLogin = YES; });
  }];
  
  [self SH_addObserverForKeyPaths:@[@"didLogin"] withOptions:0 block:^(id weakSelf, NSString *keyPath, NSDictionary *change) {
    if(self.didLogin) NSLog(@"Logged in successfully");
  }];
  
  [self.btnSample sendActionsForControlEvents:UIControlEventTouchUpInside];
  
}


-(void)sixthSample; {
  dispatch_group_t groupSignal = dispatch_group_create();
  [SHUser loginWithGroupSignal:groupSignal];
  [SHUser fetchFriendsWithGroupSignal:groupSignal];
  dispatch_group_notify(groupSignal, dispatch_get_main_queue(), ^{
    NSLog(@"They're both done!");
  });
  

  
}


@end
