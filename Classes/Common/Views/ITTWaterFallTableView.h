//
//  ITTWaterFallTableView.h
//  meidian
//
//  Created by jack 廉洁 on 5/21/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//  Modifyed by Sword on 24/10/28
//  Convert to ARC, optimization, format
//  Refacotring refresh and load more function
//

#import <UIKit/UIKit.h>

@class ITTWaterFallTableCell;
@protocol ITTWaterFallTableViewDataSource;
@protocol ITTWaterFallTableViewDelegate;

#define ITTWaterFallTableViewColumnNumber       3
#define ITTWaterFallTableViewColumnPadding      5
#define ITTWaterFallTableViewRowPadding         5
#define ITTWaterFallTableViewRecyclePoolSize    6

@interface ITTWaterFallTableView : UIView<UIScrollViewDelegate>
{
}

@property (nonatomic, assign) BOOL waterfallIsLoadingMore;
@property (nonatomic, assign) BOOL waterfallIsRefreshing;
@property (nonatomic, assign) BOOL enablePullToRefresh;

@property (nonatomic, unsafe_unretained) IBOutlet id<ITTWaterFallTableViewDelegate> delegate;
@property (nonatomic, unsafe_unretained) IBOutlet id<ITTWaterFallTableViewDataSource> datasource;

- (void) reloadData;
- (void) didFinishLoading;

- (ITTWaterFallTableCell*)dequeueReusableCellWithIdentifier:(NSString*)reusableCellId;

@end

#pragma mark - delegate
@protocol ITTWaterFallTableViewDelegate <NSObject>
    
@required
- (void)waterFallTableView:(ITTWaterFallTableView*)tableView didSelectedCellAtIndex:(int)index;
    
@optional
- (void)waterFallTableViewDidDrigglerFrefresh:(ITTWaterFallTableView*)tableView;
- (void)waterFallTableViewDidTriggleLoadMore:(ITTWaterFallTableView*)tableView;
@end

#pragma mark - datasource
@protocol ITTWaterFallTableViewDataSource <NSObject>

@required
- (ITTWaterFallTableCell*)waterFallTableView:(ITTWaterFallTableView*)tableView cellAtIndex:(int)index;
- (NSInteger)waterFallTableView:(ITTWaterFallTableView*)tableView heightOfCellAtIndex:(int)index;
- (NSInteger)numberOfRowsWaterFallTableView:(ITTWaterFallTableView*)tableView;

@end