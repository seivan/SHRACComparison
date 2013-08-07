
######First Sample
```objective-c

  NSString * identifier = [self SH_addObserverForKeyPaths:@[@"username"] withOptions:0
                            block:^(id weakSelf, NSString *keyPath, NSDictionary *change) {
                              NSLog(@"%@", ((SHViewController *)weakSelf).username);
                            }];
```

######Second Sample
```objective-c
  [self SH_addObserverForKeyPaths:@[@"username"] withOptions:0 block:^(id weakSelf, NSString *keyPath, NSDictionary *change) {
  
    SHViewController * caller = ((SHViewController *)weakSelf);
    if([caller.username hasPrefix:@"j"])
      NSLog(@"%@", caller.username);
    
  }];
  
```

######Third Sample
```objective-c
  __weak typeof(self) caller = self;
  SHKeyValueObserverBlock block = ^(id weakSelf, NSString *keyPath, NSDictionary *change) {
    caller.createEnabled = [caller.password isEqualToString:caller.passwordConfirm];
  };
  [self SH_addObserverForKeyPaths:@[@"password", @"passwordConfirm"] withOptions:0 block:block];
  
```

######Fourth Sample
```objective-c
  [self.btnSample SH_addControlEventTouchUpInsideWithBlock:^(UIControl *sender) {
    NSLog(@"button was pressed!");
  }];
  
```
  
