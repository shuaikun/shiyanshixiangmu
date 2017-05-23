//
//  SZMerchantDetailCommentView.m
//  iTotemFramework
//
//  Created by 成焱 on 14-4-19.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZMerchantDetailCommentView.h"
#import "SZStarView.h"
#import "SZGanTanView.h"
@interface SZMerchantDetailCommentView()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) SZStarView *starView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *moreView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *moreBtn;
@end

@implementation SZMerchantDetailCommentView

- (id)initWithFrame:(CGRect)frame andCommentModel:(SZNearByUserCommentModel *)comment andTotleNumber:(NSString *)num
{
    self = [self initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *bgColorview= [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 33)];
        bgColorview.backgroundColor = RGBCOLOR(248, 248, 248);
        [self addSubview:bgColorview];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 305, 33)];
        label.backgroundColor = RGBCOLOR(248, 248, 248);
        label.textColor = [UIColor darkGrayColor];
        label.font = [UIFont systemFontOfSize:14.f];
        label.text = @"用户点评";
        [self addSubview:label];
        if (comment==nil) {
            SZGanTanView *gantanView = [[SZGanTanView alloc]initWithFrame:CGRectMake(120, 33, 30, 30)];
            [self addSubview:gantanView];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(150, 38, 100, 21)];
            label.textColor = [UIColor darkGrayColor];
            label.text = @"暂无评论";
            label.font = [UIFont systemFontOfSize:14.f];
            label.textAlignment = NSTextAlignmentLeft;
            [self addSubview:label];
            _lineView = [[UIView alloc]initWithFrame:CGRectMake(16, 63, 287, 1)];
            _lineView.backgroundColor = RGBCOLOR(222, 222, 222);
            [self addSubview:_lineView];
            
            UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [addBtn setFrame:CGRectMake(25, 73, 270, 30)];
            [addBtn setBackgroundImage:[[UIImage imageNamed:@"SZ_BTN_BLUE"]stretchableImageWithLeftCapWidth:10 topCapHeight:0] forState:UIControlStateNormal];
            [addBtn setBackgroundImage:[[UIImage imageNamed:@"SZ_BTN_BLUE_H"]stretchableImageWithLeftCapWidth:10 topCapHeight:0] forState:UIControlStateHighlighted];
            [addBtn setTitle:@"我要点评" forState:UIControlStateNormal];
            [addBtn addTarget:self action:@selector(handleAddCommentClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:addBtn];
            self.height = 118;
        }else{
            UIColor *bgColor = [UIColor clearColor];
            UIColor *textColor = [UIColor darkGrayColor];
            UIFont *font = [UIFont systemFontOfSize:13.f];
            
            _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 46, 136, 21)];
            _nameLabel.font = [UIFont systemFontOfSize:14.f];
            _nameLabel.backgroundColor = bgColor;
            _nameLabel.textColor = [UIColor blackColor];
            _nameLabel.text = comment.user_name;
            [self addSubview:_nameLabel];
            
            _starView = [[SZStarView alloc]initWithFrame:CGRectMake(223, 50, 83, 14)];
            _starView.starLevel = [comment.score integerValue];
            [self addSubview:_starView];
            
            _lineView = [[UIView alloc]initWithFrame:CGRectMake(16, 72, 287, 1)];
            _lineView.backgroundColor = RGBCOLOR(222, 222, 222);
            [self addSubview:_lineView];
            
            _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 75, 287, 21)];
            _contentLabel.numberOfLines = 0;
            _contentLabel.backgroundColor = bgColor;
            _contentLabel.textColor = textColor;
            _contentLabel.font = font;
            _contentLabel.text = comment.comment;
            
            float height = ceilf([[comment comment] heightWithFont:[UIFont systemFontOfSize:13.f] withLineWidth:287]);
            float defaultHeight = 21.f;
            if (height<21.f) {
                height = 21.f;
            }
            float offSet = defaultHeight - height;
            _contentLabel.text = [comment comment];
            _contentLabel.height = height;
 
            
            
            [self addSubview:_contentLabel];
            
            _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(228, 95-offSet, 74, 21)];
            _timeLabel.backgroundColor = bgColor;
            _timeLabel.textColor =  textColor;
            _timeLabel.font = font;
            _timeLabel.text = [NSDate timeStringWithInterval:comment.add_time.floatValue];
            _timeLabel.textAlignment = NSTextAlignmentRight;
    
            [self addSubview:_timeLabel];
            
            _moreView = [[UIView alloc]initWithFrame:CGRectMake(0, 123-offSet, 320, 40)];
            _moreView.backgroundColor = bgColor;
            [self addSubview:_moreView];
            
            UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 1)];
            topLine.backgroundColor = RGBCOLOR(222, 222, 222);
            [_moreView addSubview:topLine];
            _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _moreBtn.frame = CGRectMake(0, 7, 320, 30);
            [_moreBtn setTitle:[NSString stringWithFormat:@"十查看全部%@个点评",num]  forState:UIControlStateNormal];
            [_moreBtn setTitleColor:RGBCOLOR(42, 172, 226) forState:UIControlStateNormal];
            _moreBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
            [_moreBtn addTarget:self action:@selector(handleMoreCommentClick:) forControlEvents:UIControlEventTouchUpInside];
            [_moreView addSubview:_moreBtn];
            UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, 39, 320, 1)];
            bottomLine.backgroundColor = RGBCOLOR(222, 222, 222);
            [_moreView addSubview:bottomLine];
            
            self.height-=offSet;
        }
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)handleMoreCommentClick:(id)sender
{
    if (self.moreClick!=nil) {
        self.moreClick();
    }
}

- (void)handleAddCommentClick:(id)sender
{
    if (self.addCommentClick!=nil) {
        self.addCommentClick();
    }
}

//- (void)setContent:(NSString *)content
//{
//    _content = content;
//    float height = ceilf([content heightWithFont:[UIFont systemFontOfSize:13.f] withLineWidth:287]);
//    float defaultHeight = 21.f;
//    if (height<21.f) {
//        height = 21.f;
//    }
//    float offSet = defaultHeight - height;
//    _contentLabel.text = content;
//    _contentLabel.height = height;
//    _timeLabel.top-=offSet;
//    _moreView.top-=offSet;
//    self.height-=offSet;
//}
//
//- (void)setStarLevel:(NSString *)starLevel
//{
//    _starLevel = [starLevel copy];
//    [_starView setStarLevel:[_starLevel intValue]];
//}
//
//- (void)setTime:(NSString *)time
//{
//    _time = [time copy];
//    _timeLabel.text = _time;
//}
//
//- (void)setMoreNumber:(NSString *)moreNumber
//{
//    _moreNumber = moreNumber;
//    [_moreBtn setTitle:[NSString stringWithFormat:@"十查看全部%@个点评",_moreNumber] forState:UIControlStateNormal];
//}

@end
