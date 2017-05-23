//
//  SZPreferentialCell.m
//  iTotemFramework
//
//  Created by 王琦 on 14-4-14.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZPreferentialCell.h"
#import "ITTXibViewUtils.h"
#import "ITTImageView.h"
#import "SZCouponDetailViewController.h"
#import "SZMembershipCardDetailViewController.h"
#import "SZGoodsNameModel.h"
#import "SZNearByBigPhotoViewController.h"
#import "SZNearByFocusPicModel.h"
@interface SZPreferentialCell()<ITTImageViewDelegate>

@property (weak, nonatomic) IBOutlet ITTImageView *shopImageView;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *gainTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *distanceIcon;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *signImageView;
@property (weak, nonatomic) IBOutlet UILabel *signLabel;
@property (strong, nonatomic) NSString *goods_id;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *lng;
@property (strong, nonatomic) NSString *lat;
@property (strong, nonatomic) NSString *bigPicUrl;
@property (strong, nonatomic) SZCouponModel *couponModel;

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (weak, nonatomic) IBOutlet UILabel *preUnitLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;

- (IBAction)onShowDetailButtonClicked:(id)sender;

@end

@implementation SZPreferentialCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (SZPreferentialCell *)cellFromNib
{
    return [ITTXibViewUtils loadViewFromXibNamed:@"SZPreferentialCell"];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _shopImageView.delegate = self;
//    _shopImageView.enableTapEvent = YES;
    _label2.layer.masksToBounds = YES;
    _label2.layer.cornerRadius = 2;
    _label4.layer.masksToBounds = YES;
    _label4.layer.cornerRadius = 2;
}

- (void)imageViewDidClicked:(ITTImageView *)imageView
{
    NSLog(@"fuck");
    if(IS_STRING_NOT_EMPTY(_bigPicUrl)){
        SZNearByBigPhotoViewController *bigPhoto = [[SZNearByBigPhotoViewController alloc]init];
        SZNearByFocusPicModel *picModl = [[SZNearByFocusPicModel alloc] init];
        picModl.pic_url = _bigPicUrl;
        bigPhoto.pics = [NSMutableArray arrayWithObjects:picModl, nil];
        [self pushMasterViewController:bigPhoto];
    }
}

- (void)getDataSourceFromModel:(SZCouponModel *)model
{
//    NSString *test = @"http://static.mall.com/data/files/store_63/other/store_logo.jpg";
//    NSString *subTest = [test stringByReplacingOccurrencesOfString:@".jpg" withString:@"_s.jpg"];
//    NSLog(@"subTest is %@",subTest);
    self.couponModel = model;
    NSLog(@"model is %@",model);
    SZGoodsNameModel *nameModel = model.goods_name;
    NSLog(@"name model is %@,%@,%@,%@,%@",nameModel.first,nameModel.second,nameModel.third,nameModel.forth,nameModel.fifth);

//        NSString *picUrl = [model.pic_url stringFormatterWithStr:@"s"];
//        _bigPicUrl = [model.pic_url stringFormatterWithStr:@"b"];

    if([model.type isEqualToString:@"1"]){
        [_shopImageView loadImage:model.pic_url placeHolder:[UIImage imageNamed:@"SZ_default_coupon.png"]];
        _signImageView.hidden = NO;
        _signImageView.image = [UIImage imageNamed:@"SZ_Mine_Quan_Bg.png"];
        _signLabel.text = @"券";
        _preUnitLabel.text = @"已获取";
        _unitLabel.text = @"张";
        _gainTimeLabel.left = 180;
        _preUnitLabel.left = 147;
        _unitLabel.left = 200;
        
    }
    else if([model.type isEqualToString:@"2"]){
        [_shopImageView loadImage:model.pic_url placeHolder:[UIImage imageNamed:@"SZ_default_card.png"]];
        _signImageView.hidden = NO;
        _signImageView.image = [UIImage imageNamed:@"SZ_Mine_Card_Bg.png"];
        _signLabel.text = @"卡";
        _preUnitLabel.text = @"已有会员";
        _unitLabel.text = @"人";
        _gainTimeLabel.left = 187;
        _preUnitLabel.left = 147;
        _unitLabel.left = 205;
    }
    else{
        _signImageView.hidden = YES;
        _signLabel.text = @"";
    }
    _shopNameLabel.text = model.store_name;
    _gainTimeLabel.text = model.sales;
    _distanceLabel.text = model.distance;
//    float distance = [model.distance floatValue];
//    if(distance>1000){
//        CGFloat a = distance/1000;
//        NSLog(@"a is %f",a);
//        _distanceLabel.text = [NSString stringWithFormat:@"%.1fkm",a];
//    }
//    else{
//        _distanceLabel.text = [NSString stringWithFormat:@"%dm",[model.distance intValue]];
//    }
    _goods_id = model.goods_id;
    _type = model.type;
    _lat = model.lat;
    _lng = model.lng;

    _label1.text = model.goods_name.first; _label1.width = [model.goods_name.first  sizeWithFont:_label1.font].width;
    _label2.text = model.goods_name.second;_label2.width = [model.goods_name.second sizeWithFont:_label2.font].width;_label2.width = _label2.width>0? _label2.width+8:0;
    _label3.text = model.goods_name.third; _label3.width = [model.goods_name.third  sizeWithFont:_label3.font].width;
    _label4.text = model.goods_name.forth; _label4.width = [model.goods_name.forth  sizeWithFont:_label4.font].width;_label4.width = _label4.width>0? _label4.width+8:0;
    _label5.text = model.goods_name.fifth; _label5.width = [model.goods_name.fifth  sizeWithFont:_label5.font].width;
    _label2.left = _label1.text.length>0?_label1.right + 3:_label1.right;
    _label3.left = _label2.text.length>0?_label2.right + 3:_label2.right;
    _label4.left = _label3.text.length>0?_label3.right + 3:_label3.right;
    _label5.left = _label4.text.length>0?_label4.right + 3:_label4.right;
    [_label1 setHidden:!_label1.text.length>0];
    [_label2 setHidden:!_label2.text.length>0];
    [_label3 setHidden:!_label3.text.length>0];
    [_label4 setHidden:!_label4.text.length>0];
    [_label5 setHidden:!_label5.text.length>0];
    
    if(_fromHistory){
        _distanceIcon.hidden = YES;
        _distanceLabel.hidden = YES;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (IBAction)onShowDetailButtonClicked:(id)sender
{
    if([_type isEqualToString:@"1"]){
        SZCouponDetailViewController *couponDetailViewController = [[SZCouponDetailViewController alloc] initWithNibName:@"SZCouponDetailViewController" bundle:nil];
        couponDetailViewController.goods_id = _goods_id;
        couponDetailViewController.store_name = _shopNameLabel.text;
        couponDetailViewController.lng = _lng;
        couponDetailViewController.lat = _lat;
        couponDetailViewController.shareImage = self.shopImageView.image;
        couponDetailViewController.couponModel = _couponModel;
        [self pushMasterViewController:couponDetailViewController];
    }
    else if([_type isEqualToString:@"2"]){
        SZMembershipCardDetailViewController *membershipCardDetailViewController = [[SZMembershipCardDetailViewController alloc] initWithNibName:@"SZMembershipCardDetailViewController" bundle:nil];
        membershipCardDetailViewController.goods_id = _goods_id;
        membershipCardDetailViewController.store_name = _shopNameLabel.text;
        membershipCardDetailViewController.lng = _lng;
        membershipCardDetailViewController.lat = _lat;
        membershipCardDetailViewController.couponModel = _couponModel;
        membershipCardDetailViewController.shareImage = self.shopImageView.image;
        [self pushMasterViewController:membershipCardDetailViewController];
    }
}

@end









