//
//  SMNewsPreferentialCell.m
//  KnoweSoft.OAX
//
//  Created by Golun on 14-8-4.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMNewsPreferentialCell.h"
#import "ITTXibViewUtils.h"
#import "ITTImageView.h"
#import "SMNewsDetailRequest.h"
#import "SMNewsDetailModel.h"
#import "SZWebViewController.h"
#import "AppDelegate.h"


@interface SMNewsPreferentialCell()<ITTImageViewDelegate>

@property (weak, nonatomic) IBOutlet ITTImageView *shopImageView;
@property (weak, nonatomic) IBOutlet UIView *senderinfo;

@property (strong, nonatomic) NSString *author;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *content_id;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *release_date;
@property (strong, nonatomic) SMNewsModel *newsModel;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblAuthor;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UIView *hrView;

- (IBAction)onShowDetailButtonClicked:(id)sender;

@end

@implementation SMNewsPreferentialCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (SMNewsPreferentialCell *)cellFromNib
{
    return [ITTXibViewUtils loadViewFromXibNamed:@"SMNewsPreferentialCell"];
}
 

#pragma mark - #pragma mark QLPreviewControllerDataSource

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController*)controller  {
    return 1;
}

- (id<QLPreviewItem>)previewController:(QLPreviewController*)controller previewItemAtIndex:(NSInteger)index  {
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    [controller setNeedsStatusBarAppearanceUpdate];
    
    //3.大气污染物综合排放标准
    //NSString *pdfPath = [[NSBundle mainBundle] pathForResource:@"3.大气污染物综合排放标准" ofType:@"pdf"];
    NSString *pdfPath = self.newsModel.desc;
    if (pdfPath != NULL){
        NSURL *theBundleURL = [[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:@"docs"];
        NSRange range;
        range = [pdfPath rangeOfString:@"docs"];
        NSLog(@"found at location = %d, length = %d",range.location,range.length);
        if (range.length == 0) {
            theBundleURL = [theBundleURL URLByAppendingPathComponent:[pdfPath substringFromIndex:1]];
        }else{
            theBundleURL = [theBundleURL URLByAppendingPathComponent:[pdfPath substringFromIndex:range.location+range.length+1]];
        }
        pdfPath = [theBundleURL path];
        
        CGPDFDocumentRef d= MyGetPDFDocumentRef([pdfPath UTF8String]);
        size_t nos= CGPDFDocumentGetNumberOfPages(d);
        totalPages=nos;
        NSLog(@"pdf pages: %zu", nos);
        return [NSURL fileURLWithPath:pdfPath];
    }
    else{
        return nil;
    }
}



- (void)awakeFromNib
{
    [super awakeFromNib];
    _shopImageView.delegate = self;
    //    _shopImageView.enableTapEvent = YES; }
    
    
}
 
- (void)getDataSourceFromModel:(SMNewsModel *)model
{
    self.newsModel = model;
    NSLog(@"model is %@",model);
    
    _shopImageView.hidden = YES;
    _lblAuthor.text = model.author;
    _lblTitle.text = model.title;
    _lblDate.text = model.release_date;
 
    if (_shopImageView.hidden == YES){
        _lblTitle.width = _shopImageView.width + _lblTitle.width - 10;
        _lblTitle.numberOfLines = 1;
        _lblTitle.height = 30;
        _lblTitle.top = 5;
        _lblTitle.left = 10;
        
        _senderinfo.top = 30;
        
        _hrView.top = _senderinfo.top + _senderinfo.height + 9;
         
        [self setFrame:CGRectMake(0, 0, self.width, _hrView.top+_hrView.height + 2)];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (IBAction)onShowDetailButtonClicked:(id)sender
{
    [[[AppDelegate GetAppDelegate] masterNavigationController] setNavigationBarHidden:NO];
    
    QLPreviewController *previewController = [[QLPreviewController alloc] init];
    previewController.dataSource = self;
    previewController.delegate = self;
    previewController.currentPreviewItemIndex = 0;

    [self pushViewController:previewController];
    
    //[self presentModalViewController:navigationController animated:YES];
    return;
    
    [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken) {
        __weak typeof(self) weakSelf = self;
        NSString *userid = [[UserManager sharedUserManager] userId];
        NSDictionary *params = @{
                                 @"userid":userid,
                                 @"token":[[UserManager sharedUserManager] ssoTokenWithUserId:userid],
                                 @"datasetcode":@"AppDetailedContent",
                                 @"content_id": _newsModel.content_id
                                 };
        ITTDINFO(@"request params :[%@]" ,params);
        
        [SMNewsDetailRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
            [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
        } onRequestFinished:^(ITTBaseDataRequest *request) {
            if (weakSelf && request.isSuccess) {
                NSString *title = self.newsModel.title;
                NSString *content = @"";
                NSArray *newsArray = request.handleredResult[NETDATA];
                if ([newsArray count] > 0){
                    NSDictionary *data = [newsArray objectAtIndex:0];
                    SMNewsDetailModel *newsDetailModel = [[SMNewsDetailModel alloc] initWithDataDic:data];
                    title = newsDetailModel.title;
                    content = newsDetailModel.txt;
                }
                SZWebViewController *newsWebViewController = [SZWebViewController alloc];
                newsWebViewController.htmlStr = content;
                [newsWebViewController setTitle:title];
                [self pushMasterViewController:newsWebViewController];
                
            }
            //不用处理 isSuccess 为 NO 的情况
        } onRequestCanceled:^(ITTBaseDataRequest *request) {
            
        } onRequestFailed:^(ITTBaseDataRequest *request) {
            
        }];
        
    }];
    
    
    
    /*
    
        SZCouponDetailViewController *couponDetailViewController = [[SZCouponDetailViewController alloc] initWithNibName:@"SZCouponDetailViewController" bundle:nil];
        couponDetailViewController.goods_id = _goods_id;
        couponDetailViewController.store_name = _shopNameLabel.text;
        couponDetailViewController.lng = _lng;
        couponDetailViewController.lat = _lat;
        couponDetailViewController.shareImage = self.shopImageView.image;
        couponDetailViewController.couponModel = _couponModel;
        [self pushMasterViewController:couponDetailViewController];
     */
}

@end









