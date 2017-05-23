//
//  WWWasteNamePickView.m
//  com.knowesoft.weifei
//
//  Created by Golun on 2015-07-25.
//  Copyright (c) 2015年 Knowesoft. All rights reserved.
//

#import "WWWasteNamePickView.h"
#import "WWWasteTypeRequest.h"
#import "WWWasteTypeModel.h"
#import "WWWasteTypeViewCell.h"

@interface WWWasteNamePickView ()
@property (nonatomic, copy) void(^finishPickBlock)(NSString *wastename);

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *preferentialCellArray;

@end

@implementation WWWasteNamePickView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)showWasteNamePickViewWithFinishBlock:(void(^)(NSString *wastename))finishBlock
{
    self.finishPickBlock = finishBlock;
    self.height = self.height-20;
    self.top = self.superview.bottom;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.bottom = weakSelf.top;
    }];
    
    [self initData];
    
}

-(void)initData
{
    NSArray *wasteTypeArray = [[UserManager sharedUserManager] wasteTypeArray];
    if (wasteTypeArray == nil){
        NSDictionary *params = @{
                                 };
        
        ITTDINFO(@"request params :[%@]" ,params);
        
        __weak typeof(self) weakSelf = self;
        [WWWasteTypeRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
            [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
        } onRequestFinished:^(ITTBaseDataRequest *request) {
            if (request.isSuccess){
                NSArray *datalist = [request.handleredResult objectForKey:NETDATA];
                [[UserManager sharedUserManager] setWasteTypeArray:datalist];
                [self initData];
            }
        } onRequestCanceled:^(ITTBaseDataRequest *request) {
         } onRequestFailed:^(ITTBaseDataRequest *request) {
        }];
    }
    else{
        [self initScrollViewData:wasteTypeArray];
    }
}

-(void)initScrollViewData:(NSArray*)wasteTypeArray
{
    if (_preferentialCellArray == nil){
        _preferentialCellArray = [[NSMutableArray alloc] init];
    }
    [_preferentialCellArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat curTop = 10;
    for (WWWasteTypeModel *model in wasteTypeArray) {
        WWWasteTypeViewCell *cell = [WWWasteTypeViewCell cellFromNib];
        //点击cell反应
        [cell showWasteTypeCellWithFinishBlock:^(WWWasteTypeModel *model) {
            [self selectItem:model];
        } data:model];
        [_preferentialCellArray addObject:cell];
        cell.top = curTop,curTop+=cell.height;
        [_scrollView addSubview:cell];
    }
    //_scrollView.height = self.frame.size.height -
    _scrollView.contentSize = CGSizeMake(_scrollView.width, curTop+60);
}

-(void)selectItem:(WWWasteTypeModel*)model
{
    [[UserManager sharedUserManager] setString:model.wasteCode withKey:WWasteTypeCode];
    [[UserManager sharedUserManager] setString:model.wasteName withKey:WWasteTypeName];
    [[UserManager sharedUserManager] setString:model.wasteType withKey:WWasteType];
    [[UserManager sharedUserManager] setString:model.descriptions withKey:WWasteDescription];
    [[UserManager sharedUserManager] setString:model.containerType withKey:WWasteContainerType];
    
    //NSDictionary *data = [model propertiesAndValuesDictionary];
    //[[]UserManager sharedUserManager] setValuesForKeysWithDictionary:data];
    //[UserManager sharedUserManager]
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.top = weakSelf.bottom;
    } completion:^(BOOL finished) {
        if (_finishPickBlock) {
            _finishPickBlock(model.wasteName);
        }
    }];
    
//    [self closeBtnDidClicked:model];
}

- (IBAction)closeBtnDidClicked:(id)sender
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.top = weakSelf.bottom;
    } completion:^(BOOL finished) {
        if (_finishPickBlock) {
//            if ([sender isEqual:[ITTBaseModelObject class]]) {
//                _finishPickBlock(@"you");
//            }else{
                _finishPickBlock(@"");
//            }
        }
    }];
}

@end
