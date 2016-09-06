//
//  CCPageViewController.m
//  CCPageViewController
//
//  Created by 詹林 on 16/8/12.
//  Copyright © 2016年 AOLC. All rights reserved.
//

#import "CCPageViewController.h"

#import <Masonry/Masonry.h>
#import "CCPageMenu.h"

@interface CCPageViewController () <CCPageMenuDataSource, CCPageMenuDelegate, CCContentsViewDataSource, CCContentsViewDelegate>
@end

@implementation CCPageViewController

// let g_skyBlueColor = colorWithHex(0x27BFFD)
+ (UIColor *) defaultMenuBackgroundColor {
    return [CCPageViewController colorWithHex:0xfefefe];
}
+ (UIColor *) skyBlueColor {
    return [CCPageViewController colorWithHex:0x27BFFD];
}

+ (UIColor *) colorWithHex:(NSInteger) hex {
    return [CCPageViewController colorWithHex:hex andAlpha:1.0];
}
+ (UIColor *) colorWithHex:(NSInteger) hex andAlpha:(CGFloat) alpha {
    CGFloat red = ((hex & 0xff0000) >> 16) / 255.0;
    CGFloat green = ((hex & 0x00ff00) >> 8) / 255.0;
    CGFloat blue = (hex & 0x0000ff) / 255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (_menuHeight == 0.0f) {
        _menuHeight = 44.0f;
    }
    
    //[self.view setBackgroundColor:[CCPageViewController defaultMenuBackgroundColor]];
    
    NSNumber *menuHeightNumber = [NSNumber numberWithFloat:_menuHeight];
    CGRect menuFrame = CGRectMake(0, 0, self.view.frame.size.width, _menuHeight);
    _menu = [[CCPageMenu alloc] initWithFrame:menuFrame];
    _menu.backgroundColor = [CCPageViewController defaultMenuBackgroundColor];
    _menu.dataSource = self;
    _menu.delegate = self;
    
    _menu.showBorderline = NO;
    [_menu setTitleColor:[UIColor lightGrayColor]];
    [_menu setTitleSelectedColor:[CCPageViewController skyBlueColor]];
    
    [self.view addSubview:_menu];
    
    CGRect contentsFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - _menuHeight);
    _contentsView = [[CCContentsView alloc] initWithFrame:contentsFrame];
    _contentsView.dataSource = self;
    _contentsView.delegate = self;
    [self.view addSubview:_contentsView];
    
    [_menu makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(menuHeightNumber);
    }];
    
    [_contentsView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.menu.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    NSLog(@"%@", NSStringFromCGRect(_contentsView.frame));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [_contentsView cleanCache];
}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    NSLog(@"viewWillLayoutSubviews: %@", NSStringFromCGRect(self.view.frame));
}
- (void) selectAtIndex:(NSUInteger) index {
    
    [_menu selectAtIndex:index];
    [_contentsView selectAtIndex:index];
    [self.delegate pageViewController:self didSelectAtIndex:index];
}

- (void) reloadData {
    [_menu reloadData];
    [_contentsView reloadData];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger) numberOfItemsForPageMenu:(CCPageMenu * _Nonnull) pageMenu {
    return [self.dataSource numberOfItemsForPageViewController:self];
}

- (UIButton * _Nullable) rightButtonForPageMenu:(CCPageMenu * _Nonnull) pageMenu {
    return [self.dataSource rightButtonForPageViewController:self];
}

- (NSString * _Nonnull) pageMenu:(CCPageMenu * _Nonnull) pageMenu textForRowAtIndex: (NSUInteger) index {
    return [self.dataSource pageViewController:self menuTitleForIndex:index];
}

- (void) pageMenu:(CCPageMenu * _Nonnull) pageMenu didSelectAtIndex:(NSUInteger) index {
    [_contentsView selectAtIndex: index];
    [self.delegate pageViewController:self didSelectAtIndex:index];
}

- (void) pageMenu:(CCPageMenu * _Nonnull) pageMenu rightButtonClicked:(UIButton * _Nonnull) button {
    [self.delegate pageViewController:self didClickRightButton:button];
}


- (NSInteger) numberOfViewsForContentsView:(CCContentsView * _Nonnull) contentsView {
    return [self.dataSource numberOfItemsForPageViewController:self];
}

- (UIView * _Nonnull) placeHolderViewForContentsView:(CCContentsView * _Nonnull) contentsView {
    UIView *view = [[UIView alloc] init];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toolbar-item-logo"]];
    [view addSubview:imageView];
    
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(view);
    }];
    return view;
}

- (UIViewController * _Nonnull) contentsView:(CCContentsView * _Nonnull) contentsView viewControllerForRowAtIndex: (NSUInteger) index {
    return [self.dataSource pageViewController:self contentViewControllerForIndex:index];
}

- (void) contentsView:(CCContentsView * _Nonnull) contentsView willAddViewController:(UIViewController * _Nonnull) childViewControler {
    [childViewControler willMoveToParentViewController:self];
    [self addChildViewController:childViewControler];
}

- (void) contentsView:(CCContentsView * _Nonnull) contentsView didAddViewController:(UIViewController * _Nonnull) childViewControler {
    [childViewControler didMoveToParentViewController:self];
}

- (void) contentsView:(CCContentsView * _Nonnull) contentsView willRemoveViewController:(UIViewController * _Nonnull) childViewControler {
    [childViewControler willMoveToParentViewController:nil];
}

- (void) contentsView:(CCContentsView * _Nonnull) contentsView didRemoveViewController:(UIViewController * _Nonnull) childViewControler {
    [childViewControler removeFromParentViewController];
}


- (void) contentsView:(CCContentsView * _Nonnull) contentsView didMoveToIndex: (NSUInteger) index {
    [self.menu selectAtIndex:index];
    [self.delegate pageViewController:self didSelectAtIndex:index];
}

@end
