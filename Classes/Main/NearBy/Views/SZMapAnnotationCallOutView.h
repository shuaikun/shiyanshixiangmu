//
//  SZMapAnnotaionCallOutView.h
//  iTotemFramework
//
//  Created by 成焱 on 14-4-22.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "ITTXibView.h"
#import "SZStarView.h"
typedef void(^SZMapAnnotationCallBack)(NSString *storeId);
@interface SZMapAnnotationCallOutView : ITTXibView

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet SZStarView *starView;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (nonatomic, copy) NSString *storeId;
@property (nonatomic, copy) SZMapAnnotationCallBack click;
@property (nonatomic, retain) NSString *iconsFlag;
@end
