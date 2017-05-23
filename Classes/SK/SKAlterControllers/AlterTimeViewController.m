//
//  AlterTimeViewController.m
//  selectTime
//
//  Created by caoshuaikun on 2017/1/10.
//  Copyright © 2017年 wuxiwenyan. All rights reserved.
//

#import "AlterTimeViewController.h"


@interface AlterTimeViewController ()

@end

@implementation AlterTimeViewController

- (instancetype)initSelectType:(selectType)selectType alterTitle:(NSString *)alterTitle dateMode:(UIDatePickerMode)dateMode {
    self = [super init];
    if (self) {
        
        self.title = [NSString stringWithFormat:@"%@\n\n\n\n\n\n\n\n\n\n\n",alterTitle];
        
        //确认取消按钮
        [self creatAffireAndCancelButton];
        self.selecetGenderOrBrith = selectType;
        
        //选择自定义数组 创建pickView
        if (selectType == selectArrayMessge) {
            [self creatPickView];
        //选择生日 创建datepickView
        } else if (selectType == selectBrith) {
            [self creatDatePickView:dateMode];
        }
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

//创建时间选择器
- (void)creatDatePickView:(UIDatePickerMode)dateModel {
    
    self.datePickView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, Screen_Width - 20, 191)];
    self.datePickView.datePickerMode = dateModel;
    self.datePickView.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"];
    [self.view addSubview:self.datePickView];
}

//创建选择pickView
- (void)creatPickView {

    self.pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, Screen_Width - 20, 191)]; 
    self.pickView.delegate = self;
    self.pickView.dataSource = self;
    [self.view addSubview:self.pickView];
}

#pragma mark - pickViewDatesourse
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.selectArray.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.selectArray[row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectMessge = self.selectArray[row];
}

//创建按钮
- (void)creatAffireAndCancelButton {

    //确认按钮
    self.buttonCancel = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 50, 40)];
    [self.buttonCancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.buttonCancel setTitle:@"取消" forState:UIControlStateNormal];
    [self.buttonCancel addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.buttonCancel];
    
    //取消按钮
    self.buttonAffire = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 80, 0, 50, 40)];
    [self.buttonAffire setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.buttonAffire setTitle:@"确认" forState:UIControlStateNormal];
    [self.buttonAffire addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.buttonAffire];
}

//按钮点击
- (void)buttonAction:(UIButton *)button {
    
    //选择生日时间
    if (self.selecetGenderOrBrith == selectBrith) {
        self.selectAction(button,[self getNeetDate:self.datePickView.date]);
    //选择自定义数组
    } else {
        self.selectAction(button,!self.selectMessge?self.selectArray[0]:self.selectMessge);
    }
}

//返回时间字符串
- (NSString *)getNeetDate:(NSDate *)date {

    NSDateFormatter * dateFormate = [[NSDateFormatter alloc] init];
    [dateFormate setDateFormat:self.dateType];
    NSString * str = [dateFormate stringFromDate:date];
    return str;
}


@end
