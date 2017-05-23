//
//  SKTechnicalViewController.m
//  com.knowesoft.weifei
//
//  Created by caoshuaikun on 2017/5/8.
//  Copyright © 2017年 Knowesoft. All rights reserved.
//

#import "SKTechnicalViewController.h"

@interface SKTechnicalViewController ()

@property (nonatomic, strong) UIWebView * webView;

@end

@implementation SKTechnicalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"technicalSpecifications" ofType:@"pdf"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - viewWillAppear
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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
