//
//  CCContentsView.h
//  CCPageViewController
//
//  Created by 詹林 on 16/8/12.
//  Copyright © 2016年 AOLC. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, CCSensitivity) {
    CCSensitivityLow = 0,
    CCSensitivityNormal = 1,
    CCSensitivityHigh = 2
};
@class CCContentsView;
@protocol CCContentsViewDataSource <NSObject>
- (NSInteger) numberOfViewsForContentsView:(CCContentsView * _Nonnull) contentsView;
- (UIView * _Nonnull) placeHolderViewForContentsView:(CCContentsView * _Nonnull) contentsView;

@optional
- (UIView * _Nonnull) contentsView:(CCContentsView * _Nonnull) contentsView viewForRowAtIndex: (NSUInteger) index;
- (UIViewController * _Nonnull) contentsView:(CCContentsView * _Nonnull) contentsView viewControllerForRowAtIndex: (NSUInteger) index;

- (void) contentsView:(CCContentsView * _Nonnull) contentsView willAddViewController:(UIViewController * _Nonnull) childViewControler;
- (void) contentsView:(CCContentsView * _Nonnull) contentsView didAddViewController:(UIViewController * _Nonnull) childViewControler;
- (void) contentsView:(CCContentsView * _Nonnull) contentsView willRemoveViewController:(UIViewController * _Nonnull) childViewControler;
- (void) contentsView:(CCContentsView * _Nonnull) contentsView didRemoveViewController:(UIViewController * _Nonnull) childViewControler;
@end
@protocol CCContentsViewDelegate <NSObject>
- (void) contentsView:(CCContentsView * _Nonnull) contentsView didMoveToIndex: (NSUInteger) index;
@end


@interface CCContentsView : UIView

@property (nonatomic, assign) NSUInteger currentIndex;

@property (nonatomic, assign) NSUInteger cacheSize;
@property (nonatomic, assign) CCSensitivity sensitivity;
@property (nonatomic, assign) BOOL cleanCacheImmediately;
@property (nonatomic, weak, nullable) id<CCContentsViewDataSource> dataSource;
@property (nonatomic, weak, nullable) id<CCContentsViewDelegate> delegate;

- (UIViewController *_Nullable) selectedViewController;
- (UIViewController *_Nullable) viewControllerAtIndex:(NSUInteger) index;

- (void) cleanCache;
- (void) reloadData;
- (void) selectAtIndex: (NSUInteger) index;
@end
