//
//  CatalogViewController.m
//  iTotemFrame
//
//  Created by jack 廉洁 on 3/15/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "CatalogViewController.h"
#import "DataRequestTestViewController.h"
#import "ITTAdditions.h"
#import "ITTDataRequest.h"
#import "GetDemoImageDataRequest.h"
#import "ITTImageGalleryViewController.h"
#import "ActivityViewDemoViewController.h"
#import "ImageSliderViewDemoViewController.h"
#import "CoverFlowDemoViewController.h"
#import "MessageViewDemoViewController.h"
#import "PageHelpDemoViewController.h"
#import "StyledLabelDemoViewController.h"
#import "MagicalRecordCoreDataViewController.h"
#import "ImageProcessingDemoViewController.h"
#import "CameraDemoViewController.h"
#import "AutoLayoutDemoViewController.h"
#import "PullTableViewDemoController.h"
#import "SortableDemoViewController.h"
#import "HomeTabBarController.h"
#import "LandTableViewController.h"
#import "DataCacheViewController.h"
#import "WaterfallDemoViewController.h"
#import "LockViewDemoViewController.h"
#import "ImageInfoViewController.h"
#import "ShapedButtonViewController.h"
#import "VersionCheckViewController.h"
#import "ITTAlertView.h"

#import "AppDelegate.h"
#import "Catalog.h"
#import "CatalogCell.h"
#import "ITTAlertView.h"

@interface CatalogViewController ()<CatalogCellDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{
    BOOL    _useModalViewController;
    NSArray *_trasitionTypes;
    NSArray *_trasitionSubtypes;
    NSArray *_modalTrasitionTypes;
    NSArray *_catalogArray;
}

@property (strong, nonatomic) IBOutlet UISwitch *presentModeSwitch;
@property (strong, nonatomic) IBOutlet UIPickerView *trasitionPicker;
@property (strong, nonatomic) IBOutlet UIPickerView *modalTransitionPicker;
@property (strong, nonatomic) IBOutlet UIButton *pickerCancelBtn;
@property (strong, nonatomic) IBOutlet UITableView *catalogTableView;

- (IBAction)onNetworkDemoBtnClicked:(id)sender;
- (IBAction)onPhotoGalaryViewBtnClicked:(id)sender;
- (IBAction)onChangeTransitionBtnClicked:(id)sender;
- (IBAction)onPickerCancelBtnClicked:(id)sender;
- (IBAction)onPresentModeChanged:(id)sender;
- (IBAction)onTableViewDemoBtnClicked:(id)sender;
- (IBAction)onImageSliderViewDemoBtnClicked:(id)sender;
- (IBAction)onCoverFlowDemoBtnClicked:(id)sender;
- (IBAction)onPageTipDemoBtnClicked:(id)sender;
- (IBAction)onActivityViewDemoBtnClicked:(id)sender;
- (IBAction)onMessageViewDemoBtnClicked:(id)sender;
- (IBAction)onStyledLabelDemoBtnClicked:(id)sender;
- (IBAction)onShareDemoBtnClicked:(id)sender;
- (IBAction)onCoreDataDemoBtnClicked:(id)sender;
- (IBAction)onImageProcessingDemoBtnClicked:(id)sender;
- (IBAction)onCameraEffectDemoBtnClicked:(id)sender;
- (IBAction)onAutolayoutDemoBtnClicked:(id)sender;
- (IBAction)onSortableViewDemoBtnClicked:(id)sender;
- (IBAction)onImageInfoViewDemoBtnClicked:(id)sender;

- (void)setupData;
- (void)handleCatalog:(Catalog*)catalog;

@end

@implementation CatalogViewController

#pragma mark - private methods

- (void)showViewController:(UIViewController*)controller
{
    if (_useModalViewController) {
        //enclose current controller with navigation controller for easier using 
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
        int selectedTypeIndex = [_modalTransitionPicker selectedRowInComponent:0];
        navController.modalTransitionStyle = (UIViewAnimationTransition)[_modalTrasitionTypes[selectedTypeIndex] intValue];
        [self presentViewController:navController 
                           animated:YES 
                         completion:^{
                             //you can do something here;
                         }];
    }
    else {
        [self applyTrasition];
        [self.navigationController pushViewController:controller
                                             animated:TRUE];
    }
    
}

- (void)setupTransitionPickerView
{
    _trasitionPicker.top = 568;
    _modalTransitionPicker.top = 568;
}

- (UIPickerView*)currentPickerView
{
    if (_useModalViewController) {
        return _modalTransitionPicker;
    }
    else{
        return _trasitionPicker;
    }
}

- (void)showTransitionPickerView
{
    UIPickerView *currentPickerView = [self currentPickerView];
    _pickerCancelBtn.alpha = 1;
    [self.view bringSubviewToFront:_pickerCancelBtn];
    [self.view bringSubviewToFront:currentPickerView];
    [UIView animateWithDuration:0.3
                     animations:^{
                         currentPickerView.top = self.view.height - CGRectGetHeight(currentPickerView.bounds);
                     } 
                     completion:^(BOOL finished) {
                         
                     }];
}

- (void)hideTransitionPickerView
{
    UIPickerView *currentPickerView = [self currentPickerView];
    _pickerCancelBtn.alpha = 0;
    [UIView animateWithDuration:0.3
                     animations:^{
                         currentPickerView.top = 568;
                     } 
                     completion:^(BOOL finished) {
                         
                     }];
    
}

- (void)applyTrasition
{
    int selectedTypeIndex = [_trasitionPicker selectedRowInComponent:0];
    int selectedSubTypeIndex = [_trasitionPicker selectedRowInComponent:1];
    
    CATransition *transition = [CATransition animation];
	transition.duration = 0.55;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	
	transition.type = _trasitionTypes[selectedTypeIndex];
    transition.subtype = _trasitionSubtypes[selectedSubTypeIndex];
    ITTDINFO(@"using trasition type:%@, subtype:%@",transition.type,transition.subtype);
    [self.navigationController.view.layer addAnimation:transition forKey:@"key"];
}

#pragma mark - life cycle methods
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ITTIDIdlingWindowIdleNotification object:nil];
}

- (id)init
{
    //case 1: use different xib
    /*
    NSString *xibName = is4InchScreen()?@"CatalogViewController_4":@"CatalogViewController_35";
    ITTDINFO(@"using xib named:%@",xibName);
    self = [super initWithNibName:xibName bundle:nil];
     */
    //case 2: use autoresize xib
    
    self = [super initWithNibName:@"CatalogViewController" bundle:nil];
    
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTransitionPickerView];
    [self setupData];
    [self registerAppIdleNotification];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [AppDelegate GetAppDelegate].tabBarController.tabBarHidden = FALSE;
}

- (void)viewDidUnload
{
    [self setCatalogTableView:nil];
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

#pragma mark - public methods

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)onNetworkDemoBtnClicked:(id)sender
{
    DataRequestTestViewController *demoController = [[DataRequestTestViewController alloc] initWithNibName:@"DataRequestTestViewController" bundle:nil];
    [self showViewController:demoController];
}

- (IBAction)onPhotoGalaryViewBtnClicked:(id)sender
{
    [GetDemoImageDataRequest requestWithParameters:nil
                                 withIndicatorView:self.view
                                 withCancelSubject:@"GetDemoImageDataRequestCancel"
                                 onRequestFinished:^(ITTBaseDataRequest *request) {
                                    [AppDelegate GetAppDelegate].tabBarController.tabBarHidden = TRUE;
                                     NSArray *images = (NSArray*)(request.handleredResult)[@"imageList"];
                                     ITTDINFO(@"!!!!!!!!!!!!!_requestResultArray:%@",images);
                                     ITTImageGalleryViewController *psvc = [[ITTImageGalleryViewController alloc] initWithImages:images selectedIndex:0 title:@"测试ImageGallery"];
                                     [self showViewController:psvc];
                                     /*
                                      PhotoSlideViewController *galleryVC = [[PhotoSlideViewController alloc] initWithImages:images selectedIndex:0];
                                      [self presentModalViewController:galleryVC animated:YES];
                                      [galleryVC release];
                                      */
                                 }];
    
}


- (IBAction)onChangeTransitionBtnClicked:(id)sender
{
    [self showTransitionPickerView];
}

- (IBAction)onPickerCancelBtnClicked:(id)sender
{
    [self hideTransitionPickerView];
}

- (IBAction)onPresentModeChanged:(id)sender
{
    if (_presentModeSwitch.on) {
        _useModalViewController = YES;
    }else {
        _useModalViewController = NO;
    }
}

- (IBAction)onTableViewDemoBtnClicked:(id)sender
{
//    NewsListViewController *demoController = [[NewsListViewController alloc] init];
//    [self showViewController:demoController];
    
    PullTableViewDemoController *demoController = [[PullTableViewDemoController alloc] initWithNibName:@"PullTableViewDemoController" bundle:nil];
    ITTDINFO(@"demoController %@", demoController);
    [self showViewController:demoController];
    
//    PullTableViewDemoController *demoController = [[PullTableViewDemoController alloc] init];
//    [self showViewController:demoController];
}

- (IBAction)onImageSliderViewDemoBtnClicked:(id)sender
{
    ImageSliderViewDemoViewController *demoController = [[ImageSliderViewDemoViewController alloc] initWithNibName:@"ImageSliderViewDemoViewController" bundle:nil];
    [self showViewController:demoController];
}

- (IBAction)onCoverFlowDemoBtnClicked:(id)sender
{
    CoverFlowDemoViewController *demoController = [[CoverFlowDemoViewController alloc] initWithNibName:@"CoverFlowDemoViewController" bundle:nil];
    [self showViewController:demoController];
}

- (IBAction)onPageTipDemoBtnClicked:(id)sender
{
    PageHelpDemoViewController *demoController = [[PageHelpDemoViewController alloc] initWithNibName:@"PageHelpDemoViewController" bundle:nil];
    [self showViewController:demoController];
}

- (IBAction)onActivityViewDemoBtnClicked:(id)sender
{
    ActivityViewDemoViewController *demoController = [[ActivityViewDemoViewController alloc] initWithNibName:@"ActivityViewDemoViewController" bundle:nil];
    [self showViewController:demoController];
}

- (IBAction)onMessageViewDemoBtnClicked:(id)sender
{
    MessageViewDemoViewController *demoController = [[MessageViewDemoViewController alloc] initWithNibName:@"MessageViewDemoViewController" bundle:nil];
    [self showViewController:demoController];
    
}

- (IBAction)onStyledLabelDemoBtnClicked:(id)sender
{
    StyledLabelDemoViewController *demoController = [[StyledLabelDemoViewController alloc] initWithNibName:@"StyledLabelDemoViewController" bundle:nil];
    [self showViewController:demoController];
}

- (IBAction)onShareDemoBtnClicked:(id)sender
{
//    ShareDemoViewController *demoController = [[ShareDemoViewController alloc] init];
//    [self showViewController:demoController];
//    [demoController release];
}

- (IBAction)onCoreDataDemoBtnClicked:(id)sender
{
    MagicalRecordCoreDataViewController *demoController = [[MagicalRecordCoreDataViewController alloc] initWithNibName:@"MagicalRecordCoreDataViewController" bundle:nil];
    [self showViewController:demoController];
}

- (IBAction)onImageProcessingDemoBtnClicked:(id)sender
{
    ImageProcessingDemoViewController *demoController = [[ImageProcessingDemoViewController alloc] initWithNibName:@"ImageProcessingDemoViewController" bundle:nil];
    [self showViewController:demoController];
}

- (IBAction)onCameraEffectDemoBtnClicked:(id)sender
{
    CameraDemoViewController *demoController = [[CameraDemoViewController alloc] initWithNibName:@"CameraDemoViewController" bundle:nil];
    [self showViewController:demoController];
}

- (IBAction)onAutolayoutDemoBtnClicked:(id)sender
{
    CGFloat systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersion >= 6.0) {
        AutoLayoutDemoViewController *demoController = [[AutoLayoutDemoViewController alloc] init];
        [self showViewController:demoController];
    }
    else {
        [ITTAlertView alertWithMessage:@"当前系统版本不支持!" inView:self.view withDelegate:nil];
    }
}

- (IBAction)onCalendarDemoBtnClicked:(id)sender
{

}

- (IBAction)onLandTableViewDemoBtnClicked:(id)sender
{
    LandTableViewController *demoController = [[LandTableViewController alloc] initWithNibName:@"LandTableViewController" bundle:nil];
    [self showViewController:demoController];
}


- (IBAction)onDataCacheDemoBtnClicked:(id)sender
{
    DataCacheViewController *demoController = [[DataCacheViewController alloc] initWithNibName:@"DataCacheViewController" bundle:nil];
    [self showViewController:demoController];
}

- (IBAction)onSortableViewDemoBtnClicked:(id)sender
{
    SortableDemoViewController *demoController = [[SortableDemoViewController alloc] initWithNibName:@"SortableDemoViewController" bundle:nil];
    [self showViewController:demoController];
}

- (IBAction)onLockViewDemoBtnClicked:(id)sender
{
     LockViewDemoViewController *demoController = [[LockViewDemoViewController alloc] initWithNibName:@"LockViewDemoViewController" bundle:nil];
    [self showViewController:demoController];
}

- (void)onWaterfallDemoBtnClicked:(id)sender
{
    WaterfallDemoViewController *demoController = [[WaterfallDemoViewController alloc] initWithNibName:@"WaterfallDemoViewController" bundle:nil];
    [self showViewController:demoController];
}

- (IBAction)onImageInfoViewDemoBtnClicked:(id)sender
{
    ImageInfoViewController *demoController = [[ImageInfoViewController alloc] initWithNibName:@"ImageInfoViewController" bundle:nil];
    [self showViewController:demoController];
}

- (void)onShapedBtnClicked:(id)sender
{
	ShapedButtonViewController *demoController = [[ShapedButtonViewController alloc] initWithNibName:@"ShapedButtonViewController" bundle:nil];
	[self showViewController:demoController];
}

- (void)onVersionUpdateBtnClicked:(id)sender
{
	VersionCheckViewController *demoController = [[VersionCheckViewController alloc] initWithNibName:@"VersionCheckViewController" bundle:nil];
	[self showViewController:demoController];
}

#pragma mark - UIPickerViewDataSource methods
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView == _modalTransitionPicker) {
        return 1;
    }
    else if(pickerView == _trasitionPicker) {
        return 2;
    }
    return 0;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == _modalTransitionPicker) {
        return [_modalTrasitionTypes count];
    }else if(pickerView == _trasitionPicker){
        if (component == 0) {
            return [_trasitionTypes count];
        }
        if (component == 1) {
            return [_trasitionSubtypes count];
        }
    }
    return 0;
}

#pragma mark - UIPickerViewDelegate methods
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //ITTDINFO(@"test picker selection event");
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = nil;
    if (pickerView == _modalTransitionPicker) {
        UIModalTransitionStyle tran = (UIModalTransitionStyle)[_modalTrasitionTypes[row] intValue];
        switch (tran) {
            case UIModalTransitionStyleCoverVertical:{
                title = @"CoverVertical";
                break;
            }
            case UIModalTransitionStyleFlipHorizontal:{
                title = @"FlipHorizontal";
                break;
            }
            case UIModalTransitionStyleCrossDissolve:{
                title = @"CrossDissolve";
                break;
            }
            case UIModalTransitionStylePartialCurl:{
                title = @"PartialCurl";
                break;
            }
                
            default:
                ITTDERROR(@"something is wrong here!!!");
                break;
        }
    }
    else if(pickerView == _trasitionPicker){
        if (component == 0) {
            title = _trasitionTypes[row];
        }
        if (component == 1) {
            title = _trasitionSubtypes[row];
        }
    }
    return title;
}

#pragma mark - private
- (void)setupData
{
    _useModalViewController = FALSE;
    _trasitionTypes = [[NSArray alloc] initWithObjects:
                       kCATransitionFade,
                       kCATransitionMoveIn,
                       kCATransitionPush,
                       kCATransitionReveal,
                       nil];
    _trasitionSubtypes = [[NSArray alloc] initWithObjects:
                          kCATransitionFromBottom,
                          kCATransitionFromTop,
                          kCATransitionFromLeft,
                          kCATransitionFromRight,
                          nil];
    _modalTrasitionTypes = [[NSArray alloc] initWithObjects:
                            @(UIModalTransitionStyleCoverVertical),
                            @(UIModalTransitionStyleFlipHorizontal),
                            @(UIModalTransitionStyleCrossDissolve),
                            @(UIModalTransitionStylePartialCurl),
                            nil];
    
    NSString *catalogPath = [[NSBundle mainBundle] pathForResource:@"catalog" ofType:@"plist"];
    NSArray *catalogDicArray = [NSArray arrayWithContentsOfFile:catalogPath];
    NSMutableArray *catalogArray = [[NSMutableArray alloc] init];
    for (NSDictionary *catalogDic in catalogDicArray) {
        Catalog *catalog = [[Catalog alloc] initWithDataDic:catalogDic];
        [catalogArray addObject:catalog];
    }
    _catalogArray = catalogArray;
}

- (void) registerAppIdleNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleIdle) name:ITTIDIdlingWindowIdleNotification object:nil];
}

- (void)handleIdle
{
    [ITTAlertView alertWithMessage:ITTIDIdlingWindowIdleNotification inView:self.view withDelegate:nil];
}

- (void)handleCatalog:(Catalog*)catalog
{
    switch (catalog.catalogType) {
        case CatalogTypeTrasition:
            [self showTransitionPickerView];
            break;
        case CatalogTypeNetwork:
            [self onNetworkDemoBtnClicked:nil];
            break;
        case CatalogTypePhotoGalaryView:
            [self onPhotoGalaryViewBtnClicked:nil];
            break;
        case CatalogTypeImageSliderView:
            [self onImageSliderViewDemoBtnClicked:nil];
            break;
        case CatalogTypeTableView:
            [self onTableViewDemoBtnClicked:nil];
            break;
        case CatalogTypeCoverFlow:
            [self onCoverFlowDemoBtnClicked:nil];
            break;
        case CatalogTypeActivityIndicator:
            [self onActivityViewDemoBtnClicked:nil];
            break;
        case CatalogTypeAlert:
            [self onMessageViewDemoBtnClicked:nil];
            break;
        case CatalogTypeNewerHelp:
            [self onPageTipDemoBtnClicked:nil];
            break;
        case CatalogTypeStypedLabel:
            [self onStyledLabelDemoBtnClicked:nil];
            break;
        case CatalogTypeShare:
            [self onShareDemoBtnClicked:nil];
            break;
        case CatalogTypeImageProcess:
            [self onImageProcessingDemoBtnClicked:nil];
            break;
        case CatalogTypeCamera:
            [self onCameraEffectDemoBtnClicked:nil];
            break;
        case CatalogTypeCoreData:
            [self onCoreDataDemoBtnClicked:nil];
            break;
        case CatalogTypeAutoLayout:
            [self onAutolayoutDemoBtnClicked:nil];
            break;
        case CatalogTypeCalendarView:
            [self onCalendarDemoBtnClicked:nil];
            break;
        case CatalogTypeLandTableView:
            [self onLandTableViewDemoBtnClicked:nil];
            break;
        case CatalogTypeDataCache:
            [self onDataCacheDemoBtnClicked:nil];
            break;
        case CatalogTypeSortableView:
            [self onSortableViewDemoBtnClicked:nil];
            break;
        case CatalogTypeWaterfall:
            [self onWaterfallDemoBtnClicked:nil];
            break;
        case CatalogTypeLockView:
            [self onLockViewDemoBtnClicked:nil];
            break;
        case CatalogTypeImageInfoView:
            [self onImageInfoViewDemoBtnClicked:nil];
            break;
		case CatalogTypeShapedButton:
			[self onShapedBtnClicked:nil];
			break;
		case CatalogTypeVersionUpdate:
			[self onVersionUpdateBtnClicked:nil];
			break;
        default:
            break;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_catalogArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CatalogCell";
    CatalogCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [CatalogCell cellFromNib];
        cell.delegate = self;        
    }
    if (0 == indexPath.row) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else {
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;        
    }
    cell.catalog = [_catalogArray objectAtIndex:indexPath.row];
    cell.index = indexPath.row;
    cell.numberOfRowsInSection = [_catalogArray count];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    Catalog *catalog = [_catalogArray objectAtIndex:indexPath.row];
    [self handleCatalog:catalog];
}

#pragma mark - CatalogCellDelegate
- (void)catalogCellDidUseModalView:(CatalogCell*)catalogCell used:(BOOL)used
{
    _useModalViewController = used;
}
@end
