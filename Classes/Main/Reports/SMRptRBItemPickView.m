//
//  SMRptRBItemPickView.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-9-4.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMRptRBItemPickView.h"
#import "SMRptProjectListRequest.h"
#import "SMRptProjectModel.h"
#import "SMValueTextModel.h"
#import "SMValueTextModel.h"


@interface SMRptRBItemPickView()

@property (nonatomic, copy) void(^finishPickBlock)(SMRptRBItemModel *model, int optype, NSString *opinion);

@property (weak, nonatomic) IBOutlet UITextView *workcontentTextView;
@property (weak, nonatomic) IBOutlet UITextView *issueTextView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIButton *percentageButton;
@property (weak, nonatomic) IBOutlet UIButton *projectButton;
@property (weak, nonatomic) IBOutlet UIButton *workhourButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *statusSelect;
@property (weak, nonatomic) IBOutlet UIButton *levelButton;


@property int pickViewType;
@property int currentPickViewTag;
@property bool bNeedShow;
@property (strong, nonatomic) NSMutableArray *pickerData;
@property (strong, nonatomic) NSMutableArray *projectData;

@property (strong, nonatomic) NSMutableArray *workHourData;
@property (strong, nonatomic) NSMutableArray *workMinteData;

@property (strong, nonatomic) NSMutableArray *levelData;

@property (strong, nonatomic) SMRptRBItemModel *model;

@property float selftop;

@end

@implementation SMRptRBItemPickView

- (IBAction)pickerButtonDidClick:(id)sender {
    
    self.bNeedShow = true;
    if (self.pickerView.tag == 1){
        if ([sender tag] == self.currentPickViewTag){
            [UIView animateWithDuration:0.2 animations:^{
                self.pickerView.bottom = 0;
                [self.pickerView setAlpha:0.f];
                self.bNeedShow = false;
                self.pickerView.tag = 0;
            }];
        }
    }
    
    if (self.bNeedShow){
        self.pickerView.tag = 1;
        self.pickViewType = [sender tag];
        [self.pickerView setAlpha:1.f];
        [self showPickerView];
    }
    
    self.currentPickViewTag =[sender tag];
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (IBAction)closeBtnClick:(id)sender {
    
    if (self.pickerView.tag == 1){
        [UIView animateWithDuration:0.2 animations:^{
            self.pickerView.bottom = 0;
            [self.pickerView setAlpha:0.f];
            self.pickerView.tag = 0;
        }];
    }
    [self.workcontentTextView endEditing:YES];
    [self.issueTextView endEditing:YES];
    
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.top = weakSelf.bottom;
    } completion:^(BOOL finished) {
        if (_finishPickBlock) {
            _finishPickBlock(_model, -1, nil);
        }
    }];

}

- (IBAction)BtnClicked:(id)sender {
    
    if (self.pickerView.tag == 1){
        [UIView animateWithDuration:0.2 animations:^{
            self.pickerView.bottom = 0;
            [self.pickerView setAlpha:0.f];
            self.pickerView.tag = 0;
        }];
    }
    [self.workcontentTextView endEditing:YES];
    [self.issueTextView endEditing:YES];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.top = weakSelf.bottom;
    } completion:^(BOOL finished) {
        if (_finishPickBlock) {
            [self collectdata];
            _finishPickBlock(_model, 1, nil);
        }
    }];
}

-(void)collectdata{
    _model.workcontent = [self.workcontentTextView text];
    _model.level = [[[self levelButton] titleLabel] text];
    _model.status = [self.statusSelect titleForSegmentAtIndex:self.statusSelect.selectedSegmentIndex];
    _model.percentage = self.percentageButton.titleLabel.text;
    _model.percentage = [_model.percentage componentsSeparatedByString:@"%"][0];
    _model.issue = [self.issueTextView text];
    _model.workhour = self.workhourButton.titleLabel.text;
}



- (void)showReportRBItemPickViewWithFinishBlock:(void(^)(SMRptRBItemModel *model, int optype, NSString *opinion))finishBlock
{
    
    self.workcontentTextView.delegate = nil;
    self.issueTextView.delegate=nil;
    self.workcontentTextView.delegate = self;
    self.issueTextView.delegate = self;
    
    self.pickerView.delegate = self;
    self.pickViewType = -1;
    
    self.finishPickBlock = finishBlock;
    self.top = self.superview.bottom;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.bottom = weakSelf.top;
    }];
}
-(void)setData:(SMRptRBItemModel*) model
{
    
    if (self.pickerData == nil){
        self.pickerData = [[NSMutableArray alloc] init];
    }
    if (self.projectData == nil){
        self.projectData = [[NSMutableArray alloc] init];
    }
    [self loadProjectList];
    
    
    if (model == nil){
        self.model = [[SMRptRBItemModel alloc] init];
        _model.id = @"";
    }
    else{
        self.model = model;
        if (self.model.projectObj == nil){
            SMRptProjectModel *prjmodel = [[SMRptProjectModel alloc] initWithDataDic:[self.model project]];
            self.model.projectObj = prjmodel;
        }
        
    }
    
    if (IS_STRING_EMPTY(self.model.projectObj.id))
    {
        [self.projectButton setTitle:@"请选择项目" forState:UIControlStateNormal];
    }
    else{
        [self.projectButton setTitle:self.model.projectName forState:UIControlStateNormal];
    }
    
    
    [_workcontentTextView setText:_model.workcontent];
    //_statusSelect
    if (IS_STRING_NOT_EMPTY(_model.level)){
        [_levelButton setTitle:_model.level forState:UIControlStateNormal];
    }
    if (IS_STRING_NOT_EMPTY(_model.percentage)){
        [_percentageButton setTitle: [_model.percentage stringByAppendingString:@"%"] forState:UIControlStateNormal];
    }
    if (IS_STRING_NOT_EMPTY(_model.projectName)){
        [_projectButton setTitle:_model.projectName forState:UIControlStateNormal];
    }
    if (IS_STRING_NOT_EMPTY(_model.workhour)){
        [_workhourButton setTitle:_model.workhour forState:UIControlStateNormal];
    }
    [_issueTextView setText:_model.issue];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan:withEvent:");
    [self.workcontentTextView endEditing:YES];
    [self.issueTextView endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}


/*  ===================================================================
 
    TextView Delegate .....
 
 */

- (void)textViewDidChange:(UITextView *)textView
{
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.frame =CGRectMake(0, weakSelf.selftop, weakSelf.frame.size.width, weakSelf.frame.size.height);
    } completion:^(BOOL finished) {
        [textView resignFirstResponder];
    }];
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    if (self.pickerView.tag == 1){
        [UIView animateWithDuration:0.2 animations:^{
            self.pickerView.bottom = 0;
            [self.pickerView setAlpha:0.f];
            self.pickerView.tag = 0;
        }];
    } 
    
    self.selftop = self.top;
    CGRect frame = textView.frame;
    int offset = self.top + self.height - frame.origin.y - frame.size.height - 216.0 - 38;//键盘高度216
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.frame = CGRectMake(0.0f, offset, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    
    
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


/*== ====== == = = = == = == = = = =
 
 PickerView Delegate ......
 
 */

-(void)loadProjectList
{
    if ([self.projectData count] == 0){
        [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken) {
            
            NSString *userid = [[UserManager sharedUserManager] userId];
            NSDictionary *params = @{
                                     @"userid":userid,
                                     @"token":[[UserManager sharedUserManager] ssoTokenWithUserId:userid],
                                     @"code":@""
                                     };
            ITTDINFO(@"request params :[%@]" ,params);
            
            
            [SMRptProjectListRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
                NSLog(@"start loading");
                [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
            } onRequestFinished:^(ITTBaseDataRequest *request) {
                if (request.isSuccess) {
                    NSArray *itemlist = [request.handleredResult objectForKey:@"data"];
                    if(itemlist && [itemlist isKindOfClass:[NSArray class]]){
                        //refresh
                        [self.projectData removeAllObjects];
                        
                        for (int i=0; i<[itemlist count]; i++) {
                            SMValueTextModel *item = [[SMValueTextModel alloc] initWithDataDic: [itemlist objectAtIndex:i]];
                            [self.projectData addObject:item];
                        }
                    }
                }
                else{
                    
                    
                    
                }
            } onRequestCanceled:^(ITTBaseDataRequest *request) {
            } onRequestFailed:^(ITTBaseDataRequest *request) {
                
                
            }];
        }];
    }
}

-(void)showPickerView
{
    //[self.pickerData removeAllObjects];
    
    if (self.pickViewType == 0){
        if (self.pickerData == nil){
            self.pickerData = [[NSMutableArray alloc] init];
        }
        for (int i=1; i<=100; i++) {
            [self.pickerData addObject: [NSString stringWithFormat:@"%d%@", i, @"%"]];
        }
    }
    else if (self.pickViewType == 1){
        [self loadProjectList];
    }
    else if (self.pickViewType == 2){
        if (self.workHourData == nil){
            self.workHourData = [[NSMutableArray alloc] init];
        }
        for (int i=1; i<=24; i++) {
            [self.workHourData addObject: [NSString stringWithFormat:@"%d.", i]];
        }
        if (self.workMinteData == nil){
            self.workMinteData = [[NSMutableArray alloc] init];
        }
        for (int i=0; i<=59; i++) {
            [self.workMinteData addObject: [NSString stringWithFormat:@"%d", i]];
        }
    }
    else if (self.pickViewType == 3){
        if (self.levelData == nil){
            self.levelData = [[NSMutableArray alloc] init];
        }
        
        [self.levelData addObject:@"很重要很紧急"];
        [self.levelData addObject:@"很重要不紧急"];
        [self.levelData addObject:@"不重要很紧急"];
        [self.levelData addObject:@"不重要不紧急"];
    }
    
    
    
    
    [self.pickerView reloadAllComponents];
    //[self.pickerView setBackgroundColor: [UIColor colorWithRed:248.f/255.f green:248.f/2146.f blue:1.f/248.f alpha:1.f]];
    
    
    //default .....
    if (self.pickViewType == 0){
        NSString *txt = [[self.percentageButton titleLabel] text];
        NSInteger idx = [[txt substringToIndex: [txt length] - 1] intValue] - 1;
        [self.pickerView selectRow: idx inComponent:0 animated:YES];
    }
    else if (self.pickViewType == 1){
        //TODO set project select for default...
        
    }
    
    
    self.pickerView.bottom = 0;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.pickerView.top = 0;
    }];
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (self.pickViewType <= 1){
        return 1;
    }
    else if (self.pickViewType == 2){
        return 2;
    }
    else{
        return 1;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (self.pickViewType == 0){
        return [[self pickerData] count];
    }
    else if (self.pickViewType == 1){
        return [[self projectData] count];
    }
    else if (self.pickViewType == 2){
        if (component == 0){
            return [[self workHourData] count];
        }
        else if (component == 1){
            return [[self workMinteData] count];
        }
        else{
            return 0;
        }
    }
    else if (self.pickViewType == 3){
        return self.levelData.count;
    }
    else {
        return [[self pickerData] count];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (self.pickViewType == 0){
        return [[self pickerData] objectAtIndex:row];
    }
    else if (self.pickViewType == 1){
        SMValueTextModel *model =[[self projectData] objectAtIndex:row];
        return model.text;
    }
    else if (self.pickViewType == 2){
        if (component == 0){
            return [[self workHourData] objectAtIndex:row];
        }
        else if (component == 1){
            return [[self workMinteData] objectAtIndex:row];
        }
        else {
            return @"<未设置>";
        }
    }
    else if (self.pickViewType == 3){
        return [[self levelData] objectAtIndex:row];
    }
    else {
        return @"<未设置>";
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.pickViewType == 0){
        [self.percentageButton setTitle:[[self pickerData] objectAtIndex:row] forState:UIControlStateNormal];
        _model.percentage = self.percentageButton.titleLabel.text;
    }
    else if (self.pickViewType == 1){
        SMValueTextModel *model = [[self projectData] objectAtIndex:row];
        [self.projectButton setTitle:model.text forState:UIControlStateNormal];
        if (_model.projectObj == nil){
            _model.projectObj = [[SMRptProjectModel alloc] init];
        }
        _model.projectObj.id = model.value;
        _model.projectName = model.text;
    }
    else if (self.pickViewType == 2){
        NSString *txt = @"";
        if (component == 0){
            txt = [[txt stringByAppendingString: [[self workHourData] objectAtIndex:row]] stringByAppendingString:[[self workMinteData] objectAtIndex:[pickerView selectedRowInComponent:1]]];
        }
        else if (component == 1){
            txt = [[txt stringByAppendingString: [[self workHourData] objectAtIndex:[pickerView selectedRowInComponent:0]]] stringByAppendingString:[[self workMinteData] objectAtIndex:row]];
        }
        [self.workhourButton setTitle:txt forState:UIControlStateNormal];
        _model.workhour = txt;
    }
    else if (self.pickViewType == 3){
        [self.levelButton setTitle:[[self levelData] objectAtIndex:row] forState:UIControlStateNormal];
        _model.level = self.levelButton.titleLabel.text;
    }
}


@end
