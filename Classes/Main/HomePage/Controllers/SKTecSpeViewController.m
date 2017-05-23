//
//  SKTecSpeViewController.m
//  com.knowesoft.weifei
//
//  Created by caoshuaikun on 2017/5/8.
//  Copyright © 2017年 Knowesoft. All rights reserved.
//

#import "SKTecSpeViewController.h"

@interface SKTecSpeViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *myWebView;

@end

@implementation SKTecSpeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTopViewBackgroundColor:[UIColor whiteColor]];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"technicalSpecifications" ofType:@"pdf"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.myWebView.backgroundColor = [UIColor whiteColor];
    [self.myWebView loadRequest:request];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
