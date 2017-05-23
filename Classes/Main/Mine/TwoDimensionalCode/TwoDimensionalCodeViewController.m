//
//  TwoDimensionalCodeViewController.m
//  SinaLiftCircle
//
//  Created by 王琦 on 13-10-31.
//
//

#import "TwoDimensionalCodeViewController.h"
#import "QRCodeGenerator.h"
#import "TwoDimensionalCodeScanViewController.h"
#import "SinaWeiboPostDataRequest.h"

@interface TwoDimensionalCodeViewController ()<UIActionSheetDelegate,SinaWeiboLoginDelegate,DataRequestDelegate>

@property (retain, nonatomic) IBOutlet UIView *navigationBgView;
@property (retain, nonatomic) IBOutlet UIView *dimendionalCodeBgView;
@property (retain, nonatomic) IBOutlet ITTImageView *headImageView;
@property (retain, nonatomic) IBOutlet UILabel *userNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *userAddressLabel;
@property (retain, nonatomic) IBOutlet UIImageView *twoDimensionalCodeImageView;

- (IBAction)navigationBackButtonClick:(id)sender;
- (IBAction)navigationChooseButtonClick:(id)sender;


@end

@implementation TwoDimensionalCodeViewController

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
    
    if(IPHONE5){
        _dimendionalCodeBgView.top += 44;
    }
    
    _dimendionalCodeBgView.layer.masksToBounds = YES;
    _dimendionalCodeBgView.layer.cornerRadius = 6;
    
    if (IS_STRING_NOT_EMPTY(DATA_ENV.userInfo.header)) {
        switch (DATA_ENV.userType) {
            case normalType:
                [_headImageView loadImage:DATA_ENV.userInfo.header placeHolder:ImageNamed(@"default_person_head")];
                
                break;
            case shopType:
                [_headImageView loadImage:DATA_ENV.userInfo.header placeHolder:ImageNamed(@"default_shop_head")];
                
                break;
            case estateType:
                [_headImageView loadImage:DATA_ENV.userInfo.header placeHolder:ImageNamed(@"default_property_head")];
                
                break;
            default:
                break;
        }
        
    }else {
        [self setHeadImage];
    }

    _userNameLabel.text = DATA_ENV.userInfo.displayName;
    
    if(IS_STRING_EMPTY(DATA_ENV.userInfo.hometown)){
        _userAddressLabel.hidden = YES;
        _userNameLabel.top = 32;
    }
    else{
        _userAddressLabel.hidden = NO;
        _userNameLabel.top = 24;
        _userAddressLabel.text = [NSString stringWithFormat:@"%@",DATA_ENV.userInfo.hometown];
    }

    NSString *string = [NSString stringWithFormat:@"%@?user_id=%@&user_type=%d",HAOMA_APPLICATION_DOWNLOAD_URL,DATA_ENV.userId,DATA_ENV.userType];
    
    _twoDimensionalCodeImageView.image = [QRCodeGenerator qrImageForString:string imageSize:_twoDimensionalCodeImageView.bounds.size.width];
    
}

- (void)setHeadImage{
    switch (DATA_ENV.userType) {
        case normalType:
            _headImageView.image = ImageNamed(@"default_person_head");
            break;
        case shopType:
            _headImageView.image = ImageNamed(@"default_shop_head");
            break;
        case estateType:
            _headImageView.image = ImageNamed(@"default_property_head");
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_navigationBgView release];
    [_dimendionalCodeBgView release];
    [_headImageView release];
    [_userNameLabel release];
    [_userAddressLabel release];
    [_twoDimensionalCodeImageView release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setNavigationBgView:nil];
    [self setDimendionalCodeBgView:nil];
    [self setHeadImageView:nil];
    [self setUserNameLabel:nil];
    [self setUserAddressLabel:nil];
    [self setTwoDimensionalCodeImageView:nil];
    [super viewDidUnload];
}

- (IBAction)navigationBackButtonClick:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Cancel_SinaWeiboPostDataRequest" object:nil userInfo:@{CANCEL_REQUEST: @"Cancel_SinaWeiboPostDataRequest"}];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)navigationChooseButtonClick:(id)sender
{
    //
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享到新浪微博", @"保存二维码到手机", @"扫描二维码", nil];
    [actionSheet showInView:self.view];
    [actionSheet release];
}

- (void)shareSinaWeibo:(int)type
{
    NSString *message = @"微博分享中...";
    
    NSString *expires = [[USER_DEFAULT objectForKey:@"SinaWeiboAuthData"] objectForKey:@"expires_in"];
    NSMutableDictionary *sinaParam = [NSMutableDictionary dictionary];
    if (DATA_ENV.isBoundSinaWeiBo && expires.intValue){
        NSString *token = [[USER_DEFAULT objectForKey:@"SinaWeiboAuthData"] objectForKey:@"AccessTokenKey"];
        if (IS_STRING_NOT_EMPTY(token)){
            [sinaParam setObject:token forKey:@"access_token"];
            //分享二维码的文字内容
            NSString *contentEncode = [NSString stringWithFormat:@"Hi，All！你的手机应用好吗？我正在使用一个以小区为核心，将人、商家、物业聚集为圆形社区中心的手机应用——好吗！这是一个移动端的BBS，好吗！这是一个移动的社区服务应用，好吗！这是一个围绕小区的轻社交应用，好吗！快来关注我，一起用，好吗？！%@",HAOMA_APPLICATION_DOWNLOAD_URL];
            contentEncode = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)contentEncode, nil, nil, kCFStringEncodingUTF8);
            [sinaParam setObject:contentEncode forKey:@"status"];
            [contentEncode release];
            NSData* data = UIImagePNGRepresentation(_twoDimensionalCodeImageView.image);
            [sinaParam setObject:data forKey:@"pic"];
            
            [SinaWeiboPostDataRequest requestWithParameters:sinaParam withIndicatorView:nil withCancelSubject:@"Cancel_SinaWeiboPostDataRequest" onRequestStart:^(ITTBaseDataRequest *request) {
                [PROMPT_VIEW showActivityWithMask:message];
            } onRequestFinished:^(ITTBaseDataRequest *request) {
                if([request isSuccess]){
                    [PROMPT_VIEW showMessage:@"微博分享成功!"];
                    [self performSelector:@selector(back) withObject:nil afterDelay:0.3];
                }
                else{
                    NSString *error = [request.resultDic objectForKey:@"message"];
                    if (IS_STRING_NOT_EMPTY(error)) {
                        [PROMPT_VIEW showMessage:error];
                    } else {
                        [PROMPT_VIEW hidden];
                    }
                }
            } onRequestCanceled:^(ITTBaseDataRequest *request) {
            } onRequestFailed:^(ITTBaseDataRequest *request) {
            }];
            
        }
    }
}

- (void)showBindSuccessAndSend
{
    
    [self shareSinaWeibo:1];
}

- (void)showBindFail
{
    [PROMPT_VIEW showMessage:@"微博绑定失败..."];
}

- (void)sinaWeiBoManager:(SinaWeiBoManager *)manager didLoginSuccess:(SinaWeibo *)weibo
{
    NSLog(@"success");
    NSString *expires = [[USER_DEFAULT objectForKey:@"SinaWeiboAuthData"] objectForKey:@"expires_in"];
    NSLog(@"---%@----%d---",expires,DATA_ENV.isBoundSinaWeiBo);
    if(DATA_ENV.isBoundSinaWeiBo&&[expires intValue]){
        [self performSelector:@selector(showBindSuccessAndSend) withObject:nil afterDelay:0.6];
    }
}

- (void)sinaWeiBoManager:(SinaWeiBoManager *)manager didLoginFail:(SinaWeibo *)weibo
{
    NSLog(@"fail");
    [self performSelector:@selector(showBindFail) withObject:nil afterDelay:0.6];
}

- (void)sinaWeiBoManager:(SinaWeiBoManager *)manager didCancel:(SinaWeibo *)weibo
{
    NSLog(@"cancel");
}

- (void)bindSinaWeibo
{
    APP_DELEGATE.isTapConnectSinaWeibo = YES;
    SinaWeiBoManager *sinaWeiboManager =[SinaWeiBoManager sharedInstance];
    sinaWeiboManager.delegate = self;
    [sinaWeiboManager loginSinaWeiboWithDelegate:nil AndTpye:2];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            NSString *expires = [[USER_DEFAULT objectForKey:@"SinaWeiboAuthData"] objectForKey:@"expires_in"];
            NSLog(@"---%@----%d---",expires,DATA_ENV.isBoundSinaWeiBo);
            if(!DATA_ENV.isBoundSinaWeiBo||![expires intValue]){
                NSLog(@"go to bound");
                [self performSelector:@selector(bindSinaWeibo) withObject:nil afterDelay:0.6];
            }
            else{
                NSLog(@"already bound");
                [self shareSinaWeibo:0];
            }
        }
            break;
        case 1:
        {
            UIImageWriteToSavedPhotosAlbum(_twoDimensionalCodeImageView.image, nil, nil, nil);
            [PROMPT_VIEW showMessage:@"图片已保存到相册"];
        }
            break;
        case 2:
        {
            if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                [PROMPT_VIEW showMessage:@"无法打开摄像头"];
                return;
            }
            if(!isReachability)
            {
                [PROMPT_VIEW showMessage:@"当前网络已断开，请稍后重试"];
                return;
            }
            TwoDimensionalCodeScanViewController *twoDimensionalCodeScanViewController = [[TwoDimensionalCodeScanViewController alloc] initWithNibName:@"TwoDimensionalCodeScanViewController" bundle:nil];
            [self.navigationController pushViewController:twoDimensionalCodeScanViewController animated:YES];
            [twoDimensionalCodeScanViewController release];
        }
            break;
        default:
            break;
    }
}

@end







