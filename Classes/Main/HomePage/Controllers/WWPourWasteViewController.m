//
//  WWPourWasteViewController.m
//  com.knowesoft.weifei
//
//  Created by Golun on 2015-03-16.
//  Copyright (c) 2015年 Knowesoft. All rights reserved.
//

#import "WWPourWasteViewController.h"
#import "WWWasteNamePickView.h"
#import "AppDelegate.h"
#import "WWasteAddRequest.h"
#import "WWMobileSettingViewController.h"
#import "ITTImageView.h"
#import "WWImagePostRequest.h"
#import "AlterTimeViewController.h"

@interface WWPourWasteViewController ()<ITTImageViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UIButton *lblGroupname;
@property (weak, nonatomic) IBOutlet UITextField *textFieldMMV;
@property (weak, nonatomic) IBOutlet UILabel *lblPackageBoxCode;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UIButton *homeButton;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (weak, nonatomic) IBOutlet UITextField *wasteNameTextField;//废物名字
@property (weak, nonatomic) IBOutlet UITextField *categaryTextfiled;//有害成分
@property (weak, nonatomic) IBOutlet UIButton *wasteNameButton;//废物名称选择
@property (weak, nonatomic) IBOutlet UITextField *wasteWeightTextField;//
@property (weak, nonatomic) IBOutlet UITextField *phTextField;//ph
@property (weak, nonatomic) IBOutlet UITextField *wasteFormTextField;//形态
@property (weak, nonatomic) IBOutlet UITextField *wasteDangeTextField;//毒性
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *remarkTextField;



@property (weak, nonatomic) IBOutlet UIButton *verfiyMobileButton;

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet ITTImageView *imageView;


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *section2View;
@property (weak, nonatomic) IBOutlet UIView *section1View;
@property (weak, nonatomic) IBOutlet UIView *sectionLastView;
@property (weak, nonatomic) IBOutlet UIView *sectionBtnView;
@property (weak, nonatomic) IBOutlet UIView *sectionPhotoView;
@property (weak, nonatomic) IBOutlet UIButton *wastFormButton;//点击选择形态
@property (weak, nonatomic) IBOutlet UIButton *wasteDangeButton;

@property (nonatomic, strong) UIWindow *wasteNamePickWindow;
@property (nonatomic, strong) WWWasteNamePickView *wasteNamePickView;

@property (nonatomic, strong) NSArray * formArray;//形态数组
@property (nonatomic, strong) NSArray * toxicityArray;//毒性数组

@property (nonatomic, copy) NSString * form;//形态
@property (nonatomic, copy) NSString * toxicity;//毒性

@end

@implementation WWPourWasteViewController
{
    int step;
    NSData *wasteImage;
    BOOL isPosted;
}

- (NSArray *)formArray {
    if (!_formArray) {
        _formArray = @[@"液态",@"液态(粘稠)",@"液态(含固)",@"固态",@"半固态(浆状)"];
    }
    return _formArray;
}
- (NSArray *)toxicityArray {
    if (!_toxicityArray) {
        _toxicityArray = @[@"腐蚀性(C)",@"毒性(T)",@"易燃性(I)",@"反应性(R)",@"感染性(In)"];
    }
    return _toxicityArray;
}

- (IBAction)backButtonDidClick:(id)sender {
    [self baseTopViewBackButtonClicked];
}

- (IBAction)onWasteNameDidClick:(id)sender {
    [self showWasteNamePickWindow];
}

- (IBAction)onWasteWeightDidClick:(id)sender {
}

- (IBAction)onWasteFormDidClick:(id)sender {
}

- (IBAction)onWasteDangerDidClick:(id)sender {
}

- (IBAction)onWastePHDidClick:(id)sender {
}
- (IBAction)onHomeDidClick:(id)sender {
    [self.navigationController popMasterToRootViewController];
}

//点击形态选择
- (IBAction)clikeWasteFormAction:(id)sender {
    [self clikeSelectNeedMessge:self.formArray selectType:0 alterTitle:@"废物形态"];
}

//点击选择毒性
- (IBAction)clikeWastDangeAction:(id)sender {
    [self clikeSelectNeedMessge:self.toxicityArray selectType:1 alterTitle:@"废物危险特性"];
}

//点击选择需要的数据 这种封装比较水
- (void)clikeSelectNeedMessge:(NSArray *)customArray selectType:(NSInteger)selectType alterTitle:(NSString *)alterTitle {
    
    AlterTimeViewController * alterController = [[AlterTimeViewController alloc] initSelectType:selectArrayMessge alterTitle:alterTitle dateMode:UIDatePickerModeDateAndTime];
    alterController.selectArray = customArray;
    //选择之后
    __weak typeof(alterController) weakAlter = alterController;
    alterController.selectAction = ^(UIButton *button, NSString *selectMessge) {
        //点击选择确认按钮
        if ([button isEqual:weakAlter.buttonAffire]) {
            switch (selectType) {
                case 0://形态
                    self.form = selectMessge;
                    [self.wastFormButton setTitle:selectMessge forState:UIControlStateNormal];
                    break;
                default://毒性
                    self.toxicity = selectMessge;
                    [self.wasteDangeButton setTitle:selectMessge forState:UIControlStateNormal];
                    break;
            }
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    [self presentViewController:alterController animated:YES completion:nil];
}

- (IBAction)verfiyMobileButtonDidClick:(id)sender {
    
    WWMobileSettingViewController *pourWasteViewController = [[WWMobileSettingViewController alloc] initWithNibName:@"WWMobileSettingViewController" bundle:nil];
    pourWasteViewController.mobile = _mobileTextField.text;
    [self.navigationController pushViewController:pourWasteViewController animated:YES];
}



- (void)showWasteNamePickWindow
{
    [self.view endEditing:YES];
    if (_wasteNamePickWindow == nil) {
        self.wasteNamePickWindow = [[UIWindow alloc] initWithFrame:(CGRect) {{0.f,0.f}, [[UIScreen mainScreen] bounds].size}];
        CALayer *hudLayer = [CALayer layer];
        hudLayer.frame = CGRectMake(0, 0, _wasteNamePickWindow.width, _wasteNamePickWindow.height);
        hudLayer.backgroundColor = [UIColor blackColor].CGColor;
        hudLayer.opacity = 0.6;
        
        _wasteNamePickWindow.backgroundColor = [UIColor clearColor];
        _wasteNamePickWindow.windowLevel =UIWindowLevelNormal;
        _wasteNamePickWindow.alpha =1.f;
        _wasteNamePickWindow.hidden =NO;
        [_wasteNamePickWindow.layer addSublayer:hudLayer];
        self.wasteNamePickView = [ITTXibViewUtils loadViewFromXibNamed:@"WWWasteNamePickView"];
        [_wasteNamePickWindow addSubview:_wasteNamePickView];
    }
    [_wasteNamePickWindow makeKeyAndVisible];
    [_wasteNamePickView showWasteNamePickViewWithFinishBlock:^(NSString *wastename) {
        AppDelegate *appDelegate = [AppDelegate GetAppDelegate];
        [[appDelegate window] makeKeyAndVisible];
        NSLog(@" 危废名字 %@",wastename);
        if (wastename.length != 0) {
            [self resetFormData];
        } 
    }];
}

-(void)resetFormData
{
    [_wasteNameTextField setText:[[UserManager sharedUserManager] getStringWithKey:WWasteTypeName]];
}


/*
 qrcode
 dep_code
 user_id
 waste_name
 waste_weight
 waste_form
 waste_danger_chars
 waste_ph
 remark
 contact_tel
 
 */
-(BOOL)validateUserData
{
    NSString *msg = @"";
    BOOL ret = true;
    if (wasteImage == nil){
        msg = @"请点击图片给待处理废物拍照";
        ret= false;
    }
    else if (_wasteNameTextField.text.length == 0){
        msg = @"废物类别为必选项";
        ret = false;
    }
    else if (_wasteWeightTextField.text.length == 0){
        msg = @"倒入废物的体积为必选项";
        ret = false;
    }
    else if (_form.length == 0){
        msg = @"形态为必选项";
        ret = false;
    }
    else if (_toxicity.length == 0){
        msg = @"毒性为必选项";
        ret = false;
    }
    else if (_phTextField.text.length == 0){
        msg = @"PH值为必选项";
        ret = false;
    }
    else if (_categaryTextfiled.text.length == 0){
        msg = @"请输入主要有用成分";
        ret = false;
    }
    
    if ([msg length] > 0){
        [PROMPT_VIEW showMessage:msg];
    }
    return ret;
}
-(void)postWasteData
{
    NSDictionary *params = @{@"qrcode":_symbolString
                             ,@"dep_code" : @""
                             ,@"user_id" : @""
                             ,@"waste_type" : [self judgeString:WWasteType]//[[UserManager sharedUserManager] getStringWithKey:WWasteType]
                             ,@"waste_name" : [self judgeString:WWasteTypeName]//[[UserManager sharedUserManager] getStringWithKey:WWasteTypeName]
                             ,@"waste_weight" : [self judgeString:WWasteWeight]//[[UserManager sharedUserManager] getStringWithKey:WWasteWeight]
                             ,@"waste_form" : [self judgeString:WWasteForm]//[[UserManager sharedUserManager] getStringWithKey:WWasteForm]
                             ,@"waste_danger_chars" : [self judgeString:WWasteDange]//[[UserManager sharedUserManager] getStringWithKey:WWasteDange]
                             ,@"waste_ph" : [self judgeString:WWastePH] //[[UserManager sharedUserManager] getStringWithKey:WWastePH]
                             ,@"remark" : [self judgeString:WWasteRemark]//[[UserManager sharedUserManager] getStringWithKey:WWasteRemark]
                             ,@"contact_tel" :[self judgeString:WWastePhone]//[[UserManager sharedUserManager] getStringWithKey:WWastePhone]
                             ,@"waste_image" : [self judgeString:WWasteImage]//[[UserManager sharedUserManager] getStringWithKey:WWasteImage]
                             ,@"component" : [self judgeString:WWasteCatagery]//[[UserManager sharedUserManager] getStringWithKey:WWasteImage]
                             
                             };
    
    ITTDINFO(@"request params :[%@]" ,params);
    
    __weak typeof(self) weakSelf = self;
    [WWasteAddRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
        [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
    } onRequestFinished:^(ITTBaseDataRequest *request) {
        if (request.isSuccess){
            [PROMPT_VIEW showMessage:@"废物产生成功！"];
            [ weakSelf.navigationController popMasterToRootViewController];
        }
    } onRequestCanceled:^(ITTBaseDataRequest *request) {
        
        NSLog(@"request ------- %@ ",request);
        
    } onRequestFailed:^(ITTBaseDataRequest *request) {
        
        NSLog(@"request ======  %@ ",request);
        
    }];
}

- (NSString *)judgeString:(NSString *)string {

    NSString * str = [NSString stringWithFormat:@"%@",[[UserManager sharedUserManager] getStringWithKey:string]];
    if ([str isEqual:[NSNull null]]) {
        return @"";
    }
    if (str.length == 0) {
        return @"";
    }
    return str;
}

- (IBAction)buttonSubmitDidClick:(id)sender {
    //[self baseTopViewBackButtonClicked];
    //点击下一步
    if (step == 0){
        if ([self validateUserData]){
            [[UserManager sharedUserManager] setString:_wasteWeightTextField.text withKey:WWasteWeight];
            [[UserManager sharedUserManager] setString:_wasteFormTextField.text withKey:WWasteForm];
            [[UserManager sharedUserManager] setString:_wasteDangeTextField.text withKey:WWasteDange];
            [[UserManager sharedUserManager] setString:_phTextField.text withKey:WWastePH];
            [[UserManager sharedUserManager] setString:_remarkTextField.text withKey:WWasteRemark];
            [[UserManager sharedUserManager] setString:_categaryTextfiled.text withKey:WWasteCatagery];
            [self postWasteImage];
            //[self gotoPourWaster];
        }
    }
    //点击确认按钮直接提交数据
    else{
        if (_mobileTextField.text.length == 0){
            [PROMPT_VIEW showMessage:@"废物产生人员的联系电话（手机号）为必选项"];
            return;
        }

        NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
        [user setObject:_mobileTextField.text forKey:WWastePhone];
        
//        int mobilev = [[UserManager sharedUserManager] getIntWithKey:[NSString stringWithFormat:@"v%@", _mobileTextField.text]];
//        if (mobilev == 0){
//            [PROMPT_VIEW showMessage:@"废物产生人员的联系电话（手机号）未验证！"];
//            [_verfiyMobileButton setHidden:NO];
//            return;
//        }
        [_verfiyMobileButton setHidden:YES];
        [[UserManager sharedUserManager] setString:_mobileTextField.text withKey:WWastePhone];
        [self postWasteData];
    }
}
- (IBAction)buttonCancelDidClick:(id)sender {
    if (step == 1){
        [self baseTopViewBackButtonClicked];
    }
    else{
        [self.navigationController popMasterToRootViewController];
    }
}

-(void)postWasteImage
{
    //不需要登录
    if (self.login == NotNeed_Login) {
        [self gotoPourWaster];
    //需要登录
    } else {
        if (wasteImage != nil && isPosted == NO) {
            [self beginUserEditInfoRequestWithImageData:wasteImage];
        } else {
            [self gotoPourWaster];
        }
    }
    
}

-(void)gotoPourWaster {
    WWPourWasteViewController *pourWasteViewController = [[WWPourWasteViewController alloc] initWithNibName:@"WWPourWasteViewController" bundle:nil];
    pourWasteViewController.symbolString = _symbolString;
    int next = step;
    if (step < 1){
        next = step + 1;
    }
    else{
        next = 0;
    }
    [[UserManager sharedUserManager] setInt:next withKey:kWWPourWasteStep];
    [self.navigationController pushViewController:pourWasteViewController animated:YES];
}
- (IBAction)goHomeDidClick:(id)sender {
    [self.navigationController popMasterToRootViewController];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    step = [[UserManager sharedUserManager] getIntWithKey:kWWPourWasteStep];
    
    [self.titleLabel setText:@"装入实验废物"];
    [self setTopViewBackButtonImageStyle:0];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.baseTopView setBackgroundColor:[UIColor whiteColor]];
    
    
    [self hiddenTopView];
    if (IS_IOS_7){
        _topView.top = 20;
    }
    
    [_verfiyMobileButton setHidden:YES];
    
    self.textFieldMMV.delegate = self;
    
    [self setUpForDismissKeyboard];
    
    _scrollView.top = 44;
    _scrollView.height = [[UIScreen mainScreen] bounds].size.height - _scrollView.top;
    [_scrollView setShowsVerticalScrollIndicator:NO];
    
    _section1View.top = 0;
    _section2View.top = _section1View.bottom;
    _sectionLastView.top = _section2View.bottom;
    _sectionBtnView.top = _sectionLastView.bottom;
    
    [_sectionPhotoView setHidden:YES];
    [_section1View setHidden:YES];
    [_section2View setHidden:YES];
    [_sectionLastView setHidden:YES];
    [_sectionBtnView setHidden:NO];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.width, _sectionBtnView.bottom+100);
    
    [self setUILayout];
    
    
    
}

-(void)initImageView
{
    _imageView.delegate = self;
    _imageView.enableTapEvent = YES;
    _imageView.layer.masksToBounds = YES;
    //_imageView.layer.cornerRadius = 2;
    [_imageView loadImage:[[UserManager sharedUserManager] portraitUrl] placeHolder:[UIImage imageNamed:@"SZ_HOME_ACTI_DEF.png"]];
}

- (void)imageViewDidClicked:(ITTImageView *)imageView
{
    [self changeImageViewTakePictureButtonClicked];
}

- (void)changeImageViewTakePictureButtonClicked
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        [self presentViewController:imagePickerController animated:YES completion:^{
            
        }];
    }
    else{
        [PROMPT_VIEW showMessage:@"当前设备不支持照相功能"];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *originImg = [info objectForKey:UIImagePickerControllerEditedImage];
        _imageView.image = originImg;
        NSData *imgData = UIImageJPEGRepresentation(originImg, 1);
        wasteImage = imgData;
        //[[UserManager sharedUserManager] setWasteImageData:imgData];
        //[self beginUserEditInfoRequestWithImageData:imgData];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (void)beginUserEditInfoRequestWithImageData:(NSData *)imgData
{
    if(imgData){
        __weak typeof(self) weakSelf = self;
        [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken){
            typeof(weakSelf) strongSelf = weakSelf;
            NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
            
            //NSLog(@"imgData is %@",imgData);
            //[paramDict setObject:imgData forKey:@"file"];
            [paramDict setValue:[imgData base64Encoding] forKey:@"file"];
            
            NSLog(@"paramDict is %@",paramDict);
            
            [WWImagePostRequest requestWithParameters:paramDict withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
                NSLog(@"start loading");
                [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
            } onRequestFinished:^(ITTBaseDataRequest *request) {
                if (request.isSuccess) {
                    //refresh
                    NSString *url = [request.handleredResult objectForKey:NETDATA];
                    [[ITTPromptView sharedPromptView] showMessage:@"修改成功"];
                    //[[UserManager sharedUserManager] storeUserInfoWithPortraitUrl:url];
                    isPosted = YES;
                    [[UserManager sharedUserManager] setString:url withKey:WWasteImage];
                    [weakSelf gotoPourWaster];
                }
            } onRequestCanceled:^(ITTBaseDataRequest *request) {
            } onRequestFailed:^(ITTBaseDataRequest *request) {
                NSLog(@"post Image failed");
                [PROMPT_VIEW showMessage:@"图片上传失败"];
                //TEST
                //isPosted = YES;
                //[[UserManager sharedUserManager] setString:@"" withKey:WWasteImage];
                //[weakSelf gotoPourWaster];
            }];
            
        }];
    }
}

-(void)setUILayout
{
    [self.titleLabel setText:[NSString stringWithFormat:@"倒入废物(%d/2)", step + 1]];
    if (step == 0){
        [self initImageView];
        [_sectionPhotoView setHidden:NO];
        [_section1View setHidden:NO];
        [_section2View setHidden:NO];
        [_sectionLastView setHidden:YES];
        _sectionPhotoView.top = 0;
        _section1View.top = _sectionPhotoView.bottom + 10;
        _section2View.top = _section1View.bottom + 10;
        _sectionBtnView.top = _section2View.bottom + 20;
        
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_confirmButton setTitle:@"下一步" forState:UIControlStateNormal];
    }
    else if (step == 1){
        [_sectionPhotoView setHidden:YES];
        [_section1View setHidden:YES];
        [_section2View setHidden:YES];
        [_sectionLastView setHidden:NO];
        _sectionLastView.top = 10;
        _sectionBtnView.top = _sectionLastView.bottom + 20;
        
        [_cancelButton setTitle:@"上一步" forState:UIControlStateNormal];
        [_confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    }
    _scrollView.contentSize = CGSizeMake(_scrollView.width, _sectionBtnView.bottom+150);
//默认选择废物名字
//    [self resetFormData];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
    
    _buttonView.top = self.view.height - _buttonView.height;
    [_verfiyMobileButton setHidden:YES];
    _mobileTextField.text = [[UserManager sharedUserManager] getStringWithKey:WWastePhone];
    
    if (_mobileTextField.text.length > 0){
        NSString *mobile =  _mobileTextField.text;
        
        if ([[UserManager sharedUserManager] getIntWithKey:[NSString stringWithFormat:@"v%@", mobile]] != 1 ){
            [_verfiyMobileButton setHidden:NO];
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (BOOL)prefersStatusBarHidden
{
    return NO;
}
*/

- (void)setUpForDismissKeyboard
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view addGestureRecognizer:singleTapGR];
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view removeGestureRecognizer:singleTapGR];
                }];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    //此method会将self.view里所有的subview的first responder都resign掉
    [self.view endEditing:YES];
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    if ([[theTextField text] length] > 0)
    {
        
    }
    return YES;
}


@end
