//
//  LandscapeTableView.h
//  FengHui_iPad
//
//  Created by iPhuan on 13-1-5.
//  Copyright (c) 2013年 iTotem. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ITTLandscapeTableView;
@protocol ITTLandscapeTableViewDataSource;

@protocol ITTLandscapeTableViewDelegate <NSObject>

@optional

- (void)landscapeTableView:(ITTLandscapeTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)landscapeTableView:(ITTLandscapeTableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)landscapeTableViewDidScroll:(UIScrollView *)scrollView;

- (void)landscapeTableViewWillBeginDragging:(UIScrollView *)scrollView;

- (void)landscapeTableViewDidEndDecelerating:(UIScrollView *)scrollView;

@required
- (CGFloat)landscapeTableView:(ITTLandscapeTableView *)tableView widthForRowAtIndexPath:(NSIndexPath *)indexPath;// 返回cell的宽度

@end


@interface ITTLandscapeTableView : UIView

@property (nonatomic, weak) IBOutlet id <ITTLandscapeTableViewDelegate> delegate;
@property (nonatomic, weak) IBOutlet id <ITTLandscapeTableViewDataSource> dataSource;

@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) UIView *tableFooterView;

@property (nonatomic) CGPoint contentOffset;
@property (nonatomic) CGSize  contentSize;
@property (nonatomic) UIEdgeInsets contentInset;
@property (nonatomic) BOOL pagingEnabled;

- (void)reloadData;
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;

@end


@protocol ITTLandscapeTableViewDataSource<NSObject>

@required

- (NSInteger)numberOfRowsInLandscapeTableView:(ITTLandscapeTableView *)tableView;

- (UITableViewCell *)landscapeTableView:(ITTLandscapeTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

