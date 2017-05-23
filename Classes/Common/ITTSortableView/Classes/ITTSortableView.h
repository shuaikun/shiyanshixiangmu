//
//  ITTSortableView.h
//  ITTSortableView
//
//  Created by 胡鹏 on 13-8-28.
//  Copyright (c) 2013年 胡鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITTSortableViewCell.h"

@class ITTSortableView;

@protocol ITTSortableViewDataSource <NSObject>

@optional
- (NSInteger)numberOfColumnsInITTSortableView:(ITTSortableView *)sortableView;

- (NSInteger)numberOfRowsInITTSortableView:(ITTSortableView *)sortableView;

@required

- (NSInteger)numberOfCellsInITTSortableView:(ITTSortableView *)sortableView;

@end

@protocol ITTSortableViewDelegate <NSObject>

@optional

- (float)marginTopOfITTSortableView:(ITTSortableView *)sortableView;

- (float)marginLeftOfITTSortableView:(ITTSortableView *)sortableView;

- (float)horizontalBlockDistanceOfITTSortableView:(ITTSortableView *)sortableView;

- (float)verticalBlockDistanceOfITTSortableView:(ITTSortableView *)sortableView;

- (void)animationOfSortCellHasCompleted:(ITTSortableView *)sortableView;

- (void)ITTSortableView:(ITTSortableView *)sortableView didSelectCell:(ITTSortableViewCell *)cell atIndex:(NSInteger)index;

- (void)ITTSortableView:(ITTSortableView *)sortableView willDelectCell:(ITTSortableViewCell *)cell atIndex:(NSInteger)index;

- (void)ITTSortableView:(ITTSortableView *)sortableView didDelectCell:(ITTSortableViewCell *)cell atIndex:(NSInteger)index;

@required

- (float)ITTSortableView:(ITTSortableView *)sortableView heightForCellAtIndex:(NSInteger)index;

- (float)ITTSortableView:(ITTSortableView *)sortableView widthForCellAtIndex:(NSInteger)index;

- (ITTSortableViewCell *)ITTSortableView:(ITTSortableView *)sortableView cellForRowAtIndex:(NSInteger)index;


@end

@interface ITTSortableView : UIScrollView<ITTSortableViewCellDelegate>

@property (nonatomic, unsafe_unretained) id<ITTSortableViewDataSource> dataSource;
@property (nonatomic, unsafe_unretained) id<ITTSortableViewDelegate> sortableViewDelegate;

@property (nonatomic, assign) BOOL editMode;



- (void)reloadData;

- (ITTSortableViewCell *)getCellAtIndex:(NSInteger)index;

@end
