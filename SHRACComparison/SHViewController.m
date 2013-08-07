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

@interface SHViewController ()
@property(nonatomic,strong) NSString * username;

@property(nonatomic,strong) NSString * password;
@property(nonatomic,strong) NSString * passwordConfirm;

@property(nonatomic,assign) BOOL       createEnabled;

@property(nonatomic,strong) UIButton * btnSample;

-(void)firstSample;
-(void)secondSample;
-(void)thirdSample;
-(void)fourthSample;
@end

@implementation SHViewController

-(void)viewDidAppear:(BOOL)animated; {
  [self firstSample];
  [self secondSample];
  [self thirdSample];
  [self fourthSample];
  
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
}


@end
