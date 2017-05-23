//
//  SMReportEditViewController.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-9-2.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMReportRBEditViewController.h"
#import "ITTPullTableView.h"
#import "AppDelegate.h"
#import "SMRptRBRequest.h"
#import "SMRptRBItemModel.h"
#import "SMRptRBItemCell.h"
#import "SMOnButtonCell.h"
#import "SMRptRBItemPickView.h"
#import "UIUtil.h"
#import "SMRptRBEditRequest.h"
#import "SMRptRBRemoveRequest.h"

@interface SMReportRBEditViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *dateButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *nodataLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *pickerView;
@property (weak, nonatomic) IBOutlet UIView *pickerUIView;

@property (weak, nonatomic) IBOutlet UITextView *tommemoTextView;
@property (weak, nonatomic) IBOutlet UITextView *summarizeTextView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;

@property (strong, nonatomic) NSMutableArray *preferentialArray;

@property (assign, nonatomic) int currentPage;
@property (assign, nonatomic) BOOL isLoading;
@property (assign, nonatomic) BOOL notShowLoading;

@property (strong, nonatomic) SMRptRBModel *model;


@property (nonatomic, strong) UIWindow *editRBItemPickWindow;
@property (nonatomic, strong) SMRptRBItemPickView *editRBItemPickView;


@property int selectRow;
@property int selftop;


@end

@implementation SMReportRBEditViewController

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
    
    [self hiddenTopView];
    
    _tommemoTextView.delegate = self;
    _summarizeTextView.delegate = self;
    
    _currentPage = 0;
    _notShowLoading = NO;
    _preferentialArray = [NSMutableArray array];
    
    [self initUserData];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    _pickerUIView.top = self.view.height;
}

- (IBAction)backBtnClick:(id)sender {
    [self baseTopViewBackButtonClicked];
}


- (IBAction)buttonDidClicked:(id)sender {
    [self clearPickViews];
    
    if ([sender tag] >= 0){
        [self saveData: [sender tag]];
        
    }
    else{
        //remove ...
        [self removeData];
    }
    
    //[self baseTopViewBackButtonClicked];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectDate:(id)sender {
    [_tommemoTextView endEditing:YES];
    [_summarizeTextView endEditing:YES];
    
    if (_pickerUIView.tag == 0){
        [UIView animateWithDuration:0.2 animations:^{
            _pickerUIView.top = self.view.height - _pickerUIView.height;
        }];
    
        [_pickerView setDate:[NSDate dateWithString:_model.date formate:@"yyyy-MM-dd"] animated:YES];
        _pickerUIView.tag = 1;
    }
    else{
        _pickerUIView.tag = 0;
        [UIView animateWithDuration:0.2 animations:^{
            _pickerUIView.top = self.view.height;
        }];
    }
}

-(void)dateChanged:(id)sender{
    [_dateButton setTitle: [UIUtil getDateString:[_pickerView date]] forState:UIControlStateNormal];
}

-(void)setReportData:(SMRptRBModel*)model
{
    if (model == nil){
        _model = [[SMRptRBModel alloc] init];
        _model.id= @"";
    }
    else{
        _model = model;
    }
    
    
    if (IS_STRING_EMPTY(_model.date)){
        _model.date = [UIUtil getDateString:[NSDate new]];
    }
    
}

-(void)initUserData
{
    [_preferentialArray removeAllObjects];
    
    
    NSArray *itemlist = _model.dailys;
    if(itemlist && [itemlist isKindOfClass:[NSArray class]])
    {
        for (int i=0; i<[itemlist count]; i++) {
            SMRptRBItemModel *item = [[SMRptRBItemModel alloc]initWithDataDic: [itemlist objectAtIndex:i]];
            [_preferentialArray addObject:item];
        }
    }
    
    [_preferentialArray addObject:[[SMRptRBItemModel alloc] init]];
    
    
    //form data ....
    [_dateButton setTitle:_model.date forState:UIControlStateNormal];
    [_tommemoTextView setText:_model.tommemo];
    [_summarizeTextView setText:_model.summarize];     
    
    _pickerUIView.top = self.view.bottom;
    [_pickerView removeTarget:self action:@selector(dataChanged:) forControlEvents:UIControlEventValueChanged];
    [_pickerView addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
    
    _isLoading = NO;
    [self refreshDataDone];
    [self loadMoreDataDone];
   
    [_tableView reloadData];
}

-(void)editRBItem:(SMRptRBItemModel*)model
{
    if (_editRBItemPickWindow == nil) {
        self.editRBItemPickWindow = [[UIWindow alloc] initWithFrame:(CGRect) {{0.f,0.f}, [[UIScreen mainScreen] bounds].size}];
        CALayer *hudLayer = [CALayer layer];
        hudLayer.frame = CGRectMake(0, 0, _editRBItemPickWindow.width, _editRBItemPickWindow.height);
        hudLayer.backgroundColor = [UIColor blackColor].CGColor;
        hudLayer.opacity = 0.6;
        
        _editRBItemPickWindow.backgroundColor = [UIColor clearColor];
        _editRBItemPickWindow.windowLevel =UIWindowLevelNormal;
        _editRBItemPickWindow.alpha =1.f;
        _editRBItemPickWindow.hidden =NO;
        [_editRBItemPickWindow.layer addSublayer:hudLayer];
        
        
        UITapGestureRecognizer *tapGestureR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
        tapGestureR.cancelsTouchesInView = NO;
        [[_editRBItemPickWindow superview] addGestureRecognizer:tapGestureR];
        
    }
    
    if (_editRBItemPickView == nil){
        self.editRBItemPickView = [ITTXibViewUtils loadViewFromXibNamed:@"SMRptRBItemPickView"];
        self.editRBItemPickView.tag = kCellEdit;
        [_editRBItemPickWindow addSubview:_editRBItemPickView];
    }
    
    [_editRBItemPickWindow bringSubviewToFront:[_editRBItemPickWindow viewWithTag:kCellEdit]];
    
    [_editRBItemPickView setHidden:NO];
    [_editRBItemPickView setData:model];
    [_editRBItemPickWindow makeKeyAndVisible];
    [_editRBItemPickView showReportRBItemPickViewWithFinishBlock:^(SMRptRBItemModel *model, int optype, NSString *opinion) {
        AppDelegate *appDelegate = [AppDelegate GetAppDelegate];
        [[appDelegate window] makeKeyAndVisible];
        [self.editRBItemPickView setHidden:YES];
        
        if (optype != -1)
        {
            if (self.selectRow == -1){
                [_preferentialArray insertObject:model atIndex:0];
            }
            else{
                [_preferentialArray setObject:model atIndexedSubscript:self.selectRow];
            }
            [_tableView reloadData];
        }
    }];

}

-(void)removeData
{
    if (IS_STRING_EMPTY(_model.id)){
        [PROMPT_VIEW showMessage:@"日报不存在"];
        return;
    }
    
    [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken) {
        NSString *userid = [[UserManager sharedUserManager] userId];
        NSDictionary *params = @{
                                 @"userid":userid,
                                 @"token":[[UserManager sharedUserManager] ssoTokenWithUserId:userid],
                                 @"id":_model.id,
                                 };
        ITTDINFO(@"request params :[%@]" ,params);
        
        
        [SMRptRBRemoveRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
            NSLog(@"start loading");
            if(!_notShowLoading){
                [PROMPT_VIEW showActivityWithMask:@"正在删除..."];
            }
        } onRequestFinished:^(ITTBaseDataRequest *request) {
            if (request.isSuccess) {
                [PROMPT_VIEW showMessage:@"删除成功"];
                [[UserManager sharedUserManager] setReportNeedtoRefresh:YES];
                [self baseTopViewBackButtonClicked];
            }
        } onRequestCanceled:^(ITTBaseDataRequest *request) {
        } onRequestFailed:^(ITTBaseDataRequest *request) {
            [PROMPT_VIEW showMessage:@"数据保存未成功"];
        }];
    }];
    
}

-(void)saveData:(int)status
{
    _model.tommemo = _tommemoTextView.text;
    _model.summarize = _summarizeTextView.text;
    
    [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken) {
        
        NSMutableArray *projectParams = [[NSMutableArray alloc] init];
        for (int i=0; i<[_preferentialArray count]-1; i++) {
            SMRptRBItemModel *item = [_preferentialArray objectAtIndex:i];
            SMRptProjectModel *prjmodel;
            if (item.projectObj == nil){
                prjmodel = [[SMRptProjectModel alloc] initWithDataDic:[item project]];
            }
            else{
                prjmodel = item.projectObj;
            }
            NSDictionary *itemdir = @{
                                      @"id": item.id,
                                      @"workcontent": item.workcontent,
                                      @"issue": item.issue,
                                      @"level": item.level,
                                      @"percentage": item.percentage,
                                      @"status": item.status,
                                      @"projectId": prjmodel.id,
                                      @"projectName": item.projectName,
                                      @"workhour": item.workhour,
                                      };
            [projectParams addObject: itemdir];
        }
        
        NSString *userid = [[UserManager sharedUserManager] userId];
        NSDictionary *params = @{
                                 @"userid":userid,
                                 @"token":[[UserManager sharedUserManager] ssoTokenWithUserId:userid],
                                 @"id":_model.id,
                                 @"date": _model.date,
                                 @"tommemo": _model.tommemo,
                                 @"summarize": _model.summarize,
                                 @"submitstatus" : [NSString stringWithFormat:@"%d", status],
                                 @"dailyplans":[UIUtil DataTOjsonString:projectParams],
                                 };
        ITTDINFO(@"request params :[%@]" ,params);
        
        
        [SMRptRBEditRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
            NSLog(@"start loading");
            if(!_notShowLoading){
                [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
            }
        } onRequestFinished:^(ITTBaseDataRequest *request) {
            _isLoading = NO;
            [self refreshDataDone];
            [self loadMoreDataDone];
            if (request.isSuccess) {
                [PROMPT_VIEW showMessage:@"数据保存成功"];
                [[UserManager sharedUserManager] setReportNeedtoRefresh:YES];
                [self baseTopViewBackButtonClicked];
            }
        } onRequestCanceled:^(ITTBaseDataRequest *request) {
        } onRequestFailed:^(ITTBaseDataRequest *request) {
            [PROMPT_VIEW showMessage:@"数据保存未成功"];
        }];
    }];
}


/*
 
     data request ...
 
 */
-(void)startDataRequest
{
    [self startRBDataRequest];
}

-(void)startRBDataRequest
{
    _isLoading = NO;
    [self refreshDataDone];
    [self loadMoreDataDone];
  
    [_tableView reloadData];
}


/*============ ============ ============ ============ ============
 
 TableView
 
 ============ ============ ============ ============ ============ */

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath{
 
	[self.tableView reloadData];
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //[self removeRow];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = [_preferentialArray count];
    if(count <= 1){
        _nodataLabel.hidden = NO;
    }
    else{
        _nodataLabel.hidden = YES;
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [_preferentialArray count] - 1 )
    {
        return 44;
    }
    return 83;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectRow = indexPath.row;
    SMRptRBItemModel *item = [_preferentialArray objectAtIndex:indexPath.row];
    [self editRBItem:item];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [_preferentialArray count] - 1){
        static NSString *cellIden = @"SMOnButtonCell";
        SMOnButtonCell *cell = (SMOnButtonCell*)[tableView dequeueReusableCellWithIdentifier:cellIden];
        if (cell == nil){
            cell = [SMOnButtonCell cellFromNib];
        }
        cell.index = indexPath.row;
        [cell setData:kCellAddNew from:self];
        return cell;
    }
    else{
        static NSString *cellIdentifier = @"SMRptRBItemCell";
        SMRptRBItemCell *cell = (SMRptRBItemCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil){
            cell = [SMRptRBItemCell cellFromNib];
        }
        SMRptRBItemModel *item = [_preferentialArray objectAtIndex:indexPath.row];
        [cell setData:item];
        
        return cell;
    }
}

//TableView Cell one button Delegate
- (void)SMOnButtonCellDelegateTapped:(SMOnButtonCellOperType *)operType forObject:(int)tag
{
    [self.tommemoTextView endEditing:YES];
    [self.summarizeTextView endEditing:YES];
    
    _pickerUIView.tag = 0;
    [UIView animateWithDuration:0.2 animations:^{
        _pickerUIView.top = self.view.bottom;
    }];
    
    
    self.selectRow = -1;
    [self editRBItem:nil];
    
}




/*=========
 */



/*  ===================================================================
 
 TextView Delegate .....
 
 */

- (void)textViewDidChange:(UITextView *)textView
{
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.view.frame =CGRectMake(0, 0, weakSelf.view.frame.size.width, weakSelf.view.frame.size.height);
    }];
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [UIView animateWithDuration:0.2 animations:^{
        [_summarizeTextView endEditing:YES];
        [_tommemoTextView endEditing:YES];
        
        [_summarizeTextView resignFirstResponder];
        [_tommemoTextView resignFirstResponder];
    } completion:^(BOOL finished) {
        self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        self.selftop = self.view.top;
        CGRect frame = textView.frame;
        CGFloat top = self.view.height - (self.bottomView.top + frame.origin.y + frame.size.height) - 216.0;
        
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.view.top = top;
        }];
        
        
    }];
    
    return YES;
    
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSCharacterSet *doneButtonCharacterSet = [NSCharacterSet newlineCharacterSet];
    NSRange replacementTextRange = [text rangeOfCharacterFromSet:doneButtonCharacterSet];
    NSUInteger location = replacementTextRange.location;
    if (textView.text.length + text.length > 140){
        if (location != NSNotFound){
            [textView resignFirstResponder];
        }
        return NO;
    }
    else if (location != NSNotFound){
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan:withEvent:");
    [self clearPickViews];
    [super touchesBegan:touches withEvent:event];
}

-(void)clearPickViews
{
    [_tommemoTextView endEditing:YES];
    [_summarizeTextView endEditing:YES];
    _pickerUIView.tag = 0;
    [UIView animateWithDuration:0.2 animations:^{
        _pickerUIView.top = self.view.height;
    }];
}

/*=====================================================================================
 PullTable View
 =====================================================================================*/
- (void)pullTableViewDidTriggerRefresh:(ITTPullTableView *)pullTableView
{
    _currentPage = 0;
    _notShowLoading = YES;
    [self startDataRequest];
}

- (void)pullTableViewDidTriggerLoadMore:(ITTPullTableView *)pullTableView
{
    _notShowLoading = YES;
    [self startDataRequest];
}

- (void)refreshDataDone
{
    //_tableView.pullTableIsRefreshing = NO;
    //[_tableView setRefreshViewHidden:NO];
}

- (void)loadMoreDataDone
{
    //_tableView.pullTableIsLoadingMore = NO;
    //[_tableView setLoadMoreViewHidden:NO];
}


@end
