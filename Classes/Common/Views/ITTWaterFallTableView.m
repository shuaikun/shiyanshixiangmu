//
//  ITTWaterFallTableView.m
//  meidian
//
//  Created by jack 廉洁 on 5/21/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//  Modifyed by Sword on 24/10/28
//  Convert to ARC, optimization, format
//  Refacotring refresh and load more function
//

#import "ITTWaterFallTableView.h"
#import "ITTWaterFallTableCellLayout.h"
#import "ITTRefreshTableHeaderView.h"
#import "ITTLoadMoreTableFooterView.h"
#import "ITTWaterFallTableCell.h"

@interface ITTWaterFallTableView()<ITTLoadMoreTableFooterDelegate, ITTRefreshTableHeaderDelegate, ITTWaterFallTableCellDelegate>
{
    BOOL            _scrolling;
    BOOL            _layouting;
    NSInteger       _currentFirstVisibleCellIndex;
    NSInteger       _currentLastVisibleCellIndex;
    NSMutableArray  *_columnCellFrameArrayByColumn;      //this is used when calculating layouts
    NSMutableArray  *_cellLayoutsArray;                  //store cell layout by cell index order,this is used when layouting cell
    NSMutableSet    *_resuableCellLayoutsSet;
    NSMutableSet    *_reusableCellPool;
    
    NSMutableSet    *_visibleCellSet;
    NSMutableSet    *_recyledCellSet;
    
    ITTRefreshTableHeaderView   *_refreshView;
    ITTLoadMoreTableFooterView  *_loadMoreView;
    
    UIScrollView    *_scrollView;
}

- (void)config;
- (void)setupColumnCellFrameArrayWithColumnCount:(int)columnCount;
- (NSMutableArray*)cellFrameArrayAtColumn:(int)column;

// get calculated cell layout
- (float)leftForColumnAtIndex:(int)columnIndex;
- (ITTWaterFallTableCellLayout*)getLayoutForCellAtIndex:(int)cellIndex;
- (ITTWaterFallTableCellLayout*)getLayoutForNextCellWithCellIndex:(int)cellIndex cellHeight:(float)cellHeight;
- (void)drawVisibleCells;
- (void)recycleInvisibleCells;
- (void)addToRecyclePool:(ITTWaterFallTableCell*)cell;

@end

@implementation ITTWaterFallTableView

#pragma mark - private methods

- (void)setupColumnCellFrameArrayWithColumnCount:(int)columnCount
{
    if (!_columnCellFrameArrayByColumn) {
        _columnCellFrameArrayByColumn  = [[NSMutableArray alloc] init];
    }
    else {
        [_columnCellFrameArrayByColumn removeAllObjects];
    }
    for (int i = 0; i < columnCount; i++) {
        [_columnCellFrameArrayByColumn addObject:[NSMutableArray array]];
    }
    if (!_cellLayoutsArray) {
        _cellLayoutsArray = [[NSMutableArray alloc] init];
    }
}

- (NSMutableArray*)cellFrameArrayAtColumn:(int)column
{
    return [_columnCellFrameArrayByColumn objectAtIndex:column];
}

- (ITTWaterFallTableCellLayout*)getLayoutForCellAtIndex:(int)cellIndex
{
    return [_cellLayoutsArray objectAtIndex:cellIndex];
}

- (float)leftForColumnAtIndex:(int)columnIndex
{
    if (columnIndex == 0) {
        return 0;
    }
    else {
        int columnCount = ITTWaterFallTableViewColumnNumber;
        int colPadding = ITTWaterFallTableViewColumnPadding;
        int columnWidth = (self.width - colPadding*(columnCount - 1))/columnCount;
        return columnIndex * (columnWidth + colPadding);
    }
}

- (ITTWaterFallTableCellLayout*)getCellLayoutWithCellIndex:(int)cellIndex column:(int)column frame:(CGRect)frame
{
    ITTWaterFallTableCellLayout *layout = [_resuableCellLayoutsSet anyObject];
    if (layout) {
        [_resuableCellLayoutsSet removeObject:layout];
    }
    if (!layout) {
        layout = [[ITTWaterFallTableCellLayout alloc] initWithColumn:column frame:frame cellIndex:cellIndex];
    }
    else {
        layout.column = column;
        layout.frame = frame;
        layout.hasDrawnInTableView = NO;
        layout.cellIndex = cellIndex;
    }
    return layout;
}

- (ITTWaterFallTableCellLayout*)getLayoutForNextCellWithCellIndex:(int)cellIndex cellHeight:(float)cellHeight
{
    ITTWaterFallTableCellLayout *layoutForNextCell = nil;
    BOOL startPointFound = NO;
    NSMutableArray *lastCellLayoutForEachColumn = [NSMutableArray array];
    
    int columnCount = ITTWaterFallTableViewColumnNumber;
    int colPadding = ITTWaterFallTableViewColumnPadding;
    int columnWidth = (self.width - colPadding*(columnCount - 1))/columnCount;
    
    for (int col = 0; col < [_columnCellFrameArrayByColumn count]; col++) {
        NSMutableArray *colCellFrameArray = [_columnCellFrameArrayByColumn objectAtIndex:col];
        if ([colCellFrameArray count] == 0) {
            float x = [self leftForColumnAtIndex:col];
            startPointFound = YES;
            CGRect frm = CGRectMake(x, 0, columnWidth, cellHeight);
            layoutForNextCell = [self getCellLayoutWithCellIndex:cellIndex column:col frame:frm];
            break;
        }
        [lastCellLayoutForEachColumn addObject:[colCellFrameArray lastObject]];
    }
    
    if (!startPointFound) {
        float minHeight = MAXFLOAT;
        int column = 0;
        for (int col = 0; col < [lastCellLayoutForEachColumn count]; col++) {
            ITTWaterFallTableCellLayout *layout = [lastCellLayoutForEachColumn objectAtIndex:col];
            if ([layout getBottom] < minHeight) {
                minHeight = [layout getBottom];
                column = col;
            }
        }
        float x = [self leftForColumnAtIndex:column];
        CGRect frm = CGRectMake(x, minHeight + ITTWaterFallTableViewRowPadding, columnWidth, cellHeight);
        layoutForNextCell = [self getCellLayoutWithCellIndex:cellIndex column:column frame:frm];
    }
    return layoutForNextCell;
    
}

- (int)getIndexByCell:(ITTWaterFallTableCell*)cell
{
    for (int i = 0; i<[_cellLayoutsArray count]; i++) {
        ITTWaterFallTableCellLayout *layout = [_cellLayoutsArray objectAtIndex:i];
        if ((int)(cell.left) == (int)(layout.x) && (int)(cell.top) == (int)(layout.y)) {
            return i;
        }
    }
    return -1;
}

- (void)config
{
    _scrolling = FALSE;
    //prepare reusable pool
    _resuableCellLayoutsSet = [[NSMutableSet alloc] init];
    if (!_reusableCellPool) {
        _reusableCellPool  = [[NSMutableSet alloc] init];
    }
    else {
        [_reusableCellPool removeAllObjects];
    }
    if (!_visibleCellSet) {
        _visibleCellSet = [[NSMutableSet alloc] init];
    }
    else {
        [_visibleCellSet removeAllObjects];
    }
    if (!_recyledCellSet) {
        _recyledCellSet = [[NSMutableSet alloc] init];
    }
    else {
        [_recyledCellSet removeAllObjects];
    }
    //add scroll view
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds) + 6, CGRectGetHeight(self.bounds))];
        _scrollView.clipsToBounds = TRUE;
    }
    if (!_scrollView.superview) {
        [self addSubview:_scrollView];
    }
    _enablePullToRefresh = FALSE;
    _scrollView.delegate = self;
    
    /* Refresh View */
    _refreshView = [[ITTRefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -self.bounds.size.height, self.bounds.size.width, self.bounds.size.height)];
    _refreshView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    _refreshView.delegate = self;
    [_scrollView addSubview:_refreshView];
    
    /* Load more view init */
    _loadMoreView = [[ITTLoadMoreTableFooterView alloc] initWithFrame:CGRectMake(0, _scrollView.bounds.size.height, _scrollView.bounds.size.width, self.bounds.size.height)];
    _loadMoreView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _loadMoreView.delegate = self;
    [_scrollView addSubview:_loadMoreView];
}

- (void)endScroll
{
    _scrolling = FALSE;
    //load image data here
    for (ITTWaterFallTableCell *cell in _visibleCellSet) {
        cell.scrolling = _scrolling;
        [cell setNeedsLayout];
    }
}
    
- (void)setEnablePullToRefresh:(BOOL)enablePullToRefresh
{
    _enablePullToRefresh = enablePullToRefresh;
    if (_enablePullToRefresh) {
        _refreshView.hidden = FALSE;
    }
    else {
        _loadMoreView.hidden = TRUE;
    }
}

- (BOOL)isCellDisplayingAtIndex:(NSInteger)index
{
    BOOL found = FALSE;
    for (ITTWaterFallTableCell *cell in _visibleCellSet) {
        if (cell.index == index) {
            found = TRUE;
            break;
        }
    }
    return found;
}

- (BOOL)isCellVisibleRangeDidChanged
{
    NSInteger firstCellIndex = [self getFirstVisibleCellIndex];
    NSInteger lastCellIndex = [self getLastVisibleCellIndex];
    return (firstCellIndex != _currentFirstVisibleCellIndex||
            lastCellIndex != _currentLastVisibleCellIndex);
}

- (void)addToRecyclePool:(ITTWaterFallTableCell*)cell
{
    [_reusableCellPool addObject:cell];
    //    if ([_reusableCellPool count] > ITTWaterFallTableViewRecyclePoolSize)
    //    {
    //        return;
    //    }
}

- (void)reuseAllCellLayouts
{
    if (_cellLayoutsArray && [_cellLayoutsArray count]) {
        for (ITTWaterFallTableCellLayout *layout in _cellLayoutsArray) {
            layout.cell = nil;
            layout.cell.scrolling = FALSE;
            layout.hasDrawnInTableView = NO;
            layout.cellIndex = NSNotFound;
        }
        [_resuableCellLayoutsSet addObjectsFromArray:_cellLayoutsArray];
        [_cellLayoutsArray removeAllObjects];
    }
}

- (void)recycleAllCells
{
    for (ITTWaterFallTableCell *cell in _visibleCellSet) {
        cell.scrolling = FALSE;
        cell.index = NSNotFound;
        [cell recyleAllComponents];
        [_recyledCellSet addObject:cell];
        [cell removeFromSuperview];
    }
    [_visibleCellSet minusSet:_recyledCellSet];
}

- (void)recycleInvisibleCells
{
    NSInteger firstCellIndex = [self getFirstVisibleCellIndex];
    NSInteger lastCellIndex = [self getLastVisibleCellIndex];
    //    ITTDINFO(@"firstCellIndex %d lastCellIndex %d", firstCellIndex, lastCellIndex);
    for (ITTWaterFallTableCell *cell in _visibleCellSet) {
        //        ITTDINFO(@"cell index %d _cellLayoutsArray count %d _visibleCellSet %d", cell.index, [_cellLayoutsArray count], [_visibleCellSet count]);
        if (cell.index < firstCellIndex||(lastCellIndex >= 0 && cell.index > lastCellIndex)) {
            cell.scrolling = FALSE;
            [cell recyleAllComponents];
            ITTWaterFallTableCellLayout *layout = [_cellLayoutsArray objectAtIndex:cell.index];
            layout.cell = nil;
            layout.hasDrawnInTableView = NO;
            //            ITTDINFO(@"recyle cell index %d cell index %d", layout.cellIndex, cell.index);
            cell.index = NSNotFound;
            [_recyledCellSet addObject:cell];
            [cell removeFromSuperview];
        }
    }
    [_visibleCellSet minusSet:_recyledCellSet];
}

- (void)drawVisibleCells
{
    NSInteger firstCellIndex = [self getFirstVisibleCellIndex];
    NSInteger lastCellIndex = [self getLastVisibleCellIndex];
    for (NSInteger cellIndex = firstCellIndex; cellIndex <= lastCellIndex; cellIndex++) {
        ITTWaterFallTableCellLayout *layout = [_cellLayoutsArray objectAtIndex:cellIndex];
        if (!layout.hasDrawnInTableView) {
            ITTWaterFallTableCell *cell = layout.cell;
            if (!cell) {
                cell = [_datasource waterFallTableView:self cellAtIndex:cellIndex];
            }
            else {
            }
            layout.cell = cell;
            cell.scrolling = _scrolling;
            cell.delegate = self;
            cell.index = cellIndex;
            cell.frame = [layout getFrame];
            [_scrollView addSubview:cell];
            layout.hasDrawnInTableView = YES;
            [_visibleCellSet addObject:cell];
        }
    }
}

#pragma mark - lifecyle methods
- (void)dealloc
{
    _delegate = nil;
    _datasource = nil;
    _refreshView.delegate = nil;
    _refreshView = nil;
    _loadMoreView.delegate = nil;
    _loadMoreView = nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self drawVisibleCells];
    CGFloat visibleTableDiffBoundsHeight = (_scrollView.bounds.size.height - MIN(_scrollView.bounds.size.height, _scrollView.contentSize.height));
    CGRect loadMoreFrame = _loadMoreView.frame;
    loadMoreFrame.origin.y = _scrollView.contentSize.height + visibleTableDiffBoundsHeight;
    _loadMoreView.frame = loadMoreFrame;
}
    
- (void)awakeFromNib
{
    [super awakeFromNib];
    ITTDINFO(@"- (void)awakeFromNib");
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    ITTDINFO(@"- (id)initWithCoder:(NSCoder *)aDecoder");
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self config];
        [self config];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self config];
        [self config];
    }
    return self;
}

- (void)setDatasource:(id<ITTWaterFallTableViewDataSource>)datasource
{
    _datasource = datasource;
    [self reloadData];
}

- (void)didFinishLoading
{
    self.waterfallIsRefreshing = FALSE;
    self.waterfallIsLoadingMore = FALSE;
}
    
- (void)setWaterfallIsRefreshing:(BOOL)waterfallIsRefreshing
{
    //XOR operation
    if (waterfallIsRefreshing^_waterfallIsRefreshing) {
        if (waterfallIsRefreshing) {
            [_refreshView startAnimatingWithScrollView:_scrollView];
        }
        else {
            [_refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:_scrollView];
        }
        _waterfallIsRefreshing = waterfallIsRefreshing;
    }
}
    
- (void)setWaterfallIsLoadingMore:(BOOL)waterfallIsLoadingMore
{
    //XOR operation
    if (waterfallIsLoadingMore^_waterfallIsLoadingMore) {
        if (waterfallIsLoadingMore) {
            [_loadMoreView startAnimatingWithScrollView:_scrollView];
        }
        else {
            [_loadMoreView egoRefreshScrollViewDataSourceDidFinishedLoading:_scrollView];
        }
        _waterfallIsLoadingMore = waterfallIsLoadingMore;
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _scrolling = TRUE;
    [_refreshView egoRefreshScrollViewWillBeginDragging:scrollView];
}
    
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!_waterfallIsRefreshing) {
        [_refreshView egoRefreshScrollViewDidScroll:scrollView];
    }
    if (!_waterfallIsLoadingMore) {
        [_loadMoreView egoRefreshScrollViewDidScroll:scrollView];
    }
    if (scrollView.contentOffset.y < 0) {
        return;
    }
    if ([self isCellVisibleRangeDidChanged]) {
        if (!_layouting) {
            _layouting = TRUE;
            [self recycleInvisibleCells];
            [self setNeedsLayout];
            _layouting = FALSE;
        }
    }
}
    
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    ITTDINFO(@"scrollViewDidEndDragging");
    if (scrollView.contentOffset.y < 0) {
        if (!_waterfallIsRefreshing) {
            [_refreshView egoRefreshScrollViewDidEndDragging:scrollView];
        }
    }
    else {
        if (!_waterfallIsLoadingMore) {
            [_loadMoreView egoRefreshScrollViewDidEndDragging:scrollView];
        }
    }
    if (!decelerate) {
        [self endScroll];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    ITTDINFO(@"scrollViewDidEndDecelerating");
    [self endScroll];
}

#pragma mark - public methods
- (ITTWaterFallTableCell*)dequeueReusableCellWithIdentifier:(NSString*)reusableCellId
{
    ITTWaterFallTableCell *reuseCell = nil;
    for (ITTWaterFallTableCell *cell in _recyledCellSet) {
        if ([cell.reusableCellId isEqualToString:reusableCellId]) {
            reuseCell = cell;
            [_recyledCellSet removeObject:cell];
            break;
        }
    }
    return reuseCell;
}

- (NSInteger)getFirstVisibleCellIndex
{
    NSInteger index = 0;
    NSInteger count = [_cellLayoutsArray count];
    while (index < count) {
        ITTWaterFallTableCellLayout *layout = [_cellLayoutsArray objectAtIndex:index];
        if ([layout isVisibleInRect:_scrollView.bounds]) {
            break;
        }
        index++;
    }
    return index;
}

- (NSInteger)getLastVisibleCellIndex
{
    NSInteger count = [_cellLayoutsArray count];
    NSInteger index = count - 1;
    while (index >= 0) {
        ITTWaterFallTableCellLayout *layout = [_cellLayoutsArray objectAtIndex:index];
        if ([layout isVisibleInRect:_scrollView.bounds]) {
            break;
        }
        index--;
    }
    return index;
}

- (void)reloadData
{
    if (!_datasource) {
        ITTDERROR(@"no datasource found for waterFallTableView:%@", self);
    }
    else {
        [self recycleAllCells];
        [self reuseAllCellLayouts];
        //setup columnCellFrameArray , build basic cell layout structure
        [self setupColumnCellFrameArrayWithColumnCount:ITTWaterFallTableViewColumnNumber];
        int cellCount = [_datasource numberOfRowsWaterFallTableView:self];
        //calculate height and get all cell layout
        int maxHeight = 0;
        for (int i = 0; i < cellCount; i++) {
            int height = [_datasource waterFallTableView:self heightOfCellAtIndex:i];
            ITTWaterFallTableCellLayout *layout = [self getLayoutForNextCellWithCellIndex:i cellHeight:height];
            [_cellLayoutsArray addObject:layout];
            [[self cellFrameArrayAtColumn:layout.column] addObject:layout];
            maxHeight = MAX(maxHeight, [layout getBottom]);
        }
        if (maxHeight < CGRectGetHeight(_scrollView.frame)) {
            maxHeight = CGRectGetHeight(_scrollView.frame) + 20;
        }
        [_scrollView setContentSize:CGSizeMake(self.bounds.size.width, maxHeight)];
        [self setNeedsLayout];
    }
}

#pragma mark - ITTWaterFallTableCellDelegate methods
- (void)waterFallTableCellSelected:(ITTWaterFallTableCell*)cell
{
    if (_delegate && [_delegate respondsToSelector:@selector(waterFallTableView:didSelectedCellAtIndex:)]) {
        [_delegate waterFallTableView:self didSelectedCellAtIndex:cell.index];
    }
}

#pragma mark - ITTRefreshTableHeaderDelegate methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(ITTRefreshTableHeaderView*)view
{
    if (_enablePullToRefresh) {
        if (_delegate && [_delegate respondsToSelector:@selector(waterFallTableViewDidDrigglerFrefresh:)]) {
            _waterfallIsRefreshing = TRUE;
            [_delegate waterFallTableViewDidDrigglerFrefresh:self];
        }
    }
}
    
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(ITTRefreshTableHeaderView*)view
{
    return [NSDate date];
}
    
#pragma mark - ITTLoadMoreTableFooterViewDelegate methods
- (void)loadMoreTableFooterDidTriggerLoadMore:(ITTLoadMoreTableFooterView*)view
{
    if (_delegate && [_delegate respondsToSelector:@selector(waterFallTableViewDidTriggleLoadMore:)]) {
        _waterfallIsLoadingMore = TRUE;
        [_delegate waterFallTableViewDidTriggleLoadMore:self];
    }
}

@end
