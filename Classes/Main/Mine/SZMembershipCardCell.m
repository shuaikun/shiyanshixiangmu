//
//  SZMembershipCardCell.m
//  iTotemFramework
//
//  Created by 王琦 on 14-4-14.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZMembershipCardCell.h"
#import "ITTXibViewUtils.h"
#import "ITTImageView.h"
#import "SZMembershipCardDetailViewController.h"
#import "SZGoodsRecordRequest.h"
#import "SZMembershipCardPreviewViewController.h"
#import "SZNearByFocusPicModel.h"
@interface SZMembershipCardCell()<ITTImageViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet ITTImageView *shopImageView;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (strong, nonatomic) NSString *goods_id;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *bigPicUrl;
@property (nonatomic, strong) NSString *code;
@property (strong, nonatomic) SZGoodsNameModel *goods_name;


- (IBAction)onShowDetailButtonClicked:(id)sender;
- (IBAction)onDeleteOneCardButtonClicked:(id)sender;

@end

@implementation SZMembershipCardCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (SZMembershipCardCell *)cellFromNib
{
    return [ITTXibViewUtils loadViewFromXibNamed:@"SZMembershipCardCell"];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _shopImageView.delegate = self;
    _shopImageView.enableTapEvent = YES;
    [self addGestureRecognizer];
    _label2.layer.masksToBounds = YES;
    _label2.layer.cornerRadius = 2;
    _label4.layer.masksToBounds = YES;
    _label4.layer.cornerRadius = 2;
}

- (void)addGestureRecognizer
{
    UISwipeGestureRecognizer *rswipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(moveBgViewRight)];
    rswipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:rswipeGestureRecognizer];
    UISwipeGestureRecognizer *lswipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(moveBgViewLeft)];
    lswipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:lswipeGestureRecognizer];
}

- (void)moveBgViewRight
{
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.left = 70;
    }];
}

- (void)moveBgViewLeft
{
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.left = 10;
    }];
}

- (void)imageViewDidClicked:(ITTImageView *)imageView
{

//        SZNearByBigPhotoViewController *bigPhoto = [[SZNearByBigPhotoViewController alloc]init];
//        bigPhoto.pics = [NSMutableArray arrayWithObjects:_bigPicUrl, nil];
//        [self pushMasterViewController:bigPhoto];
        
        SZMembershipCardPreviewViewController *bigPhoto = [[SZMembershipCardPreviewViewController alloc]init];
        if (IS_STRING_NOT_EMPTY(_code)) {
            bigPhoto.number = [NSString stringWithFormat:@"NO.%@",_code];
        }
        bigPhoto.name = [NSString stringWithFormat:@"%@ %@",_shopNameLabel.text,_introduceLabel.text];
        bigPhoto.discount = _goods_name;
        bigPhoto.picurl = _bigPicUrl;
        [self pushMasterViewController:bigPhoto];
}

- (void)getDataSourceFromModel:(SZMembershipCardModel *)model
{
    if(model){
        SZGoodsNameModel *nameModel = model.goods_name;
        NSLog(@"name model is %@,%@,%@,%@,%@",nameModel.first,nameModel.second,nameModel.third,nameModel.forth,nameModel.fifth);
        _shopNameLabel.text = model.store_name;
        _code = model.code;
        _goods_id = model.goods_id;
        _type = model.type;
        _goods_name = model.goods_name;
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
        _bgView.left = 10;
        _introduceLabel = nil;
    }
    
    _bigPicUrl = nil;
    if ([model.is_pic isEqualToString:@"1"] && IS_STRING_NOT_EMPTY(model.show_url)) {
        _bigPicUrl = model.show_url;
        
    }
    [_shopImageView loadImage:model.pic_url placeHolder:[UIImage imageNamed:@"SZ_default_card.png"]];
}

- (IBAction)onShowDetailButtonClicked:(id)sender
{
    SZMembershipCardDetailViewController *membershipCardDetailViewController = [[SZMembershipCardDetailViewController alloc] initWithNibName:@"SZMembershipCardDetailViewController" bundle:nil];
    membershipCardDetailViewController.goods_id = _goods_id;
    membershipCardDetailViewController.store_name = _shopNameLabel.text;
    membershipCardDetailViewController.shareImage = self.shopImageView.image;
    [self pushMasterViewController:membershipCardDetailViewController];
}

- (void)beginGooodsRecordRequest
{
    __weak typeof(self) weakSelf = self;
    [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken) {
        typeof(weakSelf) strongSelf = weakSelf;
        NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
        [paramDict setObject:SZINDEX_GOODS_RECORD_METHOD forKey:PARAMS_METHOD_KEY];
        [paramDict setObject:userId forKey:PARAMS_USER_ID];
        [paramDict setObject:strongSelf.goods_id forKey:@"goods_id"];
        [paramDict setObject:@"0" forKey:@"type"]; // 1下载0删除（默认下载操作）
        [SZGoodsRecordRequest requestWithParameters:paramDict withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
            NSLog(@"start loading");
        } onRequestFinished:^(ITTBaseDataRequest *request) {
            if (request.isSuccess) {
                //refresh
                [PROMPT_VIEW showMessage:@"删除成功"];
                if(_delegate && [_delegate respondsToSelector:@selector(membershipCardCellFinishDeleteIndex:)]){
                    [_delegate membershipCardCellFinishDeleteIndex:_index];
                }
            }
        } onRequestCanceled:^(ITTBaseDataRequest *request) {
        } onRequestFailed:^(ITTBaseDataRequest *request) {
        }];
    }];
}

- (IBAction)onDeleteOneCardButtonClicked:(id)sender
{
    [self beginGooodsRecordRequest];
}

@end



