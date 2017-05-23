//
//  SZNearByCommentCell.m
//  iTotemFramework
//
//  Created by 成焱 on 14-4-16.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZNearByCommentCell.h"
#import "SZNearByUserCommentModel.h"
@interface SZNearByCommentCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *starA;
@property (weak, nonatomic) IBOutlet UIImageView *starB;
@property (weak, nonatomic) IBOutlet UIImageView *starC;
@property (weak, nonatomic) IBOutlet UIImageView *starD;
@property (weak, nonatomic) IBOutlet UIImageView *starE;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

@end

@implementation SZNearByCommentCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)configModel:(id)model
{
    if ([model isKindOfClass:[SZNearByUserCommentModel class]]) {
        SZNearByUserCommentModel *comment = (SZNearByUserCommentModel *)model;
        self.nameLabel.text = comment.user_name;
        self.scoreLabel.text = [NSString stringWithFormat:@"%@分",comment.score];
        NSArray *stars = [NSArray arrayWithObjects:self.starA,self.starB,self.starC,self.starD,self.starE, nil];
        [stars enumerateObjectsUsingBlock:^(id obj,NSUInteger index,BOOL *stop){
            UIImageView *star = (UIImageView *)obj;
            if (index<[comment.score intValue]) {
                [star setHighlighted:YES];
            }else{
                [star setHighlighted:NO];
            }
        }];
        self.contentLabel.text = comment.comment;
        
        NSString *time = [NSDate timeStringWithInterval:[comment.add_time floatValue]];
        self.timeLabel.text = time;
    }
}
@end
