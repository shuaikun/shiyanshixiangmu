//
//  SZCouponPreviewViewController.m
//  iTotemFramework
//
//  Created by 王琦 on 14-4-14.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZCouponPreviewViewController.h"
#import "ITTImageView.h"

@interface SZCouponPreviewViewController ()

@property (weak, nonatomic) IBOutlet ITTImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *couponView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel2;
@property (weak, nonatomic) IBOutlet UILabel *validateDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *validateDateTitleLabel;

- (IBAction)onBackButtonClicked:(id)sender;

@end

@implementation SZCouponPreviewViewController

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
    [self hiddenTopView];
    if(!is4InchScreen()){
        _couponView.top -= 68;
        _imageView.top -= 68;
    }
    _validateDateLabel.text = _validateDate;
    _validateDateLabel.width = [_validateDate sizeWithFont:_validateDateLabel.font].width;
    _validateDateLabel.right = self.view.width - 30;
    _validateDateTitleLabel.right = _validateDateLabel.left;
    
    if(IS_STRING_NOT_EMPTY(_picurl)){
        _imageView.hidden = NO;
        _couponView.hidden = YES;
        _nameLabel2.text = _name;
        _nameLabel2.hidden = NO;
        [_imageView loadImage:_picurl];
    }
    else{
        _nameLabel.text = _name;
        _nameLabel2.hidden = YES;
        
        _imageView.hidden = YES;
        _couponView.hidden = NO;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBackButtonClicked:(id)sender
{
    [self popMasterViewController];
}

@end


