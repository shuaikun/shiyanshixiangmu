//
//  SMOnButtonCell.h
//  com.knowesoft.oax
//
//  Created by Golun on 14-9-3.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import <UIKit/UIKit.h> 

@protocol SMOnButtonCellDelegate <NSObject>
- (void)SMOnButtonCellDelegateTapped:(SMOnButtonCellOperType *)operType forObject:(int)tag;
@end

@interface SMOnButtonCell : UITableViewCell
@property (assign, nonatomic) int index;
@property (assign, nonatomic) id<SMOnButtonCellDelegate>delegate;
+ (SMOnButtonCell *)cellFromNib;
- (void)setData:(SMOnButtonCellOperType *)operType from:(id)target;
@end
