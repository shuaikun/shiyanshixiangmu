//
//  SMDocSearchViewController.m
//  com.knowesoft.legalregs
//
//  Created by Golun on 2015-01-08.
//  Copyright (c) 2015年 Knowesoft. All rights reserved.
//

#import "SMDocSearchViewController.h"
#import "SZMoreNormalModel.h"
#import "SZMoreSwitchModel.h"
#import "SMNormalTableViewCell.h"
#import "SMReportViewController.h"
#import "AppDelegate.h"

int layer;
NSString *currentUrlPath;

@interface SMDocSearchViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, copy) NSString *cacheFileSize;

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@property (nonatomic, strong) NSMutableArray *paths;

@property (weak, nonatomic) IBOutlet UIView *topView;

@end

@implementation SMDocSearchViewController


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
    [self setTitle:@"搜索"];
    [self hiddenBackButton];
    self.baseTopView.hidden = YES;
    [self.searchTextField setTop:72.0f];
    [self.tableView setTop:self.searchTextField.height + 72];
    if ([[UIDevice currentDevice] is47InchScreen]){
        self.tableView.height += 65.0;
    }
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.topView.backgroundColor = UIColorBlue;
    
    
    self.searchTextField.delegate = self;
    
    [self.searchTextField becomeFirstResponder];
    
    self.paths = [[NSMutableArray alloc] init];
    layer = 0;
    [self loadModels];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[[AppDelegate GetAppDelegate] masterNavigationController] setNavigationBarHidden:YES];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)loadModels
{
    if (self.dataSource == nil){
        self.dataSource = [[NSMutableArray alloc]init];
    }
    NSMutableArray *sectionZero = [[NSMutableArray alloc]init];
    NSMutableArray *sectionOne = [[NSMutableArray alloc]init];
    
    [self.dataSource removeAllObjects];
    [self.dataSource addObject:sectionZero];
    [self.dataSource addObject:sectionOne];
    
    NSString *keyword = self.searchTextField.text;
    NSArray *files = [[UserManager sharedUserManager] getDocFileWithKeyword:keyword];
    for (int i = 0; i<[files count]; i++) {
        SZMoreNormalModel *model = [SZMoreNormalModel new];
        model.infoTitle = [files[i] lastPathComponent];
        //model.urlPath = [files[i] path];
        model.modelId = i;
        model.subTitle = @"";
        [sectionOne addObject:model];
    }
    
    if ([files count] == 0){
        [self.infoLabel setText:@"无数据显示"];
        [self.infoLabel setHidden:NO];
    }
    else{
        [self.infoLabel setHidden:YES];
    }
    
    if (layer > 0){
        [self.backButton setHidden:YES];
    }
    else{
        [self.backButton setHidden:YES];
    }
    
    [self.tableView reloadData];
}


#pragma mark tableViewDelegates

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *datasource = [self.dataSource objectAtIndex:indexPath.section];
    SZMoreNormalModel *model = [datasource objectAtIndex:indexPath.row];
    if (indexPath.section==0) {
        static NSString *normalCell = @"normalCell";
        SMNormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCell];
        if (cell==nil) {
            cell = [SMNormalTableViewCell loadFromXib];
        }
        if (indexPath.row==0){
            cell.isFirstItem = true;
        }
        [cell configModel:model];
        return cell;
        
    }else{
        static NSString *normalCell = @"normalCell";
        SMNormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCell];
        if (cell==nil) {
            cell = [SMNormalTableViewCell loadFromXib];
        }
        if (indexPath.row==0){
            cell.isFirstItem = true;
        }
        [cell configModel:model];
        return cell;
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
    __weak typeof(self) weakSelf = self;
    NSMutableArray *datasource = [self.dataSource objectAtIndex:indexPath.section];
    SZMoreNormalModel *model = [datasource objectAtIndex:indexPath.row];
    
    if (model.urlPath != nil){
        [self showFileContentWithUrlPath:model.urlPath];
    }
    else{
        NSString *parentKey = model.infoTitle;
        layer += 1;
        [[self paths] addObject:parentKey];
        [self loadModels];
    }
    
    return;
    
    if (indexPath.section==0) {
        switch (indexPath.row) {
            case 0:{
                [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken) {
                    typeof(self) strongSelf = weakSelf;
                    SMReportViewController *reportViewController = [[SMReportViewController alloc] initWithNibName:@"SMReportViewController" bundle:nil];
                    [reportViewController setIsFromHomePage:YES];
                    [reportViewController setChoice:kTagReportOneChoiceRB];
                    [strongSelf pushMasterViewController:reportViewController];
                }];
            }
                break;
            case 1:{
                [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken) {
                    typeof(self) strongSelf = weakSelf;
                    SMReportViewController *reportViewController = [[SMReportViewController alloc] initWithNibName:@"SMReportViewController" bundle:nil];
                    [reportViewController setIsFromHomePage:YES];
                    [reportViewController setChoice:kTagReportOneChoiceZB];
                    [strongSelf pushMasterViewController:reportViewController];
                }];
            }
                break;
            case 2:{
                [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken) {
                    typeof(self) strongSelf = weakSelf;
                    SMReportViewController *reportViewController = [[SMReportViewController alloc] initWithNibName:@"SMReportViewController" bundle:nil];
                    [reportViewController setIsFromHomePage:YES];
                    [reportViewController setChoice:kTagReportOneChoiceYB];
                    [strongSelf pushMasterViewController:reportViewController];
                }];
            }
                break;
            case 3:{
                [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken) {
                    typeof(self) strongSelf = weakSelf;
                    SMReportViewController *reportViewController = [[SMReportViewController alloc] initWithNibName:@"SMReportViewController" bundle:nil];
                    [reportViewController setIsFromHomePage:YES];
                    [reportViewController setChoice:kTagReportOneChoiceWork];
                    [strongSelf pushMasterViewController:reportViewController];
                }];
            }
                break; 
            default:
                break;
        }
        
    }else if (indexPath.section==1){
        switch (indexPath.row) {
            case 0:{
                [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken) {
                    typeof(self) strongSelf = weakSelf;
                    SMReportViewController *reportViewController = [[SMReportViewController alloc] initWithNibName:@"SMReportViewController" bundle:nil];
                    [reportViewController setIsFromHomePage:YES];
                    [reportViewController setChoice:kTagReportOneChoiceAuditRB];
                    [strongSelf pushMasterViewController:reportViewController];
                }];
            }
                break;
            case 1:{
                [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken) {
                    typeof(self) strongSelf = weakSelf;
                    SMReportViewController *reportViewController = [[SMReportViewController alloc] initWithNibName:@"SMReportViewController" bundle:nil];
                    [reportViewController setIsFromHomePage:YES];
                    [reportViewController setChoice:kTagReportOneChoiceAuditZB];
                    [strongSelf pushMasterViewController:reportViewController];
                }];
            }
                break;
            case 2:{
                [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken) {
                    typeof(self) strongSelf = weakSelf;
                    SMReportViewController *reportViewController = [[SMReportViewController alloc] initWithNibName:@"SMReportViewController" bundle:nil];
                    [reportViewController setIsFromHomePage:YES];
                    [reportViewController setChoice:kTagReportOneChoiceAuditYB];
                    [strongSelf pushMasterViewController:reportViewController];
                }];
            }
                break;
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


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (BOOL)prefersStatusBarHidden
{
    return NO;
}


//-----------------------------------------------------------
//NSMutableArray *aRefImgs; // global variable.

//void setRefImgs(NSMutableArray *ref){
//    aRefImgs=ref;
//}

//NSMutableArray* ImgArrRef(){
//    return aRefImgs;
//}

/*CGPDFDocumentRef MyGetPDFDocumentRef (const char *filename) {
 CFStringRef path;
 CFURLRef url;
 CGPDFDocumentRef document;
 path = CFStringCreateWithCString (NULL, filename,kCFStringEncodingUTF8);
 url = CFURLCreateWithFileSystemPath (NULL, path, kCFURLPOSIXPathStyle, 0);
 CFRelease (path);
 document = CGPDFDocumentCreateWithURL (url);// 2
 CFRelease(url);
 int count = CGPDFDocumentGetNumberOfPages (document);// 3
 if (count == 0) {
 printf("`%s' needs at least one page!", filename);
 return NULL;
 }
 return document;
 }*/

/*size_t *totalPages;
void MyDisplayPDFPage (CGContextRef myContext,size_t pageNumber,const char *filename, CGPDFOperatorTableRef tblRef, NSMutableString *mainStr) {
    CGPDFDocumentRef document;
    CGPDFPageRef page;
    document = MyGetPDFDocumentRef (filename);// 1
    totalPages=CGPDFDocumentGetNumberOfPages(document);
    page = CGPDFDocumentGetPage (document, pageNumber);// 2
    CGContextDrawPDFPage (myContext, page);// 3
    CGContextTranslateCTM(myContext, 0, 20);
    CGContextScaleCTM(myContext, 1.0, -1.0);
    CGPDFDocumentRelease (document);// 4
}*/

#pragma mark - #pragma mark QLPreviewControllerDataSource

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController*)controller  {
    return 1;
}

- (id<QLPreviewItem>)previewController:(QLPreviewController*)controller previewItemAtIndex:(NSInteger)index  {
    //3.大气污染物综合排放标准
    
    //NSString *pdfPath = [[NSBundle mainBundle] pathForResource:@"3.大气污染物综合排放标准" ofType:@"pdf"];
    NSString *pdfPath = currentUrlPath;
    if (pdfPath != NULL){
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

-(void)showFileContentWithUrlPath:(NSString*)path
{
    
    [[UserManager sharedUserManager] addHomeViewHis:path];
    
    currentUrlPath = path;
    [[[AppDelegate GetAppDelegate] masterNavigationController] setNavigationBarHidden:NO];
    
    QLPreviewController *previewController = [[QLPreviewController alloc] init];
    previewController.dataSource = self;
    previewController.delegate = self;
    previewController.currentPreviewItemIndex = 0;
    //[self pushViewController:previewController];
    [self pushMasterViewController:previewController];
}



-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    if ([[theTextField text] length] > 0)
    {
        [self loadModels];
    }
    return YES;
}

@end

