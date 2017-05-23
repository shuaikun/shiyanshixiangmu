//
//  ViewController.m
//  ITTSortableView
//
//  Created by 胡鹏 on 13-8-28.
//  Copyright (c) 2013年 胡鹏. All rights reserved.
//

#import "SortableDemoViewController.h"
#import "OnePieceCell.h"
#import "AppDelegate.h"
#import "ITTSortableView.h"
#import "HomeTabBarController.h"

@interface SortableDemoViewController ()<ITTSortableViewDataSource,ITTSortableViewDelegate,UIScrollViewDelegate>
{
    NSMutableArray  *_datasource;
    ITTSortableView *_sortableView;
}

@end

@implementation SortableDemoViewController

- (void)dealloc
{
    _sortableView.delegate = nil;
    _sortableView.dataSource = nil;
    _sortableView.sortableViewDelegate = nil;
    _sortableView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AppDelegate GetAppDelegate].tabBarController.tabBarHidden = YES;    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _datasource = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13", nil];
	
	_sortableView = [[ITTSortableView alloc] initWithFrame:self.view.bounds];
    
    _sortableView.showsHorizontalScrollIndicator = false;
    _sortableView.showsVerticalScrollIndicator = false;
    _sortableView.alwaysBounceHorizontal = true;
    _sortableView.pagingEnabled = true;
    _sortableView.delegate = self;
    _sortableView.sortableViewDelegate = self;
    _sortableView.dataSource = self;
    _sortableView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_sortableView];
}


- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}


#pragma mark - scrollview delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"here");
}

#pragma mark - ITTSortableViewDataSource

- (NSInteger)numberOfColumnsInITTSortableView:(ITTSortableView *)ITTSortableView
{
    return 2;
}

- (NSInteger)numberOfRowsInITTSortableView:(ITTSortableView *)ITTSortableView
{
    return 4;
}

- (NSInteger)numberOfCellsInITTSortableView:(ITTSortableView *)ITTSortableView
{
    NSLog(@"---%d-----\n%@",[_datasource count],_datasource);
    return [_datasource count];
}


#pragma mark - ITTSortableViewDelegate


- (float)marginTopOfITTSortableView:(ITTSortableView *)ITTSortableView
{
    return 20.0;
}
- (float)marginLeftOfITTSortableView:(ITTSortableView *)ITTSortableView
{
    return 20.0;
}

- (float)horizontalBlockDistanceOfITTSortableView:(ITTSortableView *)ITTSortableView
{
    return 20.0;
}

- (float)verticalBlockDistanceOfITTSortableView:(ITTSortableView *)ITTSortableView
{
    return 20.0;
}

- (float)ITTSortableView:(ITTSortableView *)ITTSortableView heightForCellAtIndex:(NSInteger)index
{
    return is4InchScreen()?90.0:80.0;
}

- (float)ITTSortableView:(ITTSortableView *)ITTSortableView widthForCellAtIndex:(NSInteger)index
{
    return 130.0;
}

- (ITTSortableViewCell *)ITTSortableView:(ITTSortableView *)ITTSortableView cellForRowAtIndex:(NSInteger)index
{
    OnePieceCell *cell = (OnePieceCell *)[ITTSortableView getCellAtIndex:index];
    if (!cell) {
        cell = [OnePieceCell loadFromXib];
    }
    [cell setIndex:[[_datasource objectAtIndex:index] intValue]];
    return cell;
}

- (void)ITTSortableView:(ITTSortableView *)ITTSortableView didSelectCell:(ITTSortableViewCell *)cell atIndex:(NSInteger)index
{
    NSLog(@"%d", index);
    
}

- (void)animationOfSortCellHasCompleted:(ITTSortableView *)ITTSortableView
{
    // refresh data source here
    
    NSLog(@"animationOfSortCellHasCompleted");
}

- (void)ITTSortableView:(ITTSortableView *)ITTSortableView didDelectCell:(ITTSortableViewCell *)cell atIndex:(NSInteger)index
{
    // refresh data source here
    NSLog(@"didDelectCellAtIndex:%d",index);
    [_datasource removeObjectAtIndex:index];
    ITTSortableView.alwaysBounceHorizontal = true;
    
}
@end
