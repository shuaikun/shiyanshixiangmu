//
//  TwoDimensionalCodeResultViewController.h
//  SinaLiftCircle
//
//  Created by 王琦 on 13-10-31.
//
//

#import "SZBaseViewController.h"
#import "Header_StaticDefine.h"

@interface TwoDimensionalCodeResultViewController : SZBaseViewController

@property (copy, nonatomic) NSString *symbolString;
@property (assign, nonatomic) BOOL onlyView;
@property (nonatomic, assign) NeedLogInOrNot login;

@end
