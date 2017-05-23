//
//  DataRequestTestViewController.m
//  iTotemFrame
//
//  Created by jack 廉洁 on 3/12/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "DataRequestTestViewController.h"
#import "DataRequest.h"
#import "ITTCommonFunctions.h"
#import "ITTGobalPaths.h"
#import "ITTCommonMacros.h"
#import "ITTAdditions.h"
#import "AFJSONRequestOperation.h"
#import "DemoDataRequest.h"
#import "AFNDownloadDataRequest.h"
#import "ITTFileModel.h"

@interface DataRequestTestViewController ()

@property (strong, nonatomic) IBOutlet UILabel *progressLabel;
@property (strong, nonatomic) IBOutlet UILabel *afnProgressLabel;

- (IBAction)startRequest:(id)sender;
- (IBAction)startBlockRequest:(id)sender;
- (IBAction)startDownloadRequest:(id)sender;

@end

@implementation DataRequestTestViewController
#pragma mark - private methods


#pragma mark - lifecycle methods

- (void)setup
{
    _requestResultArray = [[NSMutableArray alloc] init];
}

- (id)init
{
    self = [super initWithNibName:@"DataRequestTestViewController" bundle:nil];
    if (self) {
        [self setup];
        self.navTitle = @"网络测试";
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setAfnProgressLabel:nil];
    [super viewDidUnload];
}

#pragma mark - private Methods
- (IBAction)startAFNetworkingDownloadRequest:(id)sender
{
    NSString *filePath = ITTPathForCacheResource(@"download_test.zip");
    [AFNDownloadDataRequest requestWithParameters:nil
                                 withIndicatorView:self.view
                                 withCancelSubject:@"DownloadDemoDataRequestCancel"
                                      withFilePath:filePath
                                 onRequestFinished:^(ITTBaseDataRequest *request) {
                                     ITTDINFO(@"DownloadDemoDataRequest finished");
                                     _afnProgressLabel.text = @"done";
                                 }
                                 onProgressChanged:^(ITTBaseDataRequest *request, float progress) {
                                     ITTDINFO(@"DownloadDemoDataRequest progress changed:%2.2f",progress);
                                     _afnProgressLabel.text = [NSString stringWithFormat:@"%2.2f%@", progress*100, @"%"];
                                 }
     ];    
}

- (IBAction)startAFNetworkingRequest:(id)sender
{
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"catalog" ofType:@"plist"];
//    NSArray *array = [NSArray arrayWithContentsOfFile:path];
//    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
//    ITTFileModel *fileModel = [[ITTFileModel alloc] init];
//    fileModel.fileName = @"catalog.plist";
//    fileModel.data = data;
//    UIImage *image = [UIImage imageNamed:@"placeholder.png"];
//    NSDictionary *params = @{@"upfile":image};
//    [fileModel release];
//    [DemoDataRequest requestWithDelegate:self withParameters:params withIndicatorView:self.view];
    
    for (NSInteger i = 0; i < 10; i++) {
        NSDictionary *params = @{@"format":@"json"};
        //    [DemoDataRequest requestWithDelegate:self withParameters:params withIndicatorView:self.view];
        [DemoDataRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:nil onRequestFinished:^(ITTBaseDataRequest *request){
            ITTDINFO(@"block success!");
        }];
        
    }
}

- (IBAction)startRequest:(id)sender
{
    NSDictionary *params = @{@"type": @"0",
                             @"page": @"0"};
    [NewsListDataRequest requestWithParameters:params withIndicatorView:self.view withCancelSubject:@"NewsListCancel" onRequestFinished:^(ITTBaseDataRequest *request){
    }];
}

- (IBAction)startBlockRequest:(id)sender
{
    [NewsListDataRequest requestWithParameters:@{@"type": @"0",
                                                @"page": @"0"}
                             withIndicatorView:self.view
                             withCancelSubject:@"NewsListCancel"
                             onRequestFinished:^(ITTBaseDataRequest *request) {                                 
                                 [_requestResultArray addObject:request.rawResultString];
                                 ITTDINFO(@"!!!!!!!!!!!!!_requestResultArray count:%d",[_requestResultArray count]);
                                 ITTDINFO(@"!!!!!!!!!!!!!_requestResultArray:%@",_requestResultArray);
                             }];
    
}

- (IBAction)startDownloadRequest:(id)sender
{
    NSString *filePath = ITTPathForCacheResource(@"download_test.zip");
    [DownloadDemoDataRequest requestWithParameters:nil 
                                 withIndicatorView:nil 
                                 withCancelSubject:@"DownloadDemoDataRequestCancel" 
                                      withFilePath:filePath 
                                 onRequestFinished:^(ITTBaseDataRequest *request) {
                                     ITTDINFO(@"DownloadDemoDataRequest finished");
                                     _progressLabel.text = @"done";
                                 }
							     onRequestFailed:^(ITTBaseDataRequest *request) {
									 ITTDINFO(@"onRequestFailed");
								 }
                                 onProgressChanged:^(ITTBaseDataRequest *request, float progress) {
                                     ITTDINFO(@"DownloadDemoDataRequest progress changed:%2.2f",progress);
                                     _progressLabel.text = [NSString stringWithFormat:@"%2.2f%@",progress*100,@"%"];
                                 }
     ];
}

#pragma mark - DataRequestDelegate
- (void)requestDidFinishLoad:(ITTBaseDataRequest*)request
{
    ITTDINFO(@"request successed");
}

- (void)request:(ITTBaseDataRequest *)request didFailLoadWithError:(NSError *)error
{
    ITTDINFO(@"request error %@", error);
}

@end
