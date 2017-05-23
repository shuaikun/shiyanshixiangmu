//
//  SZOneContactCell.m
//  iTotemFramework
//
//  Created by 王琦 on 14-4-15.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZOneContactCell.h"
#import "ITTXibViewUtils.h"
#import "ITTImageView.h"

@interface SZOneContactCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *chooseButton;
@property (weak, nonatomic) IBOutlet UIImageView *kuangImageView;
@property (weak, nonatomic) IBOutlet ITTImageView *personImageView;
@property (assign, nonatomic) BOOL isInvite;

- (IBAction)onChooseButtonClicked:(id)sender;

@end

@implementation SZOneContactCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (SZOneContactCell *)cellFromNib
{
    return [ITTXibViewUtils loadViewFromXibNamed:@"SZOneContactCell"];
}

- (void)getDataSourceFromModel:(SZUserPhoneBookModel *)model
{
    if(model && [model isKindOfClass:[SZUserPhoneBookModel class]]){
        [_personImageView loadImage:model.portrait placeHolder:[UIImage imageNamed:@"SZ_Mine_Info_Placeholder.png"]];
        _nameLabel.text = model.friend_name;
        _phoneLabel.text = model.friend_mobile;
        //1平台好友（不显示）2平台用户非好友（显示添加好友按钮）3非平台用户（显示邀请）
        if([model.type isEqualToString:@"1"]){
            _chooseButton.hidden = YES;
        }
        else if([model.type isEqualToString:@"2"]){
            _isInvite = NO;
            _chooseButton.hidden = NO;
            [_chooseButton setBackgroundImage:[UIImage imageNamed:@"SZ_Mine_Add_Friend.png"] forState:UIControlStateNormal];
            [_chooseButton setBackgroundImage:[UIImage imageNamed:@"SZ_Mine_Add_Friend_Tapped.png"] forState:UIControlStateNormal];
        }
        else{
            _isInvite = YES;
            _chooseButton.hidden = NO;
            [_chooseButton setBackgroundImage:[UIImage imageNamed:@"SZ_Mine_Invite_Friend.png"] forState:UIControlStateNormal];
            [_chooseButton setBackgroundImage:[UIImage imageNamed:@"SZ_Mine_Invite_Friend_Tapped.png"] forState:UIControlStateNormal];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onChooseButtonClicked:(id)sender
{
    if(_isInvite){
        if(_delegate && [_delegate respondsToSelector:@selector(oneContactCellDidChooseInviteOnUserPhone:)]){
            //send message
            [_delegate oneContactCellDidChooseInviteOnUserPhone:_phoneLabel.text];
        }
    }
    else{
        if(_delegate && [_delegate respondsToSelector:@selector(oneContactCellDidChooseAddOnUserPhone:)]){
            [_delegate oneContactCellDidChooseAddOnUserPhone:_phoneLabel.text];
        }
    }
}


@end









