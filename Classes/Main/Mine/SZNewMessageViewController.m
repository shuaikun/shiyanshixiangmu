//
//  SZNewMessageViewController.m
//  iTotemFramework
//
//  Created by Grant on 14-4-24.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZNewMessageViewController.h"
#import "SZWebViewDelegate.h"
@interface SZNewMessageViewController ()
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) IBOutlet SZWebViewDelegate *webViewDelegate;
@end

@implementation SZNewMessageViewController

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
    [_webViewDelegate setIsNestedHtmlRequest:YES];
    [_webViewDelegate loadRequestWithUrlString:_urlString];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUrl:(NSString *)url
{
    self.urlString = url;
}
@end
