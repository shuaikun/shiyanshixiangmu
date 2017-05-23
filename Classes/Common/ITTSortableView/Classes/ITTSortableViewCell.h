//
//  ITTITTSortableViewCell.h
//  ITTSortableView
//
//  Created by 胡鹏 on 13-8-28.
//  Copyright (c) 2013年 胡鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITTXibView.h"

@class ITTSortableViewCell;

@protocol ITTSortableViewCellDelegate <NSObject>

- (void)didSelectCell:(ITTSortableViewCell *)cell;

- (void)willDeleteCell:(ITTSortableViewCell *)cell;

- (void)switchToEditMode;

@end

@interface ITTSortableViewCell : ITTXibView

@property (nonatomic, unsafe_unretained) BOOL editMode;

@property (nonatomic, unsafe_unretained) NSObject<ITTSortableViewCellDelegate> *delegate;

/**
 *
 *	@param	isEditMode	true if current mode is edit mode,false on the other handle
 */
- (void)currentModeDidChanged:(BOOL)isEditMode;

@end
