
#####First Sample
```objective-c
  [self SH_addObserverForKeyPaths:@[@"username"] withOptions:0 block:^(id weakSelf, NSString *keyPath, NSDictionary *change) {
    NSLog(@"%@", ((SHViewController *)weakSelf).username);
    }];

```

#####Second Sample
```objective-c
  [self SH_addObserverForKeyPaths:@[@"username"] withOptions:0 block:^(id weakSelf, NSString *keyPath, NSDictionary *change) {
  
    SHViewController * caller = ((SHViewController *)weakSelf);
    if([caller.username hasPrefix:@"j"])
      NSLog(@"%@", caller.username);
    
  }];
  
```

#####Third Sample
```objective-c
  __weak typeof(self) caller = self;
  SHKeyValueObserverBlock block = ^(id weakSelf, NSString *keyPath, NSDictionary *change) {
    caller.createEnabled = [caller.password isEqualToString:caller.passwordConfirm];
  };
  [self SH_addObserverForKeyPaths:@[@"password", @"passwordConfirm"] withOptions:0 block:block];
  
```

#####Fourth Sample
```objective-c
  [self.btnSample SH_addControlEventTouchUpInsideWithBlock:^(UIControl *sender) {
    NSLog(@"button was pressed!");
  }];
```


#####Fifth Sample

```objective-c
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

```
  
