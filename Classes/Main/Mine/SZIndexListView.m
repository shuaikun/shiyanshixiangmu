//
//  SZIndexListView.m
//  iTotemFramework
//
//  Created by 王琦 on 14-4-16.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZIndexListView.h"
#import "UILabel+ITTAdditions.h"

#define TAG_INDEX_LABEL 10

@interface SZIndexListView()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (retain, nonatomic) NSMutableArray * indexArray;

@end

@implementation SZIndexListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setIndexList
{
    int indexCount = [_indexArray count];
    if(is4InchScreen()){
        self.height = 442;
    }
    for(int i=0;i<indexCount;i++){
        UILabel * label = [UILabel labelWithFrame:CGRectMake(8, i*(self.height/indexCount), 16, self.height/indexCount) text:[self.indexArray objectAtIndex:i] textColor:[UIColor darkGrayColor] font:[UIFont systemFontOfSize:9] tag:i hasShadow:NO];
        label.tag = TAG_INDEX_LABEL + i;
        [self addSubview:label];
    }
}

- (void)setIndexListWithHeight:(float)height
{
    int indexCount = [_indexArray count];
    for (int i = 0 ; i < indexCount ; i++) {
        UILabel *label = (UILabel *)[self viewWithTag:TAG_INDEX_LABEL+i];
        [label removeFromSuperview];
    }
    for (int i = 0 ;  i < indexCount; i++) {
        UILabel * label = [UILabel labelWithFrame:CGRectMake(8, i*(height/indexCount), 16, height/indexCount)  text:[self.indexArray objectAtIndex:i] textColor:[UIColor darkGrayColor] font:[UIFont systemFontOfSize:9] tag:i hasShadow:NO];
        label.tag = TAG_INDEX_LABEL + i;
        [self addSubview:label];
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _indexArray = [NSMutableArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#", nil];
    [self setIndexList];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _backgroundImageView.hidden = NO;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    CGFloat height = location.y;
    int indexCount = [_indexArray count];
    CGFloat selfHeight = self.frame.size.height;
    CGFloat oneHeight = selfHeight/indexCount;
    int number = height/oneHeight;
    if(number>=0&&number<indexCount){
        if(_delegate && [_delegate respondsToSelector:@selector(indexListViewDidSelectIndex:Content:)]){
            [_delegate indexListViewDidSelectIndex:number Content:[_indexArray objectAtIndex:number]];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    _backgroundImageView.hidden = YES;
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    CGFloat height = location.y;
    int indexCount = [_indexArray count];
    CGFloat selfHeight = self.frame.size.height;
    CGFloat oneHeight = selfHeight/indexCount;
    int number = height/oneHeight;
    if(number>=0&&number<indexCount){
        if(_delegate && [_delegate respondsToSelector:@selector(indexListViewDidSelectIndex:Content:)]){
            [_delegate indexListViewDidSelectIndex:number Content:[_indexArray objectAtIndex:number]];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end




