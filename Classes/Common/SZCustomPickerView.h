//
//  SZCustomPickerView.h
//  iTotemFramework
//
//  Created by 王琦 on 14-4-16.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "ITTXibView.h"

@class SZCustomPickerView;

@protocol SZCustomPickerViewDelegate <NSObject>
- (void)pickViewSelectedString:(NSString *)string Condition:(int)filterCondition SearchCondition:(int)searchCondition SearchId:(NSString *)searchId;
@end

@interface SZCustomPickerView : ITTXibView

@property (assign, nonatomic) int filterCondition;
@property (assign, nonatomic) int currentPlace;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (assign, nonatomic) id<SZCustomPickerViewDelegate>delegate;

- (void)hide;
- (void)updateDataWithCondition:(int)filterCondition;
- (void)updateDataWithCondition:(int)filterCondition outPlace:(BOOL)outPlace;

@end
