//
//  SZBaseViewController.m
//  iTotemFramework
//
//  Created by 王琦 on 14-4-14.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZBaseViewController.h"

@interface SZBaseViewController ()
{
    @private
    UIWebView *_phoneCallWebView;
    @private
    NSString *tmpTitle;
}
@end

@implementation SZBaseViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    _baseTopView.titleLabel.text = title;
    tmpTitle = title;
}

-(void)setTopViewBackgroundColor:(UIColor*)color
{
    [_baseTopView setBackgroundColor:color];
}

-(void)setTopViewBackButtonImageStyle:(int)style
{
    
    if (style == 1){
        UIColor *clearColor = UIColor.clearColor;
        [self setTopViewBackgroundColor: clearColor];
        
        UIImage *img =[UIImage imageNamed:@"SZ_Back_Normal_White.png"];
        [_baseTopView.backButton setImage:img forState:UIControlStateNormal];
        //[_baseTopView.backButton setHeight:30];
        //[_baseTopView.backButton setWidth:60];
        //[_baseTopView.backButton setTop:(_baseTopView.height - _baseTopView.backButton.height) / 2];
        //[_baseTopView.backButton setLeft:15];
        
        [_baseTopView.lineView setBackgroundColor:[UIColor whiteColor]];
        [self setTitleColor:[UIColor whiteColor]];
    }
}

-(void) setTitleColor:(UIColor*)color
{
    //_baseTopView.titleLabel.tintColor =color;
    [_baseTopView.titleLabel setAttributedText:[[NSAttributedString alloc] initWithString:tmpTitle attributes:@{NSForegroundColorAttributeName: color}]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.baseTopView = [SZBaseTopView loadFromXib];
    [self.baseTopView setBackgroundColor:[UIColor colorWithRed:35.f/255.f green:119.f/255.f blue:194.f/255.f alpha:1.f]];
    _baseTopView.delegate = self;
    self.baseTopView.titleLabel.text = tmpTitle;
    if(IS_IOS_7){
        _baseTopView.top = 20;
    }
    [self.view addSubview:_baseTopView];
    _phoneCallWebView = [[UIWebView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_phoneCallWebView];
}

- (void)hiddenBackButton
{
    _baseTopView.backButton.hidden = YES;
}

- (void)showBackButton
{
    _baseTopView.backButton.hidden = NO;
}

- (void)hiddenLineView
{
    _baseTopView.lineView.hidden = YES;
}

- (void)hiddenTopView
{
    _baseTopView.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)baseTopViewBackButtonClicked
{
    [self popMasterViewController];
}
- (void)baseTopViewRightButtonClicked
{
    
}
- (void)takePhoneCall:(NSString *)number
{
    if ([[[UIDevice currentDevice]model]isEqualToString:@"ipod touch"]||[[[UIDevice currentDevice]model]isEqualToString:@"ipad"]||[[[UIDevice currentDevice]model ]isEqualToString:@"iPhone Simulator"]){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的设备不能打电话" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }else{
        NSURL *callUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",number]];
        NSURLRequest *request = [NSURLRequest requestWithURL:callUrl];
        [_phoneCallWebView loadRequest:request];
    }

}

@end



