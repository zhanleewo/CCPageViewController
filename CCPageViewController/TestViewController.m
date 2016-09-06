//
//  ViewController.m
//  CCPageViewController
//
//  Created by 詹林 on 16/8/15.
//  Copyright © 2016年 AOLC. All rights reserved.
//

#import "TestViewController.h"
#import "CCPageViewController.h"
#import "CCVPNPopoverViewController.h"
#import "CCHeaderViewController.h"

@interface TestViewController () <CCPageViewControllerDelegate, CCPageViewControllerDataSource>

@property (weak, nonatomic) IBOutlet UIView *headerContainerView;
@property (weak, nonatomic) IBOutlet UIView *contentContainerView;
@property (weak, nonatomic) IBOutlet UIView *popoverContainerView;


@property (nullable, weak, nonatomic) CCHeaderViewController *headerViewController;
@property (nullable, weak, nonatomic) CCPageViewController *pageViewController;
@property (nullable, weak, nonatomic) CCVPNPopoverViewController *popoverViewController;


@property (nonatomic, nonnull, strong) NSArray<NSString *> *items;
@property (nonatomic, nonnull, strong) NSArray<UIColor *> *colors;
@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _items = @[
               @"FC Bayern München",@"Borussia Dortmund",@"FC Schalke 04",@"WfL Wolfsburg",@"VfL Borussia Mönchengladbach",@"Bayer 04 Leverkusen",@"VfB Stuttgart", @"Hertha BSC Berlin", @"Eintracht Frankfurt", @"SV Werder Bremen"
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
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    [self.pageViewController reloadData];
    [self.pageViewController selectAtIndex: 0];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"show-header"]) {
        self.headerViewController = (CCHeaderViewController *) segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"show-content"]) {
        self.pageViewController = (CCPageViewController *) segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"show-popover"]) {
        self.popoverViewController = (CCVPNPopoverViewController *) segue.destinationViewController;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - CCPageViewControllerDataSource
- (UIButton * _Nonnull) rightButtonForPageViewController:(CCPageViewController * _Nonnull) pageViewController {
    // UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    //UIButton *button = [[UIButton alloc] init];
    UIButton *button = [[UIButton alloc] init];
    UIImage *image = [UIImage imageNamed:@"dropdown-icon-arrow-down"];
    [button setImage:image forState:UIControlStateNormal];
    return button;
}

- (NSUInteger) numberOfItemsForPageViewController:(CCPageViewController * _Nonnull) pageViewController {
    return _items.count;
}

- (NSString * _Nonnull) pageViewController:(CCPageViewController * _Nonnull) pageViewController menuTitleForIndex: (NSUInteger) index {
    return _items[index];
}

- (UIViewController * _Nonnull) pageViewController:(CCPageViewController * _Nonnull) pageViewController contentViewControllerForIndex: (NSUInteger) index {
    
    UIViewController *vc = [[UIViewController alloc] init];
    
    vc.view.backgroundColor = _colors[index];
    return vc;
}

#pragma mark - CCPageViewControllerDelegate
- (void) pageViewController:(CCPageViewController * _Nonnull) pageViewController didSelectAtIndex:(NSUInteger) index {
    NSLog(@"CCPageViewController didSelectAtIndex:%lu", (unsigned long) index);
}

- (void) pageViewController:(CCPageViewController * _Nonnull) pageViewController didClickRightButton:(UIButton * _Nonnull) button {
    NSLog(@"CCPageViewController didClickRightButton");
    self.popoverContainerView.hidden = NO;
}
@end
