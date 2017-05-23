//
//  SZMerchantDetailPhotoView.h
//  iTotemFramework
//
//  Created by 成焱 on 14-4-18.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZNearByProductPicModel.h"
typedef void (^SZMerchantDetailsPhotoPicClickCallBack)(SZNearByProductPicModel* index);
typedef void (^SZMerchantDetailsPhotoMoreViewCallBack)(void);
@interface SZMerchantDetailPhotoView : UIView
@property (nonatomic, copy) SZMerchantDetailsPhotoPicClickCallBack picClick;
@property (nonatomic, copy) SZMerchantDetailsPhotoMoreViewCallBack moreClick;
@property (nonatomic, copy) NSString *moreNumber;
- (id)initWithFrame:(CGRect)frame pics:(NSMutableArray *)products;
@end
