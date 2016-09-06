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

@interface CCPageViewController ()
@property (nonatomic, nonnull, strong) NSArray<NSString *> *items;
@property (nonatomic, nonnull, strong) NSArray<UIColor *> *colors;
@end

@implementation CCPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Screen Frame: %@", NSStringFromCGRect([UIScreen mainScreen].bounds));
    NSLog(@"View Frame: %@", NSStringFromCGRect(self.view.frame));
    CGRect menuFrame = CGRectMake(0, 0, self.view.frame.size.width, 44.0f);
    _menu = [[CCPageMenu alloc] initWithFrame:menuFrame];
    _menu.backgroundColor = [UIColor lightGrayColor];
    _menu.dataSource = self;
    _menu.delegate = self;
    [self.view addSubview:_menu];
    
    CGRect contentsFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44.0f);
    _scrollView = [[UIScrollView alloc] initWithFrame:contentsFrame];
    [self.view addSubview:_scrollView];
    
    [_menu makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@44);
    }];
    
    NSLog(@"Menu Frame: %@", NSStringFromCGRect(_menu.frame));
    
    [_scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.menu.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    NSLog(@"Contents Frame: %@", NSStringFromCGRect(_scrollView.frame));
    
    _items = @[
               @"香港",@"北京",@"上海",@"日本",@"英国",@"德国",@"美国", @"法国", @"意大利", @"西班牙"
              ];
    _colors = @[
                [UIColor magentaColor],
                [UIColor redColor],
                [UIColor blueColor],
                [UIColor purpleColor],
                [UIColor yellowColor],
                [UIColor darkGrayColor],
                [UIColor greenColor],
                [UIColor blackColor],
                [UIColor brownColor],
                [UIColor orangeColor]
                ];
    [_menu reloadData];
    [_menu selectAtIndex:1];
    
    [self reloadContentViews];
    [self selectContentViewAtIndex:1];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) reloadContentViews {

}
- (void) selectContentViewAtIndex:(NSUInteger) index {
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
    return _items.count;
}

- (UIButton * _Nullable) rightButtonForPageMenu:(CCPageMenu * _Nonnull) pageMenu {
    return [[UIButton alloc] init];
}

- (NSString * _Nonnull) pageMenu:(CCPageMenu * _Nonnull) pageMenu textForRowAtIndex: (NSUInteger) index {
    return _items[index];
}

- (void) pageMenu:(CCPageMenu * _Nonnull) pageMenu didSelectAtIndex:(NSUInteger) index {
    //self.contentsView.backgroundColor = _colors[index];
    NSLog(@"%lu", (unsigned long) index);
    [self selectContentViewAtIndex:index];
}

- (void) pageMenu:(CCPageMenu * _Nonnull) pageMenu rightButtonClicked:(UIButton * _Nonnull) button {
    
}

- (UIViewController * _Nonnull) contentsView:(CCContentsView * _Nonnull) contentsView viewControllerForRowAtIndex: (NSUInteger) index {

}

- (UIView * _Nonnull) contentsView:(CCContentsView * _Nonnull) contentsView viewForRowAtIndex: (NSUInteger) index {
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = _colors[index];
    return view;
}


- (void) contentsView:(CCContentsView * _Nonnull) contentsView didMoveToIndex: (NSUInteger) index {
    
    
    
    [self.menu selectAtIndex:index];
}

@end
