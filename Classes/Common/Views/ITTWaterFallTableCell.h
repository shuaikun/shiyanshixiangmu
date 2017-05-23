//
//  ITTWaterFallTableCell.h
//  meidian
//
//  Created by jack 廉洁 on 5/21/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//  Modifyed by Sword on 24/10/28
//  Convert to ARC, optimization, format
//  Refacotring refresh and load more function
//

#import <UIKit/UIKit.h>
@protocol ITTWaterFallTableCellDelegate;

@interface ITTWaterFallTableCell : UIView
{    
}

+ (id)cellFromNib;

+ (id)cellFromNibWithIdentifier:(NSString*)identifier;

@property (nonatomic, unsafe_unretained) id<ITTWaterFallTableCellDelegate> delegate;
@property (nonatomic, assign) BOOL scrolling;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSString *reusableCellId;

- (BOOL)isVisibleInRect:(CGRect)rect;
- (void) recyleAllComponents;
@end

@protocol ITTWaterFallTableCellDelegate <NSObject>
@optional
- (void)waterFallTableCellSelected:(ITTWaterFallTableCell*)cell;
@end
