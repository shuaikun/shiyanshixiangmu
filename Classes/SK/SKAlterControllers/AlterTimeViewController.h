//
//  AlterTimeViewController.h
//  selectTime
//
//  Created by caoshuaikun on 2017/1/10.
//  Copyright © 2017年 wuxiwenyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header_StaticDefine.h"

@interface AlterTimeViewController : UIAlertController<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) UIButton * buttonAffire;//确认
@property (nonatomic, strong) UIButton * buttonCancel;//取消
    
@property (nonatomic, strong) UIDatePicker * datePickView;//时间选择器
@property (nonatomic, strong) UIPickerView * pickView;//选择
    
@property (nonatomic, assign) selectType selecetGenderOrBrith;
@property (nonatomic, strong) NSArray * selectArray;//选择的所有信息
    
@property (nonatomic, copy) NSString * selectMessge;//选择的最后信息
@property (nonatomic, copy) NSString * dateType;

@property (nonatomic, copy) void(^selectAction)(UIButton * button,NSString * selectMessge);

- (instancetype)initSelectType:(selectType)selectType alterTitle:(NSString *)alterTitle dateMode:(UIDatePickerMode)dateMode;

@end
