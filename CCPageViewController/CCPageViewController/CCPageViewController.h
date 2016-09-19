//
//  CCPageViewController.h
//  CCPageViewController
//
//  Created by 詹林 on 16/8/12.
//  Copyright © 2016年 AOLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCPageMenu.h"
#import "CCContentsView.h"
@class CCPageViewController;
@protocol CCPageViewControllerDataSource <NSObject>
@optional
- (UIButton * _Nonnull) rightButtonForPageViewController:(CCPageViewController * _Nonnull) pageViewController;
- (NSUInteger) numberOfItemsForPageViewController:(CCPageViewController * _Nonnull) pageViewController;
- (NSString * _Nonnull) pageViewController:(CCPageViewController * _Nonnull) pageViewController menuTitleForIndex: (NSUInteger) index;
- (UIViewController * _Nonnull) pageViewController:(CCPageViewController * _Nonnull) pageViewController contentViewControllerForIndex: (NSUInteger) index;
@end

@protocol CCPageViewControllerDelegate <NSObject>
@optional
- (void) pageViewController:(CCPageViewController * _Nonnull) pageViewController didSelectAtIndex:(NSUInteger) index;
- (void) pageViewController:(CCPageViewController * _Nonnull) pageViewController didClickRightButton:(UIButton * _Nonnull) button;
@end

@interface CCPageViewController : UIViewController
@property (nonatomic, nonnull, strong) CCPageMenu *menu;
@property (nonatomic, nonnull, strong) CCContentsView *contentsView;
@property (nonatomic, assign) IBInspectable CGFloat menuHeight;

@property (nonatomic, nullable, weak) id<CCPageViewControllerDataSource> dataSource;
@property (nonatomic, nullable, weak) id<CCPageViewControllerDelegate> delegate;

- (void) selectAtIndex:(NSUInteger) index;
- (UIViewController *_Nullable) selectedViewController;
- (UIViewController *_Nullable) viewControllerAtIndex:(NSUInteger) index;
- (void) reloadData;

@end
