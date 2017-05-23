//
//  SZFriendsCircleViewController.m
//  iTotemFramework
//
//  Created by 王琦 on 14-4-14.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZFriendsCircleViewController.h"
#import "SZWebViewDelegate.h"
@interface SZFriendsCircleViewController ()
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) IBOutlet SZWebViewDelegate *webViewDelegate;
@end

@implementation SZFriendsCircleViewController

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
    [MobClick event:UMMyFriendsShipLoading];
    [_webViewDelegate loadRequestWithUrlString:_urlString];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUrlWithUserId:(NSString *)userId
{
    if (userId) {
            self.urlString = [NSString stringWithFormat:@"%@?app=html&act=friends&plat=%@&user_id=%@&sso_token=%@",SZHOST_URL,SZIOSPLATFORM_STR,userId,[[UserManager sharedUserManager] ssoTokenWithUserId:userId]];
    }else
    {
            self.urlString = [NSString stringWithFormat:@"%@?app=html&act=friends&plat=%@",SZHOST_URL,SZIOSPLATFORM_STR];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.webViewDelegate hideKeyboard];
    [super viewWillDisappear:animated];
}

@end
