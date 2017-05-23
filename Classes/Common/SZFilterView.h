//
//  SZFilterView.h
//  iTotemFramework
//
//  Created by 王琦 on 14-4-15.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "ITTXibView.h"

@protocol SZFilterViewDelegate <NSObject>

- (void)filterViewOneConditionButtonTapped:(int)filterConditionIndex;

@end

@interface SZFilterView : ITTXibView

@property (assign, nonatomic) id<SZFilterViewDelegate>delegate;

- (void)setFilterConditionTitle:(NSString *)filterCondition Index:(int)filterConditionIndex;

@end
