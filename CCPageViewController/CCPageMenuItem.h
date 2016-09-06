//
//  CCPageMenuItem.h
//  CCPageViewController
//
//  Created by 詹林 on 16/8/12.
//  Copyright © 2016年 AOLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CCPageMenuItemDelegate;

@interface CCPageMenuItem : UIView

@property (assign, nonatomic) BOOL selected;
@property (weak, nonatomic) id<CCPageMenuItemDelegate> delegate;

- (void)setItemTitle:(NSString *)title;
- (void)setItemTitleFont:(CGFloat)fontSize;
- (void)setItemTitleColor:(UIColor *)color;
- (void)setItemSelectedTileFont:(CGFloat)fontSize;
- (void)setItemSelectedTitleColor:(UIColor *)color;

- (CGFloat) widthForTitle;

@end

@protocol CCPageMenuItemDelegate <NSObject>

- (void)menuItemSelected:(CCPageMenuItem *)item;

@end