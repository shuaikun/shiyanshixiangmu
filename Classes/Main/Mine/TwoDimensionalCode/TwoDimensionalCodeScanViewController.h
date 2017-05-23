//
//  TwoDimensionalCodeScanViewController.h
//  SinaLiftCircle
//
//  Created by 王琦 on 13-10-31.
//
//

#import "SZBaseViewController.h"
#import "Header_StaticDefine.h"

@interface TwoDimensionalCodeScanViewController : SZBaseViewController

@property (nonatomic, copy) void (^getQRCode)(NSMutableArray * mutableArrayForCode);//返回二维码数组
@property (nonatomic, strong) NSMutableArray * arrayForQRCode;//扫描到的二维码数组
@property (nonatomic, assign) NeedLogInOrNot login;

@end
