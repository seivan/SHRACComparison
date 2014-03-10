#####First Sample
```objective-c
  __weak typeof(self) weakSelf = self;
  [self SH_addObserverForKeyPaths:@[@"username"] withOptions:kNilOptions block:^(__unused NSString *keyPath, __unused NSDictionary *change) {
    NSLog(@"%@", ((SHViewController *)weakSelf).username);
    }];

```

#####Second Sample
```objective-c
  __weak typeof(self) weakSelf = self;
  [self SH_addObserverForKeyPaths:@[@"username"] withOptions:0 block:^(__unused NSString *keyPath, __unused  NSDictionary *change) {
  
    if([weakSelf.username hasPrefix:@"j"]) 
    NSLog(@"%@", weakSelf.username);
    
  }];
  
```

#####Third Sample
```objective-c
  __weak typeof(self) weakself = self;
  SHKeyValueObserverBlock block = ^(__unused NSString *keyPath, __unused NSDictionary *change) {
    weakSelf.createEnabled = [weakSelf.password isEqualToString:caller.passwordConfirm];
  };
  [self SH_addObserverForKeyPaths:@[@"password", @"passwordConfirm"] withOptions:kNilOptions block:block];
  
```

#####Fourth Sample
```objective-c
  [self.btnSample SH_addControlEventTouchUpInsideWithBlock:^(__unused UIControl *sender) {
    NSLog(@"button was pressed!");
  }];
```


#####Fifth Sample

```objective-c
  __weak typeof(self) weakSelf
  [self.btnSample SH_addControlEventTouchUpInsideWithBlock:^(UIControl *sender) {
    dispatch_group_t groupSignal = dispatch_group_create();
    [SHUser loginWithGroupSignal:groupSignal];
    dispatch_group_notify(groupSignal, dispatch_get_main_queue(), ^{ weakSelf.didLogin = YES; });
  }];
  
  [self SH_addObserverForKeyPaths:@[@"didLogin"] withOptions:0 block:^(__unused NSString *keyPath, __unused  NSDictionary *change) {
    if(weakSelf.didLogin) NSLog(@"Logged in successfully");
  }];
  
  [self.btnSample sendActionsForControlEvents:UIControlEventTouchUpInside];
  

```

#####Sixth Sample
```objective-c
  dispatch_group_t groupSignal = dispatch_group_create();
  [SHUser loginWithGroupSignal:groupSignal];
  [SHUser fetchFriendsWithGroupSignal:groupSignal];
  dispatch_group_notify(groupSignal, dispatch_get_main_queue(), ^{
    NSLog(@"They're both done!");
  });

```


#####Seventh Sample
```objective-c
  __block BOOL        isLoggedIn = NO;
  __weak typeof(self) weakSelf   = self;

  SHControlEventBlock validateTextFieldBlock = ^(__unused UIControl * sender){
    BOOL textFieldsNonEmpty = weakSelf.usernameTextField.text.length > 0 && weakSelf.passwordTextField.text.length > 0;
    BOOL readyToLogIn = [SHUser isLoggingIn] == NO && isLoggedIn == NO;
    weakSelf.logInButton.enabled = textFieldsNonEmpty && readyToLogIn;
  };
  
  [self.usernameTextField SH_addControlEvents:UIControlEventEditingChanged withBlock:validateTextFieldBlock];
  [self.passwordTextField SH_addControlEvents:UIControlEventEditingChanged withBlock:validateTextFieldBlock];
  
  [self.logInButton SH_addControlEventTouchUpInsideWithBlock:^(__unused UIControl *sender) {
    dispatch_group_t successSignal = dispatch_group_create();
    dispatch_group_t failureSignal = dispatch_group_create();

    [SHUser loginWithUsername:weakSelf.usernameTextField.text andPassword:weakSelf.passwordTextField.text
            withSuccessSignal:successSignal orFailureSignal:failureSignal];
    
    dispatch_group_notify(successSignal, dispatch_get_main_queue(), ^{
      isLoggedIn = YES;
      validateTextFieldBlock(nil);
    });
    
    dispatch_group_notify(failureSignal, dispatch_get_main_queue(), ^{
      NSLog(@"Error logging in!");
    });

  }];
```


#####collectionTransformSample
```objective-c
  typeof(sample) results = [[sample
                       SH_findAll:^BOOL(NSString * obj) {
                          return obj.length >= 2;
                        }]
                       SH_map:^id(NSString * obj) {
                         return [obj stringByAppendingString:@"foobar"];
                       }];

```

  
