//
//  LandscapeTableView.m
//  FengHui_iPad
//
//  Created by iPhuan on 13-1-5.
//  Copyright (c) 2013年 iTotem. All rights reserved.
//

#import "ITTLandscapeTableView.h"

@interface ITTLandscapeTableView () <UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate>
{
    UITableView *_tableView;
}

@end

@implementation ITTLandscapeTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void)setup
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.height, self.frame.size.width)];
    _tableView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.transform = CGAffineTransformMakeRotation(-M_PI/2);
    [self addSubview:_tableView];
    [self performSelector:@selector(reloadData) withObject:self afterDelay:0];
}

#pragma mark - Set

- (CGPoint)contentOffset
{
    return CGPointMake(_tableView.contentOffset.y,_tableView.contentOffset.x);
}

- (void)setContentOffset:(CGPoint)contentOffset
{
    _tableView.contentOffset = CGPointMake(contentOffset.y, contentOffset.x);
}

- (CGSize)contentSize
{
    return CGSizeMake(_tableView.contentSize.height,_tableView.contentSize.width);
}

- (void)setContentSize:(CGSize)contentSize
{
    _tableView.contentSize = CGSizeMake(_tableView.frame.size.width, contentSize.width);
}

- (void)setContentInset:(UIEdgeInsets)contentInset
{
    _tableView.contentInset = UIEdgeInsetsMake(contentInset.left, 0, contentInset.right, 0);
    self.contentOffset = CGPointMake(-contentInset.left, 0);
}

- (void)setPagingEnabled:(BOOL)pagingEnabled
{
    _tableView.pagingEnabled = pagingEnabled;
}

#pragma mark - HeaderView && FootView

- (UIView *)tableHeaderView
{
    return _tableView.tableHeaderView;
}

- (void)setTableHeaderView:(UIView *)tableHeaderView
{
    tableHeaderView.transform = CGAffineTransformMakeRotation(M_PI/2);
    _tableView.tableHeaderView = tableHeaderView;
}

- (UIView *)tableFooterView
{
    return _tableView.tableFooterView;
}

- (void)setTableFooterView:(UIView *)tableFooterView
{
    tableFooterView.transform = CGAffineTransformMakeRotation(M_PI/2);
    _tableView.tableFooterView = tableFooterView;
}

#pragma mark - Public

- (void)reloadData
{
    [_tableView reloadData];
}

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    return [_tableView dequeueReusableCellWithIdentifier:identifier];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dataSource && [_dataSource respondsToSelector:@selector(numberOfRowsInLandscapeTableView:)]) {
        return [_dataSource numberOfRowsInLandscapeTableView:self];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (_dataSource && [_dataSource respondsToSelector:@selector(landscapeTableView:cellForRowAtIndexPath:)]) {
        cell = [_dataSource landscapeTableView:self cellForRowAtIndexPath:indexPath];
    }
    else {
        static NSString *CellIdentifier = @"Cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }

    }
    
    cell.transform = CGAffineTransformMakeRotation(M_PI/2);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataSource && [_dataSource respondsToSelector:@selector(landscapeTableView:widthForRowAtIndexPath:)]) {
        return [_delegate landscapeTableView:self widthForRowAtIndexPath:indexPath];
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate && [_delegate respondsToSelector:@selector(landscapeTableView:didSelectRowAtIndexPath:)]) {
         [_delegate landscapeTableView:self didSelectRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate && [_delegate respondsToSelector:@selector(landscapeTableView:didDeselectRowAtIndexPath:)]) {
         [_delegate landscapeTableView:self didDeselectRowAtIndexPath:indexPath];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_delegate && [_delegate respondsToSelector:@selector(landscapeTableViewDidScroll:)]) {
        [_delegate landscapeTableViewDidScroll:scrollView];
    }

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (_delegate && [_delegate respondsToSelector:@selector(landscapeTableViewWillBeginDragging:)]) {
        [_delegate landscapeTableViewWillBeginDragging:scrollView];
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_delegate && [_delegate respondsToSelector:@selector(landscapeTableViewDidEndDecelerating:)]) {
        [_delegate landscapeTableViewDidEndDecelerating:scrollView];
    }
}

@end
