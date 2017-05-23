//
//  WaterFallDemoViewController.m
//  iTotemFramework
//
//  Created by Sword on 13-10-23.
//  Copyright (c) 2013年 iTotemStudio. All rights reserved.
//

#import "WaterfallDemoViewController.h"
#import "ITTWaterFallTableView.h"
#import "TestWaterfallTableCell.h"
#import "PictureModel.h"
#import "AppDelegate.h"
#import "HomeTabBarController.h"
#import "ITTAlertView.h"
#import "UIDevice+ITTAdditions.h"

@interface WaterfallDemoViewController ()
{
    NSMutableArray *_picArray;
}

@property (weak, nonatomic) IBOutlet ITTWaterFallTableView *waterFallTableView;

@end

@implementation WaterfallDemoViewController

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
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.waterFallTableView.enablePullToRefresh = TRUE; 
    [AppDelegate GetAppDelegate].tabBarController.tabBarHidden = TRUE;
    [self loadData];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [NSObject cancelPreviousPerformRequestsWithTarget:_waterFallTableView selector:@selector(didFinishLoading) object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ITTWaterFallTableViewDataSource methods
- (NSInteger)numberOfRowsWaterFallTableView:(ITTWaterFallTableView*)tableView
{
    return [_picArray count];
}

- (ITTWaterFallTableCell*)waterFallTableView:(ITTWaterFallTableView*)tableView cellAtIndex:(int)index
{
    static NSString *reusableCellId = @"TestWaterfallTableCell";
    TestWaterfallTableCell *testWaterfallCell = (TestWaterfallTableCell*)[tableView dequeueReusableCellWithIdentifier:reusableCellId];
    if (!testWaterfallCell) {
        testWaterfallCell = [TestWaterfallTableCell cellFromNibWithIdentifier:reusableCellId];
    }
    PictureModel *pic = [_picArray objectAtIndex:index];
    testWaterfallCell.index = index;
    testWaterfallCell.picture = pic;
    return testWaterfallCell;
}

- (NSInteger)waterFallTableView:(ITTWaterFallTableView*)tableView heightOfCellAtIndex:(int)index
{
    PictureModel *picture = [_picArray objectAtIndex:index];    
    if(index == 0) {
        return 72;
    }
    else if(1 == index) {
        return 144;
    }
    else if(2 == index) {
        return 96;
    }
    else {
        int height = 0;
        NSString *wh = picture.image_wh;
        NSRange range = [wh rangeOfString:@"|"];
        if(range.length > 0) {
            height = [[wh substringFromIndex:range.location + 1] intValue];
        }
        if(height < 500) {
            return 72;
        }
        else if(height > 500 && height < 1000) {
            return 96;
        }
        else {
            return 144;
        }
    }
}

#pragma mark - ITTWaterFallTableViewDelegate
- (void)waterFallTableView:(ITTWaterFallTableView*)tableView didSelectedCellAtIndex:(int)index
{
    ITTDINFO(@"didSelectedCellAtIndex %d", index);
//    [ITTAlertView alertWithMessage:[NSString stringWithFormat:@"Index:%d", index] inView:self.view onCancel:^{
//    } onConfirm:^{
//    }];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"index:%d", index] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

- (void)waterFallTableViewDidDrigglerFrefresh:(ITTWaterFallTableView*)tableView
{
    ITTDINFO(@"waterFallTableViewDidDrigglerFrefresh");
    [tableView performSelector:@selector(didFinishLoading) withObject:nil afterDelay:2.0];
}

- (void)waterFallTableViewDidTriggleLoadMore:(ITTWaterFallTableView*)tableView
{
    ITTDINFO(@"waterFallTableViewDidTriggleLoadMore");
    [tableView performSelector:@selector(didFinishLoading) withObject:nil afterDelay:2.0];
}
    
#pragma mark - private methods
- (void)loadData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"pictures" ofType:@"txt"];
    NSString *jsonString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    NSArray *pidDicArray = dataDic[@"data"][@"image_list"];
    _picArray = [NSMutableArray array];
    for (id picDic in pidDicArray) {
        PictureModel *pic = [[PictureModel alloc] initWithDataDic:picDic];
        [_picArray addObject:pic];
    }
    [_waterFallTableView reloadData];
}

@end
