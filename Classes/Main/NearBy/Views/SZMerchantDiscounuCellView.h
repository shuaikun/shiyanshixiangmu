//
//  SZMerchantDiscounuCellView.h
//  iTotemFramework
//
//  Created by 成焱 on 14-4-18.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "ITTXibView.h"
typedef void(^SZMerchantDiscounuCellViewCallBack)(void);
@interface SZMerchantDiscounuCellView : ITTXibView
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UIImageView *arrowView;
@property (nonatomic, strong) IBOutlet UILabel *contentLabel;
@property (nonatomic, strong) IBOutlet UIView *bottomLine;
@property (nonatomic, strong) IBOutlet UIButton *clickBtn;
@property (nonatomic, copy) SZMerchantDiscounuCellViewCallBack click;
- (IBAction)handleClickBtnClick:(id)sender;
@end
