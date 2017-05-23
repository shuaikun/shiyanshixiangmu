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

@interface WWPourWasteViewController ()<ITTImageViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UIButton *lblGroupname;
@property (weak, nonatomic) IBOutlet UITextField *textFieldMMV;
@property (weak, nonatomic) IBOutlet UILabel *lblPackageBoxCode;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UIButton *homeButton;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (weak, nonatomic) IBOutlet UITextField *wasteNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *wasteNameButton;
@property (weak, nonatomic) IBOutlet UITextField *wasteWeightTextField;
@property (weak, nonatomic) IBOutlet UITextField *phTextField;
@property (weak, nonatomic) IBOutlet UITextField *wasteFormTextField;
@property (weak, nonatomic) IBOutlet UITextField *wasteDangeTextField;
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



@property (nonatomic, strong) UIWindow *wasteNamePickWindow;
@property (nonatomic, strong) WWWasteNamePickView *wasteNamePickView;

@end

@implementation WWPourWasteViewController
{
    int step;
    NSData *wasteImage;
    BOOL isPosted;
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
        
        [self resetFormData];
        
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
    if (_wasteNameTextField.text.length == 0){
        msg = @"废物名称为必选项";
        ret = false;
    }
    else if (_wasteWeightTextField.text.length == 0){
        msg = @"倒入废物的体积为必选项";
        ret = false;
    }
    else if (_wasteFormTextField.text.length == 0){
        msg = @"形态为必选项";
        ret = false;
    }
    else if (_wasteDangeTextField.text.length == 0){
        msg = @"毒性为必选项";
        ret = false;
    }
    else if (_phTextField.text.length == 0){
        msg = @"PH值为必选项";
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
                             ,@"user_id" : @"1"
                             ,@"waste_type" : [[UserManager sharedUserManager] getStringWithKey:WWasteType]
                             ,@"waste_name" : [[UserManager sharedUserManager] getStringWithKey:WWasteTypeName]
                             ,@"waste_weight" : [[UserManager sharedUserManager] getStringWithKey:WWasteWeight]
                             ,@"waste_form" : [[UserManager sharedUserManager] getStringWithKey:WWasteForm]
                             ,@"waste_danger_chars" : [[UserManager sharedUserManager] getStringWithKey:WWasteDange]
                             ,@"waste_ph" : [[UserManager sharedUserManager] getStringWithKey:WWastePH]
                             ,@"remark" : [[UserManager sharedUserManager] getStringWithKey:WWasteRemark]
                             ,@"contact_tel" : [[UserManager sharedUserManager] getStringWithKey:WWastePhone]
                             ,@"waste_image" : [[UserManager sharedUserManager] portraitUrl]
                             
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
    } onRequestFailed:^(ITTBaseDataRequest *request) {
    }];
}
- (IBAction)buttonSubmitDidClick:(id)sender {
    //[self baseTopViewBackButtonClicked];
    if (step == 0){
        if ([self validateUserData]){
            [[UserManager sharedUserManager] setString:_wasteWeightTextField.text withKey:WWasteWeight];
            [[UserManager sharedUserManager] setString:_wasteFormTextField.text withKey:WWasteForm];
            [[UserManager sharedUserManager] setString:_wasteDangeTextField.text withKey:WWasteDange];
            [[UserManager sharedUserManager] setString:_phTextField.text withKey:WWastePH];
            [[UserManager sharedUserManager] setString:_remarkTextField.text withKey:WWasteRemark];
            [self postWasteImage];
            //[self gotoPourWaster];
        }
    }
    else{
        if (_mobileTextField.text.length == 0){
            [PROMPT_VIEW showMessage:@"废物产生人员的联系电话（手机号）为必选项"];
            return;
        }
        
        int mobilev = [[UserManager sharedUserManager] getIntWithKey:[NSString stringWithFormat:@"v%@", _mobileTextField.text]];
        if (mobilev == 0){
            [PROMPT_VIEW showMessage:@"废物产生人员的联系电话（手机号）未验证！"];
            [_verfiyMobileButton setHidden:NO];
            return;
        }
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
    if (wasteImage != nil && isPosted == NO){
        
        dd
        
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
    
    _scrollView.contentSize = CGSizeMake(_scrollView.width, _sectionBtnView.bottom+30);
    
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
        [[UserManager sharedUserManager] setWasteImageData:imgData];
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
            
            NSLog(@"imgData is %@",imgData);
            [paramDict setObject:imgData forKey:@"file"];
            
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
                    isPosted = true;
                    
                }
            } onRequestCanceled:^(ITTBaseDataRequest *request) {
            } onRequestFailed:^(ITTBaseDataRequest *request) {
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
    _scrollView.contentSize = CGSizeMake(_scrollView.width, self.view.bottom+180);

    [self resetFormData];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
    
    _buttonView.top = self.view.height - _buttonView.height;
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
