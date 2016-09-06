//
//  CCContentsView.m
//  CCPageViewController
//
//  Created by 詹林 on 16/8/12.
//  Copyright © 2016年 AOLC. All rights reserved.
//

#import "CCContentsView.h"


#import <Masonry/Masonry.h>
typedef NS_ENUM(NSUInteger, CCScrollDirection) {
    CCScrollDirectionNone = 0,
    CCScrollDirectionLeft,
    CCScrollDirectionRight
};
typedef NS_ENUM(NSUInteger, CCDataSourceType) {
    CCDataSourceTypeView = 0,
    CCDataSourceTypeViewController
};
@interface CCContentsView()<UIScrollViewDelegate> {
    
}
@property (nonatomic, strong, nonnull) UIScrollView *scrollView;
@property (nonatomic, strong, nonnull) UIButton *rightButton;
@property (nonatomic, strong, nonnull) NSArray *placeholders;
@property (nonatomic, strong, nonnull) NSMutableDictionary<NSNumber*, UIView*> *cachedContentViews;
@property (nonatomic, strong, nonnull) NSMutableDictionary<NSNumber*, UIViewController*> *cachedContentViewControllers;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint endPoint;
@property (nonatomic, assign) CCDataSourceType dataSourceType;


@end
@implementation CCContentsView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self _setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self _setup];
    }
    return self;
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _setup];
    }
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    NSUInteger count = [self.dataSource numberOfViewsForContentsView:self];
    CGFloat scrollViewWidth = _scrollView.frame.size.width * count;
    _scrollView.contentSize = CGSizeMake(scrollViewWidth, _scrollView.frame.size.height);
}

- (void) setDataSource:(id<CCContentsViewDataSource>)dataSource {
    _dataSource = dataSource;
    
    if ([self.dataSource respondsToSelector:@selector(contentsView:viewForRowAtIndex:)]) {
        _dataSourceType = CCDataSourceTypeView;
    } else if ([self.dataSource respondsToSelector:@selector(contentsView:viewControllerForRowAtIndex:)]) {
        _dataSourceType = CCDataSourceTypeViewController;
    } else {
        [NSException raise:@"Unsupported data source type" format:@"Type is %lu", (unsigned long) _dataSourceType];
    }
}

- (void) placePlaceholder:(UIView *) placeholder atIndex:(NSUInteger) index {
    CGFloat x = _scrollView.frame.size.width * index;
    if(placeholder.superview) {
        if (placeholder.frame.origin.x == x) {
            return;
        }
        [placeholder removeFromSuperview];
    }
    CGRect frame = CGRectMake(x, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    placeholder.frame = frame;
    
    [_scrollView addSubview:placeholder];
}

- (UIViewController *_Nullable) viewControllerAtIndex:(NSUInteger) index {
    NSNumber *cachedViewKey = [NSNumber numberWithInteger:index];
    UIViewController *cachedViewController = [_cachedContentViewControllers objectForKey:cachedViewKey];
    return cachedViewController;
}


- (UIViewController *_Nullable) selectedViewController {
    return [self viewControllerAtIndex: _currentIndex];
}

- (void) reloadData {
    if(self.dataSource == nil) {
        [NSException raise:@"dataSource could not be nil" format:@"CCContentsView's dataSource=%p", self.dataSource];
        return;
    }
    
    [self reset];
    NSMutableArray *placeHolders = [[NSMutableArray alloc] initWithCapacity:2];
    for (NSUInteger i = 0; i<2; i++) {
        UIView *placeHolder = [self.dataSource placeHolderViewForContentsView:self];
        [placeHolders addObject:placeHolder];
        
    }
    self.placeholders = placeHolders;
    [self setNeedsLayout];
}

- (void) _setup {
    
    _cacheSize = 3;
    
    _dataSourceType = CCDataSourceTypeView;
    _sensitivity = CCSensitivityNormal;
    _cleanCacheImmediately = YES;
    
    _cachedContentViews = [[NSMutableDictionary alloc] initWithCapacity:4];
    _cachedContentViewControllers = [[NSMutableDictionary alloc] initWithCapacity:4];
    [self _setupSubviews];
}

- (void) _setupSubviews {
    
    CGRect scrollViewFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _scrollView = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.pagingEnabled = YES;
    [self addSubview:_scrollView];
    
    [_scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(self);
    }];
    
    _scrollView.delegate = self;
}

- (NSUInteger) leftCacheSize {
    return _cacheSize / 2;
}

- (NSUInteger) rightCacheSize {
    return _cacheSize / 2;
}

- (void) reset {
    _currentIndex = -1;
    
    [_cachedContentViews enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UIView * _Nonnull obj, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [_cachedContentViews removeAllObjects];
    
    [_cachedContentViewControllers enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UIViewController * _Nonnull obj, BOOL * _Nonnull stop) {
        [self.dataSource contentsView:self willRemoveViewController:obj];
        [obj.view removeFromSuperview];
        [self.dataSource contentsView:self didRemoveViewController:obj];
    }];
    [_cachedContentViewControllers removeAllObjects];
    _scrollView.contentSize = CGSizeMake(0, 0);
    
}
- (void) updateCachedViewAtIndex:(NSUInteger) index {
    
    NSNumber *cachedViewKey = [NSNumber numberWithInteger:index];
    UIView *cachedView = [_cachedContentViews objectForKey:cachedViewKey];
    
    if (cachedView == nil) {
        cachedView = [self.dataSource contentsView:self viewForRowAtIndex:index];
        cachedView.frame = CGRectMake(_scrollView.frame.size.width * index, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
        [_scrollView addSubview:cachedView];
        [_cachedContentViews setObject:cachedView forKey:cachedViewKey];
    }
}

- (void) updateCachedViewControllerAtIndex:(NSUInteger) index {
    NSNumber *cachedViewKey = [NSNumber numberWithInteger:index];
    UIViewController *cachedViewController = [_cachedContentViewControllers objectForKey:cachedViewKey];
    if (cachedViewController == nil) {
        cachedViewController = [self.dataSource contentsView:self viewControllerForRowAtIndex:index];
        [self.dataSource contentsView:self willAddViewController:cachedViewController];
        cachedViewController.view.frame = CGRectMake(_scrollView.frame.size.width * index, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
        [_scrollView addSubview:cachedViewController.view];
        [self.dataSource contentsView:self didAddViewController:cachedViewController];
        [_cachedContentViewControllers setObject:cachedViewController forKey:cachedViewKey];
    }
}

- (void) updateCacheViews:(NSUInteger) index {
    if (_cleanCacheImmediately) {
        [_cachedContentViews enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UIView * _Nonnull cachedView, BOOL * _Nonnull stop) {
            // if (key.integerValue < (index - 1) || key.integerValue > (index + 1)) {
            if (key.integerValue < (index - self.leftCacheSize) || key.integerValue > (index + self.rightCacheSize)) {
                [cachedView removeFromSuperview];
                [_cachedContentViews removeObjectForKey:key];
            }
        }];
    }
    
    // left
    for (NSInteger i=1; i<=self.leftCacheSize; i++) {
        NSInteger idx = ((NSInteger) index) - i;
        if (idx < 0) {
            break;
        }
        [self updateCachedViewAtIndex: idx];
    }
    
    NSUInteger count = [self.dataSource numberOfViewsForContentsView:self];
    // right
    
    for (NSInteger i=0; i<=self.rightCacheSize; i++) {
        NSInteger idx = ((NSInteger) index) + i;
        if (idx >= count) {
            break;
        }
        [self updateCachedViewAtIndex: idx];
    }
    
    NSLog(@"Cached Views: %lu", (unsigned long)_cachedContentViews.count);
}

- (void) updateCacheViewControllers:(NSUInteger) index {
    if (_cleanCacheImmediately) {
        [_cachedContentViewControllers enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UIViewController * _Nonnull cachedViewController, BOOL * _Nonnull stop) {
            // if (key.integerValue < (index - 1) || key.integerValue > (index + 1)) {
            if (key.integerValue < (index - self.leftCacheSize) || key.integerValue > (index + self.rightCacheSize)) {
                [self.dataSource contentsView:self willRemoveViewController:cachedViewController];
                [cachedViewController.view removeFromSuperview];
                [self.dataSource contentsView:self didRemoveViewController:cachedViewController];
                [_cachedContentViewControllers removeObjectForKey:key];
            }
        }];
    }
    
    // left
    for (NSInteger i=1; i<=self.leftCacheSize; i++) {
        NSInteger idx = ((NSInteger) index) - i;
        if (idx < 0) {
            break;
        }
        [self updateCachedViewControllerAtIndex:idx];
    }
    
    NSUInteger count = [self.dataSource numberOfViewsForContentsView:self];
    // right
    
    for (NSInteger i=0; i<=self.rightCacheSize; i++) {
        NSInteger idx = ((NSInteger) index) + i;
        if (idx >= count) {
            break;
        }
        [self updateCachedViewControllerAtIndex: idx];
    }
    
    // NSLog(@"Cached ViewControllers: %lu", _cachedContentViewControllers.count);
}

- (void) cleanCache {
    NSUInteger index = _currentIndex;
    if (self.dataSourceType == CCDataSourceTypeView) {
        [_cachedContentViews enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UIView * _Nonnull cachedView, BOOL * _Nonnull stop) {
            if (key.integerValue < (index - self.leftCacheSize) || key.integerValue > (index + self.rightCacheSize)) {
                [cachedView removeFromSuperview];
                [_cachedContentViews removeObjectForKey:key];
            }
        }];
    } else if (self.dataSourceType == CCDataSourceTypeViewController) {
        
        [_cachedContentViewControllers enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UIViewController * _Nonnull cachedViewController, BOOL * _Nonnull stop) {
            if (key.integerValue < (index - self.leftCacheSize) || key.integerValue > (index + self.rightCacheSize)) {
                [self.dataSource contentsView:self willRemoveViewController:cachedViewController];
                [cachedViewController.view removeFromSuperview];
                [self.dataSource contentsView:self didRemoveViewController:cachedViewController];
                [_cachedContentViewControllers removeObjectForKey:key];
            }
        }];
    }
}

- (void) moveToIndex: (NSUInteger) index {
    _currentIndex = index;
    if (self.dataSourceType == CCDataSourceTypeView) {
        [self updateCacheViews: index];
    } else if (self.dataSourceType == CCDataSourceTypeViewController) {
        [self updateCacheViewControllers: index];
    }
}

- (void) selectAtIndex: (NSUInteger) index {
    [self moveToIndex:index];
    _scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width * index, 0);
}

- (CCScrollDirection) scrollDirection {
    
    CGFloat standrad = _scrollView.frame.size.width / 4;
    if (_sensitivity == CCSensitivityLow) {
        standrad *= 2.5;
    }
    
    CGFloat delta = _startPoint.x - _endPoint.x;
    if (delta > standrad) {
        return CCScrollDirectionLeft;
    } else if (delta < standrad * -1) {
        return CCScrollDirectionRight;
    } else {
        return CCScrollDirectionNone;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _startPoint = scrollView.contentOffset;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    _endPoint = scrollView.contentOffset;
    
    if (_sensitivity != CCSensitivityNormal) {
        
        CCScrollDirection direction = [self scrollDirection];
        if (direction == CCScrollDirectionLeft) {
            targetContentOffset->x = (_startPoint.x - _scrollView.frame.size.width);
        } else if (direction == CCScrollDirectionRight) {
            targetContentOffset->x = (_startPoint.x + _scrollView.frame.size.width);
        } else {
            targetContentOffset->x = _startPoint.x;
        }
    }
    
    NSUInteger index = targetContentOffset->x / _scrollView.frame.size.width;
    if (_currentIndex != index) {
        [self moveToIndex:index];
        [self.delegate contentsView:self didMoveToIndex:index];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
}


@end
