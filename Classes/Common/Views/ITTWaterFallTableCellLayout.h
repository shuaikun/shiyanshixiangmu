//
//  ITTWaterFallTableCellLayoutPosition.h
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

@interface ITTWaterFallTableCellLayout : NSObject

@property (nonatomic, assign) int column;
@property (nonatomic, assign) float x;
@property (nonatomic, assign) float y;
@property (nonatomic, assign) float width;
@property (nonatomic, assign) float height;
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign) int cellIndex;
@property (nonatomic, assign) BOOL hasDrawnInTableView;
@property (nonatomic, weak) ITTWaterFallTableCell *cell;

- (id)initWithColumn:(int)column frame:(CGRect)frame cellIndex:(int)cellIndex;
- (float)getBottom;
- (BOOL)isVisibleInRect:(CGRect)rect;
- (CGRect)getFrame;
@end
