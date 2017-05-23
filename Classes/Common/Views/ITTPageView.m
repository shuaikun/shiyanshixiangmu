//
//  ITTPageView.m
//  AiQiChe
//
//  Created by lian jie on 7/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ITTPageView.h"

@interface ITTPageView(){
    UIImageView *_selectedDotView;
}
- (CGFloat)getPageViewWidth:(int)pageNum;
- (CGFloat)getDotXWithIndex:(int)index;
@end

@implementation ITTPageView

- (void)setImageDot:(NSString *)imageDot
{
    _imageDot = [imageDot copy];
    NSArray *subview = self.subviews;
    for (UIImageView *sub in subview) {
        if (sub.tag>=100) {
            sub.image = [UIImage imageNamed:imageDot];
        }
    }
    
}

- (void)setImageDotH:(NSString *)imageDotH
{
    _imageDotH = [imageDotH copy];
    _selectedDotView.image = [UIImage imageNamed:imageDotH];
}
- (CGFloat)getPageViewWidth:(int)pageNum
{
    return pageNum * PAGE_VIEW_DOT_WIDTH + (pageNum - 1) * PAGE_VIEW_SPACE_BETWEEN_DOTS;
}

- (CGFloat)getDotXWithIndex:(int)index
{
    return index * (PAGE_VIEW_SPACE_BETWEEN_DOTS + PAGE_VIEW_DOT_WIDTH);
}

- (id)initWithPageNum:(int)pageNum
{
    self = [super initWithFrame:CGRectMake(0, 0, [self getPageViewWidth:pageNum], PAGE_VIEW_DOT_HEIGHT)];
    if (self) {
        _currentPage = 0;
        _pageNum = pageNum;
        
        for (int i = 0; i < _pageNum; i++) {
            UIImageView *dotView = [[UIImageView alloc] initWithFrame:CGRectMake([self getDotXWithIndex:i], 0, PAGE_VIEW_DOT_WIDTH, PAGE_VIEW_DOT_HEIGHT)];
            dotView.tag = i+100;
            dotView.image = [UIImage imageNamed:PAGE_VIEW_DOT_IMAGE];
            [self addSubview:dotView];
        }
        
        _selectedDotView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, PAGE_VIEW_DOT_WIDTH, PAGE_VIEW_DOT_HEIGHT)];
        _selectedDotView.image = [UIImage imageNamed:PAGE_VIEW_SELECTED_DOT_IMAGE];
        [self addSubview:_selectedDotView];
        
    }
    return self;
}

- (void)setInitStateFromNib:(int)pageNum
{
//    self.frame = CGRectMake(self.left, self.top, [self getPageViewWidth:pageNum], PAGE_VIEW_DOT_HEIGHT);
    _currentPage = 0;
    _pageNum = pageNum;
    
    for (int i = 0; i < _pageNum; i++) {
        UIImageView *dotView = [[UIImageView alloc] initWithFrame:CGRectMake([self getDotXWithIndex:i], 0, PAGE_VIEW_DOT_WIDTH, PAGE_VIEW_DOT_HEIGHT)];
        dotView.image = [UIImage imageNamed:PAGE_VIEW_DOT_IMAGE];
        [self addSubview:dotView];
    }
    
    _selectedDotView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, PAGE_VIEW_DOT_WIDTH, PAGE_VIEW_DOT_HEIGHT)];
    _selectedDotView.image = [UIImage imageNamed:PAGE_VIEW_SELECTED_DOT_IMAGE];
    [self addSubview:_selectedDotView];
}

- (void)setCurrentPage:(int)currentPage
{
    _currentPage = currentPage;
    _selectedDotView.left = [self getDotXWithIndex:_currentPage];
}

@end
