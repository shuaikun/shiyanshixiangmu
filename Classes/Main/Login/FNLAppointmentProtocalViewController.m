//
//  FNLAppointmentProtocalViewController.m
//  leju_MavericksRoom
//
//  Created by Grant on 14-2-25.
//  Copyright (c) 2014年 leju. All rights reserved.
//

#import "FNLAppointmentProtocalViewController.h"

@interface FNLAppointmentProtocalViewController ()
@property (nonatomic, weak) IBOutlet UIWebView *webView;
@end

@implementation FNLAppointmentProtocalViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_urlStr.length>0) {
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlStr]]];
    }
}


@end
