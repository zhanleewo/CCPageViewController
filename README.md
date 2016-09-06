# CCPageViewController
A simple Page Menu View Controller, Easy to customize, UITableView-like API.

## Demo
![Demo] (demo.gif)


## How To Use
1. setup

``` objective-c
- (void)viewDidLoad {
    [super viewDidLoad];

    self.pageViewController = [[CCPageViewController alloc] init];

    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    
    [self.pageViewController reloadData];
    [self.pageViewController selectAtIndex: 0];
    
}
```

2. implements delegate and datasource protocol

``` objective-c

#pragma mark - CCPageViewControllerDataSource
- (UIButton * _Nonnull) rightButtonForPageViewController:(CCPageViewController * _Nonnull) pageViewController {
    UIButton *button = [[UIButton alloc] init];
    return button;
}

- (NSUInteger) numberOfItemsForPageViewController:(CCPageViewController * _Nonnull) pageViewController {
    return ; // count of menu items
}

- (NSString * _Nonnull) pageViewController:(CCPageViewController * _Nonnull) pageViewController menuTitleForIndex: (NSUInteger) index {
    return @""; // menu item title
}

- (UIViewController * _Nonnull) pageViewController:(CCPageViewController * _Nonnull) pageViewController contentViewControllerForIndex: (NSUInteger) index {
    UIViewController *vc = [[UIViewController alloc] init];
    return vc;
}

#pragma mark - CCPageViewControllerDelegate
- (void) pageViewController:(CCPageViewController * _Nonnull) pageViewController didSelectAtIndex:(NSUInteger) index {
    NSLog(@"CCPageViewController didSelectAtIndex:%lu", (unsigned long) index);
}

- (void) pageViewController:(CCPageViewController * _Nonnull) pageViewController didClickRightButton:(UIButton * _Nonnull) button {
    NSLog(@"CCPageViewController didClickRightButton");
}
```
