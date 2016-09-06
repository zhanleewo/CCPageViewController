//
//  CCPageViewController.h
//  CCPageViewController
//
//  Created by 詹林 on 16/8/12.
//  Copyright © 2016年 AOLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCPageMenu.h"

@interface CCPageViewController : UIViewController <CCPageMenuDataSource, CCPageMenuDelegate>
@property (nonatomic, nonnull, strong) CCPageMenu *menu;
@property (nonatomic, nonnull, strong) UIScrollView *scrollView;

- (NSInteger) numberOfItemsForPageMenu:(CCPageMenu * _Nonnull) pageMenu;
- (UIButton * _Nullable) rightButtonForPageMenu:(CCPageMenu * _Nonnull) pageMenu;
- (NSString * _Nonnull) pageMenu:(CCPageMenu * _Nonnull) pageMenu textForRowAtIndex: (NSUInteger) index;
- (void) pageMenu:(CCPageMenu * _Nonnull) pageMenu didSelectAtIndex:(NSUInteger) index;
- (void) pageMenu:(CCPageMenu * _Nonnull) pageMenu rightButtonClicked:(UIButton * _Nonnull) button;

@end
