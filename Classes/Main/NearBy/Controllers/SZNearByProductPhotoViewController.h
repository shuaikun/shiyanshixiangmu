//
//  SZNearByProductPhotoViewController.h
//  iTotemFramework
//
//  Created by 成焱 on 14-4-24.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZNearByProductPicModel.h"
@interface SZNearByProductPhotoViewController : UIViewController

@property (nonatomic, strong) SZNearByProductPicModel *pic;
- (void)loadBottomView;
- (void)loadContentView;
@end
