//
//  SMReportZBEditViewController.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-9-9.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMReportZBEditViewController.h"
#import "SMRptZBWeekItemModel.h"
#import "SMRptZBNextweekItemModel.h"
#import "SMRptZBWeekItemCell.h"
#import "SMRptZBNextWeekItemCell.h"
#import "SMRptZBNextweekItemModel.h"
#import "SMRptZBWeekItemPickView.h"
#import "SMRptZBNextWeekItemPickView.h"
#import "AppDelegate.h"
#import "SMRptZBEditRequest.h"
#import "SMRptZBRemoveRequest.h"

@interface SMReportZBEditViewController ()

@property (weak, nonatomic) IBOutlet UITableView *weekTableView;
@property (weak, nonatomic) IBOutlet UILabel *noWeekDataLabel;
@property (weak, nonatomic) IBOutlet UITableView *nextWeekTableView;
@property (weak, nonatomic) IBOutlet UILabel *noNextWeekDataLabel;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (weak, nonatomic) IBOutlet UIButton *dateButton;

@property (weak, nonatomic) IBOutlet UIButton *pauseButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *removeButton;


@property (weak, nonatomic) IBOutlet UIView *pickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;

@property (strong, nonatomic) NSMutableArray *preferentialWeekArray;
@property (strong, nonatomic) NSMutableArray *preferentialNextWeekArray;
@property (assign, nonatomic) int currentPage;
@property (assign, nonatomic) BOOL isLoading;
@property (assign, nonatomic) BOOL notShowLoading;

@property (nonatomic, strong) SMRptZBModel *model;

@property int selectRow;
@property int selectTable;
@property (nonatomic, strong) UIWindow *editZBWeekItemPickWindow;
@property (nonatomic, strong) SMRptZBWeekItemPickView *editZBWeekItemPickView;
@property (nonatomic, strong) UIWindow *editZBNextWeekItemPickWindow;
@property (nonatomic, strong) SMRptZBNextWeekItemPickView *editZBNextWeekItemPickView;

@property (strong, nonatomic) NSMutableArray *yearArray;
@property (strong, nonatomic) NSMutableArray *monthArray;
@property (strong, nonatomic) NSMutableArray *weekArray;

@end

@implementation SMReportZBEditViewController

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
    
    _weekTableView.tag = 0;
    _nextWeekTableView.tag = 1;
    
    _currentPage = 0;
    _notShowLoading = NO;
    _preferentialWeekArray = [NSMutableArray array];
    _preferentialNextWeekArray = [NSMutableArray array];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self initUserData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*--------------------------------------------------------------------------
 IBAction
 --------------------------------------------------------------------------*/
- (IBAction)backBtnClick:(id)sender {
    [self baseTopViewBackButtonClicked];
}

- (IBAction)dateButtonDidClicked:(id)sender {
    
    if ([sender tag] == 0){
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.2 animations:^{
            _pickerView.top = weakSelf.view.height - _pickerView.height;
            
            [_picker reloadAllComponents];
            [_picker selectRow:1 inComponent:0 animated:YES];
            [_picker selectRow: [_model.month intValue]-1  inComponent:1 animated:YES];
            [_picker selectRow:[_model.week intValue] - 1 inComponent:2 animated:YES];
            
        }];
        
        [sender setTag:1];
    }
    else if ([sender tag] == 1){
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.2 animations:^{
            _pickerView.top = weakSelf.view.height;
        }];
        
        [sender setTag:0];
    }
    
}


- (IBAction)submitButtonDidClicked:(id)sender {
    
    if ([sender tag] >= 0){
        [self saveUpdate:[sender tag]];
    }
    else if([sender tag] == -1){
        [self remove];
    }
    
    
}


/*--------------------------------------------------------------------------
    private void
--------------------------------------------------------------------------*/


-(void)initUserData
{
    _pickerView.top = self.view.bottom;
    _pickerView.height = _picker.height;
    _picker.top = 0;
    
    //form data ....
    [_dateButton setTitle:[NSString stringWithFormat:@"%@年%@月%@周", _model.year, _model.month, _model.week] forState:UIControlStateNormal];
    //[_dateButton setTitle:_model.date forState:UIControlStateNormal];

    [self initUserDataWeek];
    [self initUserDataNextweek];
    
}
-(void)initUserDataWeek
{
    //weeklys .....
    [_preferentialWeekArray removeAllObjects];
    NSArray *itemlist = _model.weeklys;
    if(itemlist && [itemlist isKindOfClass:[NSArray class]])
    {
        for (int i=0; i<[itemlist count]; i++) {
            SMRptZBWeekItemModel *item = [[SMRptZBWeekItemModel alloc]initWithDataDic: [itemlist objectAtIndex:i]];
            [_preferentialWeekArray addObject:item];
        }
    }
    
    [_preferentialWeekArray addObject:[[SMRptZBWeekItemModel alloc] init]];
    
    [_weekTableView reloadData];
}

-(void)initUserDataNextweek
{
    [_preferentialNextWeekArray removeAllObjects];
    NSArray *itemlist = _model.nextWeeklys;
    if(itemlist && [itemlist isKindOfClass:[NSArray class]])
    {
        for (int i=0; i<[itemlist count]; i++) {
            SMRptZBNextweekItemModel *item = [[SMRptZBNextweekItemModel alloc]initWithDataDic: [itemlist objectAtIndex:i]];
            [_preferentialNextWeekArray addObject:item];
        }
    }
    
    [_preferentialNextWeekArray addObject:[[SMRptZBNextweekItemModel alloc] init]];
    
    [_nextWeekTableView reloadData];
}


-(void)editZBWeekItem:(SMRptZBWeekItemModel*)model
{
    if (_editZBWeekItemPickWindow == nil) {
        self.editZBWeekItemPickWindow = [[UIWindow alloc] initWithFrame:(CGRect) {{0.f,0.f}, [[UIScreen mainScreen] bounds].size}];
        CALayer *hudLayer = [CALayer layer];
        hudLayer.frame = CGRectMake(0, 0, _editZBWeekItemPickWindow.width, _editZBWeekItemPickWindow.height);
        hudLayer.backgroundColor = [UIColor blackColor].CGColor;
        hudLayer.opacity = 0.6;
        
        _editZBWeekItemPickWindow.backgroundColor = [UIColor clearColor];
        _editZBWeekItemPickWindow.windowLevel =UIWindowLevelNormal;
        _editZBWeekItemPickWindow.alpha =1.f;
        _editZBWeekItemPickWindow.hidden =NO;
        [_editZBWeekItemPickWindow.layer addSublayer:hudLayer];
        
        
        UITapGestureRecognizer *tapGestureR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
        tapGestureR.cancelsTouchesInView = NO;
        [[_editZBWeekItemPickWindow superview] addGestureRecognizer:tapGestureR];
        
    }
    
    if (_editZBWeekItemPickView == nil){
        self.editZBWeekItemPickView = [ITTXibViewUtils loadViewFromXibNamed:@"SMRptZBWeekItemPickView"];
        self.editZBWeekItemPickView.tag = kCellEdit;
        [_editZBWeekItemPickWindow addSubview:_editZBWeekItemPickView];
    }
    
    [_editZBWeekItemPickWindow bringSubviewToFront:[_editZBWeekItemPickWindow viewWithTag:kCellEdit]];
    
    [_editZBWeekItemPickView setHidden:NO];
    [_editZBWeekItemPickView setData:model];
    [_editZBWeekItemPickWindow makeKeyAndVisible];
    [_editZBWeekItemPickView showReportZBWeekItemPickViewWithFinishBlock:^(SMRptZBWeekItemModel *model, int optype, NSString *opinion) {
        AppDelegate *appDelegate = [AppDelegate GetAppDelegate];
        [[appDelegate window] makeKeyAndVisible];
        [self.editZBWeekItemPickView setHidden:YES];
        
        if (optype != -1)
        {
            if (self.selectRow == -1){
                [_preferentialWeekArray insertObject:model atIndex:0];
            }
            else{
                [_preferentialWeekArray setObject:model atIndexedSubscript:self.selectRow];
            }
            [_weekTableView reloadData];
        }
    }];
}

-(void)editZBNextWeekItem:(SMRptZBNextweekItemModel*)model
{
    if (_editZBNextWeekItemPickWindow == nil) {
        self.editZBNextWeekItemPickWindow = [[UIWindow alloc] initWithFrame:(CGRect) {{0.f,0.f}, [[UIScreen mainScreen] bounds].size}];
        CALayer *hudLayer = [CALayer layer];
        hudLayer.frame = CGRectMake(0, 0, _editZBNextWeekItemPickWindow.width, _editZBNextWeekItemPickWindow.height);
        hudLayer.backgroundColor = [UIColor blackColor].CGColor;
        hudLayer.opacity = 0.6;
        
        _editZBNextWeekItemPickWindow.backgroundColor = [UIColor clearColor];
        _editZBNextWeekItemPickWindow.windowLevel =UIWindowLevelNormal;
        _editZBNextWeekItemPickWindow.alpha =1.f;
        _editZBNextWeekItemPickWindow.hidden =NO;
        [_editZBNextWeekItemPickWindow.layer addSublayer:hudLayer];
        
        
        UITapGestureRecognizer *tapGestureR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
        tapGestureR.cancelsTouchesInView = NO;
        [[_editZBNextWeekItemPickWindow superview] addGestureRecognizer:tapGestureR];
        
    }
    
    if (_editZBNextWeekItemPickView == nil){
        self.editZBNextWeekItemPickView = [ITTXibViewUtils loadViewFromXibNamed:@"SMRptZBNextWeekItemPickView"];
        self.editZBNextWeekItemPickView.tag = kCellEdit;
        [_editZBNextWeekItemPickWindow addSubview:_editZBNextWeekItemPickView];
    }
    
    [_editZBNextWeekItemPickWindow bringSubviewToFront:[_editZBNextWeekItemPickWindow viewWithTag:kCellEdit]];
    
    [_editZBNextWeekItemPickView setHidden:NO];
    [_editZBNextWeekItemPickView setData:model];
    [_editZBNextWeekItemPickWindow makeKeyAndVisible];
    [_editZBNextWeekItemPickView showReportZBNextWeekItemPickViewWithFinishBlock:^(SMRptZBNextweekItemModel *model, int optype, NSString *opinion) {
        AppDelegate *appDelegate = [AppDelegate GetAppDelegate];
        [[appDelegate window] makeKeyAndVisible];
        [self.editZBNextWeekItemPickView setHidden:YES];
        
        if (optype != -1)
        {
            if (self.selectRow == -1){
                [_preferentialNextWeekArray insertObject:model atIndex:0];
            }
            else{
                [_preferentialNextWeekArray setObject:model atIndexedSubscript:self.selectRow];
            }
            [_nextWeekTableView reloadData];
        }
    }];
}

-(void)saveUpdate:(int)tag
{
    NSMutableArray *weekParams = [[NSMutableArray alloc] init];
    for (int i=0; i<[_preferentialWeekArray count]-1; i++) {
        SMRptZBWeekItemModel *item = [_preferentialWeekArray objectAtIndex:i];
        NSDictionary *itemdir = @{
                                  @"id": item.id,
                                  @"workcontent": item.workcontent,
                                  @"measures": item.measures,
                                  @"timenode": item.timenode,
                                  @"solvemeasure": item.solvemeasure,
                                  @"punishment": item.punishment,
                                  @"status": item.status,
                                  @"issue": item.issue,
                                  };
        [weekParams addObject: itemdir];
    }
    
    NSMutableArray *nextWeekParams = [[NSMutableArray alloc] init];
    for (int i=0; i<[_preferentialNextWeekArray count]-1; i++) {
        SMRptZBNextweekItemModel *item = [_preferentialNextWeekArray objectAtIndex:i];
        NSDictionary *itemdir = @{
                                  @"id": item.id,
                                  @"workcontent": item.workcontent,
                                  @"measures": item.measures,
                                  @"timenode": item.timenode,
                                  @"remark": item.remark,
                                  @"punishment": item.punishment,
                                  @"level": item.level,
                                  @"person": item.person,
                                  };
        [nextWeekParams addObject: itemdir];
    }
    
    
    [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken) {
        NSString *userid = [[UserManager sharedUserManager] userId];
        NSDictionary *params = @{
                                 @"userid":userid,
                                 @"token":[[UserManager sharedUserManager] ssoTokenWithUserId:userid],
                                 @"id":_model.id,
                                 @"year":_model.year,
                                 @"month": _model.month,
                                 @"week": _model.week,
                                 @"submitstatus": [NSString stringWithFormat:@"%d", tag],
                                 @"weeklyplans":[UIUtil DataTOjsonString:weekParams],
                                 @"nextweeklyplans":[UIUtil DataTOjsonString:nextWeekParams],
                                 };
        ITTDINFO(@"request params :[%@]" ,params);
        
        
        [SMRptZBEditRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
            NSLog(@"start loading");
            if(!_notShowLoading){
                [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
            }
        } onRequestFinished:^(ITTBaseDataRequest *request) {
            if (request.isSuccess) {
                [PROMPT_VIEW showMessage:@"数据保存成功"];
                [[UserManager sharedUserManager] setReportNeedtoRefresh:YES];
                [self baseTopViewBackButtonClicked];
            }
            else{
                [PROMPT_VIEW showMessage:@"编辑周报信息未成功"];
            }
        } onRequestCanceled:^(ITTBaseDataRequest *request) {
        } onRequestFailed:^(ITTBaseDataRequest *request) {
            
        }];
    }];
}
-(void)remove
{
    if (IS_STRING_EMPTY(_model.id)){
        [PROMPT_VIEW showMessage:@"要删除的周报未找到"];
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
        
        
        [SMRptZBRemoveRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
            NSLog(@"start loading");
            if(!_notShowLoading){
                [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
            }
        } onRequestFinished:^(ITTBaseDataRequest *request) {
            if (request.isSuccess) {
                [PROMPT_VIEW showMessage:@"数据保存成功"];
                [[UserManager sharedUserManager] setReportNeedtoRefresh:YES];
                [self baseTopViewBackButtonClicked];
            }
            else{
                [PROMPT_VIEW showMessage:@"编辑周报信息未成功"];
            }
        } onRequestCanceled:^(ITTBaseDataRequest *request) {
        } onRequestFailed:^(ITTBaseDataRequest *request) {
            
        }];
    }];
    
    
    
}

/*--------------------------------------------------------------------------
    SMReportZBEditViewController 接口
-------------------------------------------------------------------------- */

-(void)setReportData:(SMRptZBModel*)model
{
    if (model == nil){
        _model = [[SMRptZBModel alloc] init];
        _model.id= @"";
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
        NSDateComponents *components = [calendar components:unitFlags fromDate:[NSDate date]];
        _model.year = [ NSString stringWithFormat:@"%d", [components year]];
        _model.month = [ NSString stringWithFormat:@"%d", [components month]];
        _model.week = [ NSString stringWithFormat:@"%d", [components day] / 7];
    }
    else{
        _model = model;
    }
    
    if (_yearArray == nil){
        _yearArray = [[NSMutableArray alloc] init];
        int curYear = [[[NSDate date] stringWithFormat:@"yyyy"] intValue];
        [_yearArray addObject:[NSString stringWithFormat:@"%d", curYear - 1]];
        [_yearArray addObject:[NSString stringWithFormat:@"%d", curYear]];
        [_yearArray addObject:[NSString stringWithFormat:@"%d", curYear + 1]];
    }
    
    if (_monthArray == nil){
        _monthArray = [[NSMutableArray alloc] init];
        for (int i=1; i<=12; i++) {
            [_monthArray addObject: [NSString stringWithFormat:@"%d", i]];
        }
    }
    
    if (_weekArray == nil){
        _weekArray = [[NSMutableArray alloc] init];
        for (int i=1; i<=4; i++) {
            [_weekArray addObject: [NSString stringWithFormat:@"%d", i]];
        }
    }
    
}

-(void)SMOnButtonCellDelegateTapped:(SMOnButtonCellOperType *)operType forObject:(int)tag
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        _pickerView.top = weakSelf.view.bottom;
    }];
    
    self.selectTable = tag;
    self.selectRow = -1;
    if (tag == 0){
        [self editZBWeekItem:nil];
    }
    else if (tag == 1){
        [self editZBNextWeekItem:nil];
    }
    
}

//end of SMReportZBEditViewController 接口
//--------------------------------------------------------------------------






/*--------------------------------------------------------------------------
    TableView
--------------------------------------------------------------------------*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 0){
        int count = [_preferentialWeekArray count];
        if(count <= 1){
            _noWeekDataLabel.hidden = NO;
        }
        else{
            _noWeekDataLabel.hidden = YES;
        }
        return count;
    }
    else if (tableView.tag == 1){
        int count = [_preferentialNextWeekArray count];
        if(count <= 1){
            _noNextWeekDataLabel.hidden = NO;
        }
        else{
            _noNextWeekDataLabel.hidden = YES;
        }
        return count;
    }
    else
    {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 0){
        if (indexPath.row == [_preferentialWeekArray count] - 1 )
        {
            return 44;
        }
        return 74;
    }
    else if (tableView.tag == 1){
        if (indexPath.row == [_preferentialNextWeekArray count] - 1 )
        {
            return 44;
        }
        return 60;
    }
    else{
        return  0;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        _pickerView.top = weakSelf.view.height;
    }];
    [_dateButton setTag:0];
    
    
    _selectTable = tableView.tag;
    self.selectRow = indexPath.row;
    if (_selectTable == 0){
        SMRptZBWeekItemModel *item = [_preferentialWeekArray objectAtIndex:indexPath.row];
        [self editZBWeekItem:item];
    }
    else if (_selectTable == 1){
        SMRptZBNextweekItemModel *item = [_preferentialNextWeekArray objectAtIndex:indexPath.row];
        [self editZBNextWeekItem:item];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 0){
        if (indexPath.row == [_preferentialWeekArray count] - 1){
            static NSString *cellIden = @"SMOnButtonCell";
            SMOnButtonCell *cell = (SMOnButtonCell*)[tableView dequeueReusableCellWithIdentifier:cellIden];
            if (cell == nil){
                cell = [SMOnButtonCell cellFromNib];
            }
            cell.index = tableView.tag;
            [cell setData:kCellAddNew from:self];
            return cell;
        }
        else{
            static NSString *cellIdentifier = @"SMRptZBWeekItemCell";
            SMRptZBWeekItemCell *cell = (SMRptZBWeekItemCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil){
                cell = [SMRptZBWeekItemCell cellFromNib];
            }
            SMRptZBWeekItemModel *item = [_preferentialWeekArray objectAtIndex:indexPath.row];
            [cell setData:item];
            
            return cell;
        }
    }
    else if (tableView.tag == 1){
        if (indexPath.row == [_preferentialNextWeekArray count] - 1){
            static NSString *cellIden = @"SMOnButtonCell";
            SMOnButtonCell *cell = (SMOnButtonCell*)[tableView dequeueReusableCellWithIdentifier:cellIden];
            if (cell == nil){
                cell = [SMOnButtonCell cellFromNib];
            }
            cell.index = tableView.tag;
            [cell setData:kCellAddNew from:self];
            return cell;
        }
        else{
            static NSString *cellIdentifier = @"SMRptZBNextWeekItemCell";
            SMRptZBNextWeekItemCell *cell = (SMRptZBNextWeekItemCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil){
                cell = [SMRptZBNextWeekItemCell cellFromNib];
            }
            SMRptZBNextweekItemModel *item = [_preferentialNextWeekArray objectAtIndex:indexPath.row];
            [cell setData:item];
            
            return cell;
        }

    }
    else{
        return nil;
    }
}


/* -----------------------------------------------------------------------------
 picker for level ....
 -----------------------------------------------------------------------------*/
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0){
        return [_yearArray count];
    }
    else if (component == 1){
        return [_monthArray count];
    }
    else if (component == 2){
        return [_weekArray count];
    }
    else {
        return 1;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0){
        return [NSString stringWithFormat:@"%@年", [_yearArray objectAtIndex:row]];
    }
    else if (component == 1){
        return [NSString stringWithFormat:@"%@月",[_monthArray objectAtIndex:row]];
    }
    else if (component == 2){
        return [NSString stringWithFormat:@"%@周", [_weekArray objectAtIndex:row]];
    }
    else{
        return @"";
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0){
        _model.year = [_yearArray objectAtIndex:row];
    }
    else if (component == 1){
        _model.month = [_monthArray objectAtIndex:row];
    }
    else if (component == 2){
        _model.week = [_weekArray objectAtIndex:row];
    }
    [_dateButton setTitle:[NSString stringWithFormat:@"%@年%@月%@周", _model.year, _model.month, _model.week] forState:UIControlStateNormal];
    
}

@end
