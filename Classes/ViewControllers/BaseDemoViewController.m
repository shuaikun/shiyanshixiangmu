//
//  BaseDemoViewController.m
//  
//
//  Created by jack 廉洁 on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseDemoViewController.h"
#import "AppDelegate.h"
#import "HomeTabBarController.h"

@interface BaseDemoViewController()
{
    BOOL _tabbarStatus;
}

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation BaseDemoViewController

- (void)dealloc
{
    ITTDINFO(@"%@ is dealloced!", [self class]);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:@"Default"];
    [self.view addSubview:imageView];
    [self.view sendSubviewToBack:imageView];
    
    [self setNav];
    _tabbarStatus = [AppDelegate GetAppDelegate].tabBarController.tabBarHidden;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)onBackBtnClicked
{
    [AppDelegate GetAppDelegate].tabBarController.tabBarHidden = _tabbarStatus;
    if (ITTIsModalViewController(self)) {
        [self dismissModalViewControllerAnimated:YES];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setNav
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 38, 44)];
    
    UIButton *backBtn = [UIButton buttonWithFrame:CGRectMake(0, 5, 38, 34)
                                            title:@"⬅︎"
                                       titleColor:[UIColor lightGrayColor]
                              titleHighlightColor:[UIColor lightTextColor]
                                        titleFont:[UIFont systemFontOfSize:25]
                                            image:nil//ImageNamed(@"btn_nav_back.png")
                                      tappedImage:nil//ImageNamed(@"btn_nav_back_pressed.png")
                                           target:self
                                           action:@selector(onBackBtnClicked)
                                              tag:0];
    [backView addSubview:backBtn];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;

    
    UILabel *titleLbl = [UILabel labelForNavigationBarWithTitle:_navTitle
                                                      textColor:RGBCOLOR(200, 200, 200)
                                                           font:[UIFont systemFontOfSize:20]
                                                      hasShadow:YES];
    self.titleLabel = titleLbl;
    self.navigationItem.titleView = titleLbl;
    self.navigationController.navigationBar.translucent = FALSE;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.automaticallyAdjustsScrollViewInsets = FALSE;        
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_nav@2x.png"] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setBarTintColor:[UIColor redColor]];
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    }
    else
    {
       [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_nav"] forBarMetrics:UIBarMetricsDefault];
    }
}

- (void)setNavTitle:(NSString *)navTitle
{
    _navTitle = nil;
    _navTitle = navTitle;
    self.titleLabel.text = _navTitle;
}
@end
