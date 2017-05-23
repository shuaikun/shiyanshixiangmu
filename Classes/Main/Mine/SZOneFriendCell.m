//
//  SZOneFriendCell.m
//  iTotemFramework
//
//  Created by 王琦 on 14-4-16.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZOneFriendCell.h"
#import "ITTXibViewUtils.h"
#import "ITTImageView.h"
#import "SZUserDeleteFriendRequest.h"

@interface SZOneFriendCell()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet ITTImageView *personImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) NSString *phoneNumber;

- (IBAction)onDeleteOneFriendButtonClicked:(id)sender;


@end

@implementation SZOneFriendCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (SZOneFriendCell *)cellFromNib
{
    return [ITTXibViewUtils loadViewFromXibNamed:@"SZOneFriendCell"];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self addGestureRecognizer];
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
        _bgView.left = 60;
    }];
}

- (void)moveBgViewLeft
{
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.left = 0;
    }];
}

- (void)getDataSourceFromModel:(SZUserFriendsModel *)model
{
    if(model && [model isKindOfClass:[SZUserFriendsModel class]]){
        _nameLabel.text = model.real_name;
        _phoneNumber = model.mobile;
        if(IS_STRING_NOT_EMPTY(model.portrait)){
            _personImageView.layer.masksToBounds = YES;
            _personImageView.layer.cornerRadius = 2;
            [_personImageView loadImage:model.portrait placeHolder:[UIImage imageNamed:@"SZ_Mine_Info_Placeholder.png"]];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onDeleteOneFriendButtonClicked:(id)sender
{
    [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken){
        NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
        [paramDict setObject:SZINDEX_USER_DELFRIENDS_METHOD forKey:PARAMS_METHOD_KEY];
        [paramDict setObject:userId forKey:PARAMS_USER_ID];
        [paramDict setObject:_phoneNumber forKey:@"friends_name"];
        [SZUserDeleteFriendRequest requestWithParameters:paramDict withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
            NSLog(@"start loading");
            [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
        } onRequestFinished:^(ITTBaseDataRequest *request) {
            if (request.isSuccess) {
                //refresh
                [PROMPT_VIEW showMessage:@"删除好友成功"];
                if(_delegate && [_delegate respondsToSelector:@selector(oneFriendCellFinishDeletePhone:ifSearch:)]){
                    [_delegate oneFriendCellFinishDeletePhone:_phoneNumber ifSearch:_ifSearch];
                }
            }
        } onRequestCanceled:^(ITTBaseDataRequest *request) {
        } onRequestFailed:^(ITTBaseDataRequest *request) {
        }];
    }];
}

@end


