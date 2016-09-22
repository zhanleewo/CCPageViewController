//
//  CCPageMenu.m
//  CCPageViewController
//
//  Created by 詹林 on 16/8/12.
//  Copyright © 2016年 AOLC. All rights reserved.
//

#import "CCPageMenu.h"

#import <Masonry/Masonry.h>

@interface CCPageMenu() <CCPageMenuItemDelegate>
@property (nonatomic, strong, nonnull) UIScrollView *scrollView;
@property (nonatomic, strong, nonnull) UIButton *rightButton;
@property (nonatomic, strong, nonnull) NSMutableArray<CCPageMenuItem *> *items;
@property (nonatomic, weak, nullable) CCPageMenuItem *selectedItem;
@end

@implementation CCPageMenu

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
/**
 
 
 @property (nonatomic, assign) BOOL showBorderline;
 @property (nonatomic, strong, nonnull) UIColor *borderLineColor;
 @property (nonatomic, assign) CGFloat borderLineWeight;
 
 @property (nonatomic, strong, nonnull) UIColor *titleFont;
 @property (nonatomic, strong, nonnull) UIColor *titleSelectedFont;
 @property (nonatomic, strong, nonnull) UIColor *titleColor;
 @property (nonatomic, strong, nonnull) UIColor *titleSelectedColor;
 
 @property (nonatomic, assign) BOOL showUnderline;
 @property (nonatomic, strong, nullable) UIColor *underLineColor;
 @property (nonatomic, assign) CGFloat underLineWeight;
 */

- (void) setShowBorderline:(BOOL)showBorderline {
    _showBorderline = showBorderline;
    [self setNeedsLayout];
}

- (void) setBorderLineColor:(UIColor *)borderLineColor {
    _borderLineColor = borderLineColor;
    [self setNeedsLayout];
}

- (void) setBorderLineWeight:(CGFloat)borderLineWeight {
    _borderLineWeight = borderLineWeight;
    [self setNeedsLayout];
}

- (void) setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    [self setNeedsLayout];
}

- (void) setTitleSelectedFont:(UIFont *)titleSelectedFont {
    _titleSelectedFont = titleSelectedFont;
    [self setNeedsLayout];
}

- (void) setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    [self setNeedsLayout];
}
- (void) setTitleSelectedColor:(UIColor *)titleSelectedColor {
    _titleSelectedColor = titleSelectedColor;
    [self setNeedsLayout];
    
}
- (void) setShowUnderline:(BOOL)showUnderline {
    _showUnderline = showUnderline;
    [self setNeedsLayout];
    
}
- (void) setUnderLineColor:(UIColor *)underLineColor {
    _underLineColor = underLineColor;
    [self setNeedsLayout];
}
- (void) setUnderLineWeight:(CGFloat)underLineWeight {
    _underLineWeight =  underLineWeight;
    [self setNeedsLayout];
}

- (void) layoutSubviews {
    
    [super layoutSubviews];
}
- (void) _setup {
    
    _showBorderline = NO;
    _borderLineColor = nil;
    _borderLineWeight = 0.0f;
    
    _titleFont = nil;
    _titleSelectedFont = nil;
    _titleColor = nil;
    _titleSelectedColor = nil;
    
    _showUnderline = NO;
    _underLineColor = nil;
    _underLineWeight = 0.0f;
    
    [self _setupSubviews];
}

- (void) _setupSubviews {
    
    CGRect scrollViewFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _scrollView = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = NO;
    
    [self addSubview:_scrollView];
}

- (void) rightButtonAction: (UIButton *) button {
    if ([self.delegate respondsToSelector:@selector(pageMenu:rightButtonClicked:)]) {
        [self.delegate pageMenu:self rightButtonClicked:button];
    }
}

- (void) _layoutScrollview {
    
    [_items makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_items removeAllObjects];
    
    NSUInteger count = [self.dataSource numberOfItemsForPageMenu:self];
    
    CGFloat itemX = 0;
    for(NSUInteger i=0; i< count; i++) {
        CCPageMenuItem *item = nil;
        if ([self.dataSource respondsToSelector:@selector(pageMenu:viewForRowAtIndex:)]) {
            item = [self.dataSource pageMenu:self viewForRowAtIndex:i];
        } else if ([self.dataSource respondsToSelector:@selector(pageMenu:textForRowAtIndex:)]) {
            NSString *title = [self.dataSource pageMenu:self textForRowAtIndex:i];
            item = [[CCPageMenuItem alloc] init];
            [item setItemTitle:title];
            
            
            if (_titleFont) {
                [item setItemTitleFont:_titleFont.pointSize];
            }
            
            if (_titleColor) {
                [item setItemTitleColor:_titleColor];
            }
            
            if (_titleSelectedFont) {
                
                [item setItemSelectedTileFont:_titleSelectedFont.pointSize];
            }
            
            if (_titleSelectedColor) {
                [item setItemSelectedTitleColor:_titleSelectedColor];
            }
            
        }
        
        if (item != nil) {
            item.delegate = self;
            CGFloat itemW = [item widthForTitle];
            item.frame = CGRectMake(itemX, 0, itemW, _scrollView.frame.size.height);
            [_scrollView addSubview:item];
            [_items addObject:item];
            itemX = CGRectGetMaxX(item.frame);
        }
    }
    _scrollView.contentSize = CGSizeMake(itemX, _scrollView.frame.size.height);
}

- (void) _layoutSubviews {
    if ([self.dataSource respondsToSelector:@selector(rightButtonForPageMenu:)]) {
        _rightButton = [self.dataSource rightButtonForPageMenu:self];
    }
    
    if (_rightButton) {
        
        [_rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        CGRect scrollViewFrame = CGRectMake(0, 0, self.frame.size.width - self.frame.size.height, self.frame.size.height);
        _scrollView.frame = scrollViewFrame;
        
        
        CGRect rightButtonFrame = CGRectMake(0, self.frame.size.width - self.frame.size.height, self.frame.size.height, self.frame.size.height);
        _rightButton.frame = rightButtonFrame;
        
        if (_rightButton.superview == nil) {
            [self addSubview:_rightButton];
        }
        
        [_scrollView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.equalTo(@0);
            make.right.equalTo(self.rightButton.mas_left);
            make.height.equalTo(self);
        }];
        
        [_rightButton makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self.scrollView.mas_right);
            make.right.equalTo(self);
            make.height.equalTo(self);
            make.width.equalTo(_rightButton.height);
        }];
    } else {
        
        [_scrollView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.height.equalTo(self);
        }];
    }
    
    [self _layoutScrollview];
    
}


- (void) reloadData {
    if (self.dataSource == nil || self.delegate == nil) {
        [NSException raise:@"dataSource and delegate cloud not be nil" format:@"dataSource=%p, delegate=%p", self.dataSource, self.delegate];
        return;
    }
    
    NSUInteger count = [self.dataSource numberOfItemsForPageMenu:self];
    _items = [[NSMutableArray alloc] initWithCapacity:count];
    [self _layoutSubviews];
}

- (void) scrollToSelectedItem {
    CGPoint scrollPoint;
    
    if (_scrollView.contentSize.width <= self.frame.size.width) {
        scrollPoint = CGPointMake(0.0f,0.0f);
    } else {
        CGFloat btnX = _selectedItem.frame.origin.x;
        CGFloat btnCenterX = _selectedItem.center.x;
        
        if (btnCenterX <= _scrollView.frame.size.width/2) {
            scrollPoint = CGPointMake(0.0f,0.0f);
        } else if (_scrollView.contentSize.width - btnCenterX <= _scrollView.frame.size.width / 2) {
            scrollPoint = CGPointMake(_scrollView.contentSize.width - _scrollView.frame.size.width, 0.0f);
        } else {
            scrollPoint = CGPointMake(btnCenterX - _scrollView.center.x, 0);
        }
    }
    [_scrollView setContentOffset:scrollPoint animated:YES];
}

- (void) selectAtIndex:(NSUInteger) index {
    
    if (index >= _items.count) {
        [NSException raise:@"Index out of bounds" format:@"size=%lu, index=%lu", (unsigned long)_items.count, (unsigned long)index];
        return;
    }
    
    if(_selectedItem != nil) {
        _selectedItem.selected = NO;
    }
    
    _selectedItem = _items[index];
    _selectedItem.selected = YES;
    
    [self scrollToSelectedItem];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if(_showBorderline) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
        
        // Draw them with a 2.0 stroke width so they are a bit more visible.
        CGContextSetLineWidth(context, 0.5f);
        
        CGContextMoveToPoint(context, 0.0f, self.frame.size.height - 0.5f); //start at this point
        
        CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height - 0.5f); //draw to this point
        
        // and now draw the Path!
        CGContextStrokePath(context);
    }
}

- (void)menuItemSelected:(CCPageMenuItem *)item {
    
    if(_selectedItem != nil && item != _selectedItem) {
        _selectedItem.selected = NO;
    }
    
    
    _selectedItem = item;
    
    [self scrollToSelectedItem];
    
    NSUInteger index = [self.items indexOfObject:_selectedItem];
    if ([self.delegate respondsToSelector:@selector(pageMenu:didSelectAtIndex:)]) {
        [self.delegate pageMenu:self didSelectAtIndex:index];
    }
}
@end
