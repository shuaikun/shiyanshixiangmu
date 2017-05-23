//
//  SZActivityViewController.m
//  iTotemFramework
//
//  Created by Grant on 14-4-16.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZActivityViewController.h"
#import "SZWebViewDelegate.h"
@interface SZActivityViewController ()
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) IBOutlet SZWebViewDelegate *webViewDelegate;

@end

@implementation SZActivityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_webViewDelegate loadRequestWithUrlString:_urlString];

}

- (void)setupUrlWithACCId:(NSString *)accId
                   userId:(NSString *)userId
{
    if (userId) {
        self.urlString = [NSString stringWithFormat:@"%@?app=activity&act=detail&aac_id=%@&plat=%@&user_id=%@&sso_token=%@",SZHOST_URL,accId,SZIOSPLATFORM_STR,userId,[[UserManager sharedUserManager] ssoTokenWithUserId:userId]];
    }else
    {
        self.urlString = [NSString stringWithFormat:@"%@?app=activity&act=detail&aac_id=%@&plat=%@",SZHOST_URL,accId,SZIOSPLATFORM_STR];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
