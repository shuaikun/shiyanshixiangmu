//
//  WWHomePageViewController.m
//  com.knowesoft.weifei
//
//  Created by Golun on 2015-03-13.
//  Copyright (c) 2015年 Knowesoft. All rights reserved.
//

#import "WWHomePageViewController.h"
#import "TwoDimensionalCodeScanViewController.h"
#import "TwoDimensionalCodeResultViewController.h"
#import "WWPackageSearchViewController.h"
#import "SZMineViewController.h"
#import "AppDelegate.h"
#import "SKTecSpeViewController.h"

@interface WWHomePageViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (nonatomic, strong) UIWebView * webView;

@end

@implementation WWHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_logoImageView setAlpha:0];
    [_buttonView setAlpha:0];
    // Do any additional setup after loading the view from its nib.
    [self setNeedsStatusBarAppearanceUpdate];
    
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[[AppDelegate GetAppDelegate] masterNavigationController] setNavigationBarHidden:YES];
    [self setNeedsStatusBarAppearanceUpdate];
    
    _buttonView.top = self.view.height - _buttonView.height;
    _logoImageView.top = (self.view.height - _buttonView.height - _logoImageView.height) / 2.0;
    
    [UIView animateWithDuration:2 animations:^{
        [_logoImageView setAlpha:1.0];
        [_buttonView setAlpha:1.0];
    }];
}




- (IBAction)buttonListDidClick:(id)sender {
    WWPackageSearchViewController *searchViewController = [[WWPackageSearchViewController alloc] initWithNibName:@"WWPackageSearchViewController" bundle:nil];
    [self.navigationController pushViewController:searchViewController animated:YES];
}
- (IBAction)buttonQRDidClick:(id)sender {
    
    TwoDimensionalCodeScanViewController *VC = [[TwoDimensionalCodeScanViewController alloc] initWithNibName:@"TwoDimensionalCodeScanViewController" bundle:nil];
    VC.login = NotNeed_Login;
    [self pushMasterViewController:VC];
    
     
    
    //TwoDimensionalCodeResultViewController *twoDimensionalCodeResultViewController = [[TwoDimensionalCodeResultViewController alloc] initWithNibName:@"TwoDimensionalCodeResultViewController" bundle:nil];
    //twoDimensionalCodeResultViewController.symbolString = @"2015071620172761";
    //[[UserManager sharedUserManager] setInt:0 withKey:kWWPourWasteStep];
    //[self.navigationController pushViewController:twoDimensionalCodeResultViewController animated:YES];
    
}
- (IBAction)buttonMyDidClick:(id)sender {
    SZMineViewController *mineViewControll = [[SZMineViewController alloc] initWithNibName:@"SZMineViewController" bundle:nil];
    mineViewControll.login = Need_Login;
    [self.navigationController pushViewController:mineViewControll animated:YES];
}
- (IBAction)buttonDocDidClick:(id)sender {
    SKTecSpeViewController * vc = [[SKTecSpeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
