//
//  SZMembershipCardPreviewViewController.m
//  iTotemFramework
//
//  Created by 王琦 on 14-4-14.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZMembershipCardPreviewViewController.h"
#import "SZGoodsNameModel.h"
#import "ITTImageView.h"



@interface SZMembershipCardPreviewViewController ()

@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel2;
@property (weak, nonatomic) IBOutlet ITTImageView *imageView;

- (IBAction)onBackButtonClicked:(id)sender;

@end

@implementation SZMembershipCardPreviewViewController

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
        _cardView.top -= 68;
        _imageView.top -= 68;
    }
    _numberLabel.text = _number;
    _nameLabel2.text = _number;
    if (_number.length == 0) {
        _nameLabel2.hidden = YES;
    }

    if(IS_STRING_NOT_EMPTY(_picurl)){
        _imageView.hidden = NO;
        _cardView.hidden = YES;
        _nameLabel.hidden = YES;

        
        _label1.hidden = YES;
        _label2.hidden = YES;
        _label3.hidden = YES;
        _label4.hidden = YES;
        _label5.hidden = YES;
        [_imageView loadImage:_picurl];
    }
    else{
        _nameLabel2.hidden = YES;
        _label1.text = _discount.first; _label1.width = [_discount.first  sizeWithFont:_label1.font].width;
        _label2.text = _discount.second;_label2.width = [_discount.second sizeWithFont:_label2.font].width;
        _label3.text = _discount.third; _label3.width = [_discount.third  sizeWithFont:_label3.font].width;
        _label4.text = _discount.forth; _label4.width = [_discount.forth  sizeWithFont:_label4.font].width;
        _label5.text = _discount.fifth; _label5.width = [_discount.fifth  sizeWithFont:_label5.font].width;
        _label5.right = self.view.width-30;
        _label4.right = _label5.text.length>0?_label5.left + 3:_label5.left;
        _label3.right = _label4.text.length>0?_label4.left + 3:_label4.left;
        _label2.right = _label3.text.length>0?_label3.left + 3:_label3.left;
        _label1.right = _label2.text.length>0?_label2.left + 3:_label2.left;
        
        _label1.text.length>0?:[_label1 setHidden:!_label1.text.length>0];
        _label2.text.length>0?:[_label2 setHidden:!_label2.text.length>0];
        _label3.text.length>0?:[_label3 setHidden:!_label3.text.length>0];
        _label4.text.length>0?:[_label4 setHidden:!_label4.text.length>0];
        _label5.text.length>0?:[_label5 setHidden:!_label5.text.length>0];
        _imageView.hidden = YES;
        _cardView.layer.masksToBounds = YES;
        _cardView.layer.cornerRadius = 3;
        _cardView.hidden = NO;
        _nameLabel.text = _name;
        _nameLabel.hidden = NO;
        _label1.hidden = NO;
        _label2.hidden = NO;
        _label3.hidden = NO;
        _label4.hidden = NO;
        _label5.hidden = NO;
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



