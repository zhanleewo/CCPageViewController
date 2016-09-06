//
//  CCPageMenu.h
//  CCPageViewController
//
//  Created by 詹林 on 16/8/12.
//  Copyright © 2016年 AOLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCPageMenuItem.h"

@class CCPageMenu;

@protocol CCPageMenuDataSource <NSObject>

@required
- (NSInteger) numberOfItemsForPageMenu:(CCPageMenu * _Nonnull) pageMenu;

@optional
- (UIButton * _Nullable) rightButtonForPageMenu:(CCPageMenu * _Nonnull) pageMenu;
- (CCPageMenuItem * _Nonnull) pageMenu:(CCPageMenu * _Nonnull) pageMenu viewForRowAtIndex: (NSUInteger) index;
- (NSString * _Nonnull) pageMenu:(CCPageMenu * _Nonnull) pageMenu textForRowAtIndex: (NSUInteger) index;

@end

@protocol CCPageMenuDelegate <NSObject>
@optional
- (void) pageMenu:(CCPageMenu * _Nonnull) pageMenu didSelectAtIndex:(NSUInteger) index;
- (void) pageMenu:(CCPageMenu * _Nonnull) pageMenu rightButtonClicked:(UIButton * _Nonnull) button;
@end

@interface CCPageMenu : UIView

@property (nonatomic, assign) BOOL showBorderline;
@property (nonatomic, strong, nonnull) UIColor *borderLineColor;
@property (nonatomic, assign) CGFloat borderLineWeight;

@property (nonatomic, strong, nonnull) UIFont *titleFont;
@property (nonatomic, strong, nonnull) UIFont *titleSelectedFont;
@property (nonatomic, strong, nonnull) UIColor *titleColor;
@property (nonatomic, strong, nonnull) UIColor *titleSelectedColor;

@property (nonatomic, assign) BOOL showUnderline;
@property (nonatomic, strong, nullable) UIColor *underLineColor;
@property (nonatomic, assign) CGFloat underLineWeight;


@property (nullable, weak, nonatomic) id<CCPageMenuDelegate> delegate;
@property (nullable, weak, nonatomic) id<CCPageMenuDataSource> dataSource;

- (void) reloadData;
- (void) selectAtIndex:(NSUInteger) index;
@end
