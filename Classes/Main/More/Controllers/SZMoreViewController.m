//
//  SZMoreViewController.m
//  iTotemFramework
//
//  Created by 成焱 on 14-4-15.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZMoreViewController.h"
#import "SZMoreSwitchModel.h"
#import "SZMoreNormalModel.h"
#import "SZMoreVersionModel.h"
#import "SZSwitchTabelViewCell.h"
#import "SZCheckVersionTableViewCell.h"
#import "SZNormalTableViewCell.h"
#import "SZSuggestionViewController.h"
#import "AppDelegate.h"
#import "SZMoreVersionCheckRequest.h"
#import "ITTImageCacheManager.h"
#import "CommonUtils.h"
#import "SDImageCache.h"
NSString *const clientServicePhoneNumber = @"18600261392";
NSString *const weixinPublicNumber = @"stoneman";
@interface SZMoreViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    BOOL _isCheckVersion;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, copy) NSString *cacheFileSize;

@property (weak, nonatomic) IBOutlet UIView *topView;

@end

@implementation SZMoreViewController

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


    self.baseTopView.hidden = YES;
    self.topView.backgroundColor = UIColorBlue;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.cacheFileSize = [self getTotleCacheSize];
    [self loadModels];
    [self startVersionCheckRequest];
}


- (void)startVersionCheckRequest{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:SZMORE_GETAAPPVERSION,PARAMS_METHOD_KEY,@"1",@"plat", nil];
    [SZMoreVersionCheckRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:CANCEL_SUBJECT_ON_VERSION_CHECK_REQUEST
                                      onRequestStart:^(ITTBaseDataRequest *request){
    }
                                   onRequestFinished:^(ITTBaseDataRequest *request){
        if (request.isSuccess) {

            SZMoreVersionModel *version = [request.handleredResult objectForKey:NETDATA];
            [[self.dataSource objectAtIndex:1]replaceObjectAtIndex:2 withObject:version];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:2 inSection:1], nil] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
                                   onRequestCanceled:^(ITTBaseDataRequest *request){
    }
                                     onRequestFailed:^(ITTBaseDataRequest *request){
                                     }];
}
- (void)loadModels
{
    self.dataSource = [[NSMutableArray alloc]init];
    NSMutableArray *sectionZero = [[NSMutableArray alloc]init];
    NSMutableArray *sectionOne = [[NSMutableArray alloc]init];
    [self.dataSource addObject:sectionZero];
    [self.dataSource addObject:sectionOne];
    //@"赏个好评吧",@"关注我们的微信",@"检查更新",@"意见反馈",@"客服电话(8:00-22:00)",
    NSArray *infos = [NSArray arrayWithObjects:@"仅wifi下显示图片",@"消息提醒",@"清空缓存", nil];
    for (int i = 0; i<3; i++) {
        switch (i) {
            case 0:{
                SZMoreSwitchModel *model = [SZMoreSwitchModel new];
                model.modelId = i;
                model.infoTitle = infos[i];
                model.isOpen = [[UserManager sharedUserManager] onlyShowImageOnWifi];
                [sectionZero addObject:model];
            }
                break;
            case 1:{
                SZMoreSwitchModel *model = [SZMoreSwitchModel new];
                model.modelId = i;
                model.infoTitle = infos[i];
                model.isOpen = [[UserManager sharedUserManager] needNotificaionMsg];
                [sectionZero addObject:model];
            }
                break;
            case 2:{
                SZMoreNormalModel *model = [SZMoreNormalModel new];
                model.infoTitle = infos[i];
                model.modelId = i;
                model.subTitle = self.cacheFileSize;
                [sectionZero addObject:model];
            }
                break;
            case 3:{
                SZMoreNormalModel *model = [SZMoreNormalModel new];
                model.infoTitle = infos[i];
                model.modelId = i;
                [sectionOne addObject:model];
            }break;
            default:{
                SZMoreNormalModel *modle = [SZMoreNormalModel new];
                modle.infoTitle = infos[i];
                if (i==7) {
                    modle.subTitle = clientServicePhoneNumber;
                }
                if (i==4) {
                    modle.subTitle = weixinPublicNumber;
                }
                modle.modelId = i;
                [sectionOne addObject:modle];
            }
                break;
        }
    }
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableViewDelegates

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *datasource = [self.dataSource objectAtIndex:indexPath.section];
    SZMoreModel *model = [datasource objectAtIndex:indexPath.row];
    if (indexPath.section==0) {
        if (indexPath.row==0||indexPath.row==1){
            static NSString *switchCell = @"switchCell";
            SZSwitchTabelViewCell *cell = nil;
            cell = [tableView dequeueReusableCellWithIdentifier:switchCell];
            if (cell==nil) {
                cell = [SZSwitchTabelViewCell loadFromXib];
            }
            cell.switchCallBack = ^(BOOL open){
                if (indexPath.row == 0) {
                    [[UserManager sharedUserManager] setOnlyShowImageOnWifi:open];
                }
                else if (indexPath.row == 1) {
                    NSString *apnsId = [[UserManager sharedUserManager] apnsId];
                    [[AppDelegate GetAppDelegate] postDeviceTokenAndUserInfo:apnsId isOpen:open];
                }

            };
            [cell configModel:model];
            return cell;
        }else{
            static NSString *checkCell = @"normalCell";
            SZNormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:checkCell];
            if (cell==nil) {
                cell = [SZNormalTableViewCell loadFromXib];
            }
            [cell configModel:model];
            return cell;
        }
    }else{
        if (indexPath.row==2) {
            static NSString *checkCell = @"checkCell";
            SZCheckVersionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:checkCell];
            if (cell==nil) {
                cell = [SZCheckVersionTableViewCell loadFromXib];
            }
            [cell configModel:model];
            return cell;
        }else{
            static NSString *normalCell = @"normalCell";
            SZNormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCell];
            if (cell==nil) {
                cell = [SZNormalTableViewCell loadFromXib];
            }
            [cell configModel:model];
            return cell;
        }
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataSource count];
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.dataSource objectAtIndex:section]count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row==2) {
            if ([self.cacheFileSize isEqualToString:@"0.00K"]) {
            }else{
                [self clearTotleCacheCompleateBlock:^(void){
                    self.cacheFileSize = [self getTotleCacheSize];
                    SZMoreNormalModel *model = [SZMoreNormalModel new];
                    model.infoTitle = @"清空缓存";
                    model.modelId = 2;
                    model.subTitle = self.cacheFileSize;
                    [self.dataSource[0] replaceObjectAtIndex:2 withObject:model];
                    [self.tableView reloadData];
                }];
            }
        }
        
    }else if (indexPath.section==1){
        switch (indexPath.row) {
            case 0:{
                NSString *url = nil;
                if (IS_IOS_7) {
                    url = @"itms-apps://itunes.apple.com/app/id";
                }else
                {
                    url = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?mt=8&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software&id=";
                }
                
                url = [url stringByAppendingString:APP_ID];
                if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:url]]) {
                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
                }
            }
                break;
            case 1:{
                
            }
                break;
            case 2:{
                if (_isCheckVersion) {
                    return;
                }
                NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:SZMORE_GETAAPPVERSION,PARAMS_METHOD_KEY,@"1",@"plat", nil];
                [SZMoreVersionCheckRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:CANCEL_SUBJECT_ON_VERSION_CHECK_REQUEST onRequestStart:^(ITTBaseDataRequest *request){
                    _isCheckVersion = YES;
                    [PROMPT_VIEW showActivity:@"检测版本中..."];
                } onRequestFinished:^(ITTBaseDataRequest *request){
                    [PROMPT_VIEW hideWithAnimation];
                    _isCheckVersion = NO;
                    if (request.isSuccess) {
                        SZMoreVersionModel *version = [request.handleredResult objectForKey:NETDATA];
                        [[self.dataSource objectAtIndex:1]replaceObjectAtIndex:2 withObject:version];
                        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:2 inSection:1], nil] withRowAnimation:UITableViewRowAnimationNone];
                        if ([version haveNew]) {
                            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"发现新版本 v%@",version.AppStoreVersion]delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更新", nil];
                            alertView.tag = 10086;
                            [alertView show];
                        }else{
                            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"您已更新到最新版本"]delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alertView show];
                        }
                        
                    }
                } onRequestCanceled:^(ITTBaseDataRequest *request){
                    [PROMPT_VIEW hideWithAnimation];
                    _isCheckVersion = NO;} onRequestFailed:^(ITTBaseDataRequest *request){
                        [PROMPT_VIEW hideWithAnimation];
                        _isCheckVersion = NO;}];
            }
                break;
            case 3:{
                SZSuggestionViewController *suggestViewController = [[SZSuggestionViewController alloc]init];
                [self pushMasterViewController:suggestViewController];
            }
                break;
            case 4:{
                [self takePhoneCall:[clientServicePhoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""]];
            }break;
            default:
                break;
        }
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:{
        }
            break;
        case 1:{
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:APP_APPLE_DOWNLOAD_URL]];
        }break;
        default:
        break;
    }
}

- (NSString *)getTotleCacheSize
{
    NSString *iTTCacheFileName = [[ITTImageCacheManager sharedManager]getImageFolder];
    float ittCacheFileSize = [CommonUtils checkTmpSizeWithCacheFileFloderName:iTTCacheFileName];
    float sdwebimgaeCacheFileSize = [[SDImageCache sharedImageCache]getSize]/1024.f/1024.f;
    float totleSize = ittCacheFileSize+ sdwebimgaeCacheFileSize;
    NSString *addString = totleSize>1?@"M":@"K";
    totleSize = totleSize>1?totleSize:totleSize *1024.f;
    return [NSString stringWithFormat:@"%.2f%@",totleSize,addString];
}

- (void)clearTotleCacheCompleateBlock:(void(^)(void))compleateBlock
{
    [[ITTImageCacheManager sharedManager]clearDiskCache];
    [[SDImageCache sharedImageCache]clearDiskCompleateBlock:compleateBlock];
}
@end
