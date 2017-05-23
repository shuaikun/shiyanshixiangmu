//
//  SZMerchantDetailCommentView.h
//  iTotemFramework
//
//  Created by 成焱 on 14-4-19.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZNearByUserCommentModel.h"

typedef void(^SZMerchantDetailCommentMoreViewCallBack)(void);
typedef void (^SZMerchantDetailCommentAddCommentCallBack)(void);

@interface SZMerchantDetailCommentView : UIView
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *moreNumber;
@property (nonatomic, copy) NSString *starLevel;

@property (nonatomic, copy) SZMerchantDetailCommentMoreViewCallBack moreClick;
@property (nonatomic, copy) SZMerchantDetailCommentAddCommentCallBack addCommentClick;

- (id)initWithFrame:(CGRect)frame andCommentModel:(SZNearByUserCommentModel *)comment andTotleNumber:(NSString *)num;

@end
