//
//  SZMapAnnotaionCallOutView.m
//  iTotemFramework
//
//  Created by 成焱 on 14-4-22.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZMapAnnotationCallOutView.h"

@interface SZMapAnnotationCallOutView()
@property (weak, nonatomic) IBOutlet UIImageView *imageLeft;
@property (weak, nonatomic) IBOutlet UIImageView *imageRight;

- (IBAction)handleMapClick:(id)sender;
@end

@implementation SZMapAnnotationCallOutView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)handleMapClick:(id)sender {
    __block NSString *storeid = self.storeId;
    if (self.click!=nil) {
       self.click(storeid);
    }
}

- (void)setIconsFlag:(NSString *)iconsFlag
{
    _iconsFlag = iconsFlag;
    int flag = [_iconsFlag intValue];
    if (flag==0) {
        
    }else if (flag==1){
        self.imageRight.image = [UIImage imageNamed:@"SZ_NearBy_Merchant_Card.png"];
    }else if (flag==2){
        self.imageRight.image = [UIImage imageNamed:@"SZ_NearBy_Merchant_Quan.png"];
    }else{
        self.imageLeft.image = [UIImage imageNamed:@"SZ_NearBy_Merchant_Card.png"];
        self.imageRight.image = [UIImage imageNamed:@"SZ_NearBy_Merchant_Quan.png"];
    }
}
@end
