//
//  SZPersonalDynamicViewController.m
//  iTotemFramework
//
//  Created by 王琦 on 14-4-15.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZPersonalDynamicViewController.h"
#import "SZWebViewDelegate.h"
@interface SZPersonalDynamicViewController ()
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) IBOutlet SZWebViewDelegate *webViewDelegate;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@end

@implementation SZPersonalDynamicViewController

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
    [_titleLabel setText:_name];
    [_webViewDelegate loadRequestWithUrlString:_urlString];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUrlWithUserId:(NSString *)userId isFriend:(BOOL)isFriend
{
    if (userId) {
        NSString *myUserId = [[UserManager sharedUserManager] userId];
        NSString *ssoToken = [[UserManager sharedUserManager] ssoTokenWithUserId:myUserId];
        NSString *friendId = nil;
        if (isFriend) {
            friendId = userId;
            self.urlString = [NSString stringWithFormat:@"%@?app=html&act=personal&plat=%@&user_id=%@&sso_token=%@&friend_id=%@",SZHOST_URL,SZIOSPLATFORM_STR,myUserId,ssoToken,friendId];//有可能userId不是自己
        }else
        {
            self.urlString = [NSString stringWithFormat:@"%@?app=html&act=personal&plat=%@&user_id=%@&sso_token=%@",SZHOST_URL,SZIOSPLATFORM_STR,userId,ssoToken];//有可能userId不是自己
        }

    }else
    {
        self.urlString = [NSString stringWithFormat:@"%@?app=html&act=personal&plat=%@",SZHOST_URL,SZIOSPLATFORM_STR];
    }

}

@end
