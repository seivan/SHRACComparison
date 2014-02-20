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
+(void)loginWithUsername:(NSString *)theUsername andPassword:(NSString *)thePassword
       withSuccessSignal:(dispatch_group_t)theSuccessSignal orFailureSignal:(dispatch_group_t)theFailureSignal;
+(void)loginWithGroupSignal:(dispatch_group_t)theSignal;
+(void)fetchFriendsWithGroupSignal:(dispatch_group_t)theSignal;
+(BOOL)isLoggingIn;
@end

@implementation SHUser

+(void)loginWithUsername:(NSString *)theUsername andPassword:(NSString *)thePassword
       withSuccessSignal:(dispatch_group_t)theSuccessSignal orFailureSignal:(dispatch_group_t)theFailureSignal; {
  
  dispatch_group_enter(theSuccessSignal);
  dispatch_group_enter(theFailureSignal);
  double delayInSeconds = 5.0;
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    dispatch_group_leave(theSuccessSignal);
  });
}

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

+(BOOL)isLoggingIn; {
  return NO;
}
@end

@interface SHViewController ()
@property(nonatomic,strong) NSString * username;

@property(nonatomic,strong) NSString * password;
@property(nonatomic,strong) NSString * passwordConfirm;

@property(nonatomic,assign) BOOL       createEnabled;

@property(nonatomic,strong) UIButton * btnSample;

@property(nonatomic,assign) BOOL       didLogin;


@property(nonatomic,strong) UITextField * usernameTextField;
@property(nonatomic,strong) UITextField * passwordTextField;
@property(nonatomic,strong) UIButton    * logInButton;

@property(nonatomic,strong) UIView    * containerView;




-(void)firstSample;
-(void)secondSample;
-(void)thirdSample;
-(void)fourthSample;
-(void)fifthSample;
-(void)sixthSample;
-(void)collectionTransformSample;
@end

@implementation SHViewController

-(void)viewDidAppear:(BOOL)animated; {
  [self firstSample];
  [self secondSample];
  [self thirdSample];
  [self fourthSample];
  [self fifthSample];
  [self sixthSample];
  [self prepareSample];
  [self seventhSample];
  [self collectionTransformSample];
}

-(void)firstSample; {
  self.username = @"First Name";
  NSString * keyPath = @"username";
  [self SH_addObserverForKeyPath:keyPath block:^(NSKeyValueChange changeType, NSObject *oldValue, NSObject *newValue, NSIndexPath *indexPath) {
    NSLog(@"%@", newValue);
  }];

  self.username = @"Second Name";
  
  [self SH_removeAllObserversWithIdentifiers:@[keyPath]];
}

-(void)secondSample; {

  NSString * keyPath = @"username";

  [self SH_addObserverForKeyPath:keyPath block:^(NSKeyValueChange changeType, NSObject *oldValue, NSObject *newValue, NSIndexPath *indexPath) {
    if([((NSString *)newValue) hasPrefix:@"j"]) NSLog(@"%@", newValue);
  }];
  
  self.username = @"Second Name";
  self.username = @"jSecond Name";


}

-(void)thirdSample; {
  __weak typeof(self) weakSelf = self;
  SHKeyValueObserverDefaultBlock block = ^(NSString * keyPath, NSDictionary * change) {
    weakSelf.createEnabled = [weakSelf.password isEqualToString:weakSelf.passwordConfirm];
  };
  [self SH_addObserverForKeyPaths:@[@"password", @"passwordConfirm"] withOptions:kNilOptions block:block];
  
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
  __weak typeof(self) weakSelf = self;
  [self.btnSample SH_addControlEventTouchUpInsideWithBlock:^(UIControl *sender) {
    dispatch_group_t groupSignal = dispatch_group_create();
    [SHUser loginWithGroupSignal:groupSignal];
    dispatch_group_notify(groupSignal, dispatch_get_main_queue(), ^{ self.didLogin = YES; });
  }];
  
  [self SH_addObserverForKeyPaths:@[@"didLogin"] withOptions:kNilOptions block:^(NSString *keyPath, NSDictionary *change) {
    if(weakSelf.didLogin) NSLog(@"Logged in successfully");
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

-(void)prepareSample; {
  self.usernameTextField = [[UITextField alloc] initWithFrame:CGRectMake(50, 50, 200, 50)];
  self.passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(50, 260, 200, 50)];
  self.logInButton       = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  self.logInButton.frame = CGRectMake(50, 320, 100, 50);
  [self.logInButton setTitle:@"Login" forState:UIControlStateNormal];
  [self.logInButton setTitle:@"Disabled" forState:UIControlStateDisabled];
  [self.view addSubview:self.usernameTextField];
  [self.view addSubview:self.passwordTextField];
  [self.view addSubview:self.logInButton];
  
}




#pragma mark - Preparations

-(void)seventhSample; {
  __block BOOL        isLoggedIn = NO;
  __weak typeof(self) weakSelf   = self;

  SHControlEventBlock validateTextFieldBlock = ^(UIControl * sender){
    BOOL textFieldsNonEmpty = weakSelf.usernameTextField.text.length > 0 && weakSelf.passwordTextField.text.length > 0;
    BOOL readyToLogIn = [SHUser isLoggingIn] == NO && isLoggedIn == NO;
    weakSelf.logInButton.enabled = textFieldsNonEmpty && readyToLogIn;
  };
  
  [self.usernameTextField SH_addControlEvents:UIControlEventEditingChanged withBlock:validateTextFieldBlock];
  [self.passwordTextField SH_addControlEvents:UIControlEventEditingChanged withBlock:validateTextFieldBlock];
  
  [self.logInButton SH_addControlEventTouchUpInsideWithBlock:^(UIControl *sender) {
    dispatch_group_t successSignal = dispatch_group_create();
    dispatch_group_t failureSignal = dispatch_group_create();

    [SHUser loginWithUsername:weakSelf.usernameTextField.text andPassword:weakSelf.passwordTextField.text
            withSuccessSignal:successSignal orFailureSignal:failureSignal];
    
    dispatch_group_notify(successSignal, dispatch_get_main_queue(), ^{
      isLoggedIn = YES;
      validateTextFieldBlock(nil);
      NSLog(@"Logged in");
    });
    
    dispatch_group_notify(failureSignal, dispatch_get_main_queue(), ^{
      NSLog(@"Error logging in!");
    });

  }];
  
  double delayInSeconds = 2.0;
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    NSString * text = @"Username And Password";
    weakSelf.usernameTextField.text = text;
    weakSelf.passwordTextField.text = text;
    [weakSelf.usernameTextField sendActionsForControlEvents:UIControlEventEditingChanged];
    [weakSelf.logInButton sendActionsForControlEvents:UIControlEventTouchUpInside];
  });
  
}

-(void)collectionTransformSample; {
  NSArray * sample = @[@"123123", @"1", @"Apples", @"OZ", @"o", @"Sseivan"];
  
  typeof(sample) results = [[sample
                       SH_findAll:^BOOL(NSString * obj) {
                          return obj.length >= 2;
                        }]
                       SH_map:^id(NSString * obj) {
                         return [obj stringByAppendingString:@"foobar"];
                       }];
  
  NSLog(@"%@", results);
  
}

//http://twitter.com/erik_price/status/436530964412768256

//Alterntive
//    NSTimeInterval later = 0.f;
//    if(timer) later = [timer.fireDate timeIntervalSinceNow];
//    [timer invalidate];
//    later += 5.f;
//    timer = [NSTimer scheduledTimerWithTimeInterval:later target:weakSelf selector:@selector(eriksTimer:) userInfo:nil repeats:NO];

-(void)erikPriceChallenge; {
  self.containerView = [UIView new];
  __block NSTimer * timer = nil;
  typeof(self) weakSelf = self;
  
  void (^addDelayToHideContainer)(void) = ^void(void) {
    if(timer) timer.fireDate = [NSDate dateWithTimeIntervalSince1970:([timer.fireDate timeIntervalSince1970]+5.f)];
    else timer = [NSTimer scheduledTimerWithTimeInterval:5.f target:weakSelf selector:@selector(eriksTimer:) userInfo:nil repeats:NO];
  };

  
  UITapGestureRecognizer * tapGesture = [UITapGestureRecognizer SH_gestureRecognizerWithBlock:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
    switch(state) {
      case UIGestureRecognizerStateEnded: {
        weakSelf.containerView.hidden = NO;
        addDelayToHideContainer();
        break;
      }
      default:
        break;
    }
  }];
  
  [self.containerView addGestureRecognizer:tapGesture];
  
  
}

-(void)eriksTimer:(NSTimer *)theTimer; {
  [theTimer invalidate];
  self.containerView.hidden = YES;
}

@end