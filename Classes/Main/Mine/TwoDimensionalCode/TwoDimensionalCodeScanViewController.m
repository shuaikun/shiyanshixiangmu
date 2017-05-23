//
//  TwoDimensionalCodeScanViewController.m
//  SinaLiftCircle
//
//  Created by 王琦 on 13-10-31.
//
//

#import "TwoDimensionalCodeScanViewController.h"
#import "TwoDimensionalCodeResultViewController.h"
#import "TwoDimensionalCodeShadowView.h"
#import "TwoDimensionalCodeHighlightView.h"
#import "ZBarSDK.h"
#import "ZBarReaderView.h"
#import "SZWebViewController.h"
#import "UserManager.h"

@interface TwoDimensionalCodeScanViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,ZBarReaderViewDelegate,ZBarReaderDelegate>

{
    NSTimer * _timer;
}

@property (retain, nonatomic) IBOutlet UIView *dimendionalCodeScanBgView;
@property (retain, nonatomic) IBOutlet UIView *highlightView;
@property (retain, nonatomic) IBOutlet UILabel *tipLabel;
@property (retain, nonatomic) IBOutlet UIImageView *lineView;
@property (retain, nonatomic) ZBarReaderView *zBarReaderView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (nonatomic, strong) NSMutableArray * mutabelArray;
    
@end

@implementation TwoDimensionalCodeScanViewController

//- (void)setArrayForQRCode:(NSMutableArray *)arrayForQRCode {
//    _arrayForQRCode = arrayForQRCode;
//}
    
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.mutabelArray = [NSMutableArray array];
    [self setNeedsStatusBarAppearanceUpdate];
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (BOOL)prefersStatusBarHidden
{
    return NO;
}
//点击返回
- (IBAction)backButtonDidClick:(id)sender {
    //处置企业
    if ([self whethIsDisposalEnterprise]) {
        self.getQRCode(self.mutabelArray);
    } 
    [self baseTopViewBackButtonClicked];
}
//是否是处置单位
- (BOOL)whethIsDisposalEnterprise {
    return [[UserManager objectForKey:@"sKOrgType"] isEqualToString:@"4"];
}
    
-(CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
{
    
    NSLog(@"rect is %f,%f,%f,%f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
    NSLog(@"readerViewBounds is %f,%f,%f,%f",readerViewBounds.origin.x,readerViewBounds.origin.y,readerViewBounds.size.width,readerViewBounds.size.height);
    
    CGFloat x,y,width,height;
    
    x = rect.origin.y/readerViewBounds.size.height;
    y = 1-(rect.origin.x+rect.size.width)/readerViewBounds.size.width;
    width = (rect.origin.y+rect.size.height)/readerViewBounds.size.height;
    height = 1-rect.origin.x/readerViewBounds.size.width;
    
    NSLog(@"x y width height is %f %f %f %f",x,y,width,height);
    
    return CGRectMake(x, y, width, height);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self baseTopView] setHidden:YES];
    [self setTitle:@"二维码扫描"];
    CGFloat totalHeight = _dimendionalCodeScanBgView.height;
    if(is4InchScreen()){
        totalHeight+=108;
    }
    
    NSLog(@"totalHeight is %f",totalHeight);
    
    _zBarReaderView = [[ZBarReaderView alloc] init];
    _zBarReaderView.frame = CGRectMake(0, 0, 320, totalHeight);
    _zBarReaderView.readerDelegate = self;
    //关闭闪光灯
    _zBarReaderView.torchMode = 0;
    _zBarReaderView.tracksSymbols = NO;
    
    CGRect scanMaskRect = CGRectMake(42, 112, 236, 236);
    _zBarReaderView.scanCrop = [self getScanCrop:scanMaskRect readerViewBounds:_zBarReaderView.bounds];
    
    TwoDimensionalCodeShadowView *shadowView = [[TwoDimensionalCodeShadowView alloc] initWithFrame:_zBarReaderView.bounds];
    shadowView.backgroundColor = [UIColor clearColor];
    shadowView.alpha = 0.55;
    [_zBarReaderView addSubview:shadowView];
    
    TwoDimensionalCodeHighlightView *highlightView = [[TwoDimensionalCodeHighlightView alloc] initWithFrame:_highlightView.bounds];
    highlightView.backgroundColor = [UIColor clearColor];
    [_highlightView addSubview:highlightView];
    
    [_dimendionalCodeScanBgView addSubview:_zBarReaderView];
    
    [_dimendionalCodeScanBgView bringSubviewToFront:_highlightView];
    [_dimendionalCodeScanBgView bringSubviewToFront:_tipLabel];
    [_dimendionalCodeScanBgView bringSubviewToFront:_backButton];
}

- (void)moveLine
{
    [UIView animateWithDuration:2.8 animations:^{
        _lineView.top = 233;
    }completion:^(BOOL finished) {
        _lineView.top = 1;
    }];
}

- (void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    ZBarSymbol *symbol = nil;
    for(symbol in symbols){
        [readerView stop];
        NSLog(@"symbol.data is %@",symbol.data);
        
        //处置单位
        if ([self whethIsDisposalEnterprise]) {
            //判断是否已经存在这个二维码
            int i = 0;
            for (NSString * qrcode in self.arrayForQRCode) {
                if ([qrcode isEqualToString:symbol.data]) {
                    i = 1;
                }
            }
            [self performSelector:@selector(qDCodeStartReaderView:) withObject:readerView afterDelay:1.0];
            //不存在二维码时
            if (i == 0) {
                [PROMPT_VIEW showMessage:@"扫描完成"];
                [self.mutabelArray addObject:symbol.data];
            //已存在二维码
            } else {
                [PROMPT_VIEW showMessage:@"二维码已存在，不需要重复扫描"];
            }
            
        } else {
            
            //处理中文乱码问题
            //        if([symbolString canBeConvertedToEncoding:NSShiftJISStringEncoding]){
            //            symbolString = [NSString stringWithCString:[symbol.data cStringUsingEncoding:NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
            //        }
            
            //http://m.leju.com/touch/app/detail.html?user_id=1&user_type=1
            NSString *resultString = symbol.data;
            if([resultString hasPrefix:@"http://"]){
                SZWebViewController *webViewController = [[SZWebViewController alloc] initWithNibName:@"SZWebViewController" bundle:nil];
                webViewController.urlStr = resultString;
                [self pushMasterViewController:webViewController];
            }
            else{
                TwoDimensionalCodeResultViewController *twoDimensionalCodeResultViewController = [[TwoDimensionalCodeResultViewController alloc] initWithNibName:@"TwoDimensionalCodeResultViewController" bundle:nil];
                twoDimensionalCodeResultViewController.symbolString = resultString;
                twoDimensionalCodeResultViewController.login = self.login;
                [self pushMasterViewController:twoDimensionalCodeResultViewController];
            }
        }
    }
}
    
- (void)qDCodeStartReaderView:(ZBarReaderView *)readerView {
    [readerView start];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_zBarReaderView start];
    _lineView.hidden = NO;
    _lineView.top = 1;
    if(_timer && _timer.isValid){

    }
    else{
        _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(moveLine) userInfo:nil repeats:YES];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_zBarReaderView stop];
    if(_timer && _timer.isValid){
        [_timer invalidate];
        _timer = nil;
    }
    _lineView.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)navigationBackButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)navigationChooseButtonClick:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择二维码", nil];
    [actionSheet showInView:self.view];
    
    [_zBarReaderView stop];
    if(_timer && _timer.isValid){
        [_timer invalidate];
        _timer = nil;
    }
    _lineView.hidden = YES;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex is %d",buttonIndex);
    
    switch (buttonIndex) {
        case 0:
        {
            ZBarReaderController *readerController = [ZBarReaderController new];
            readerController.allowsEditing = YES;
            readerController.readerDelegate = self;
            readerController.showsHelpOnFail = NO;
            ZBarImageScanner *scaner = readerController.scanner;
            [scaner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
            readerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:readerController animated:YES completion:^{
                
            }];
        }
            break;
        case 1:
        {
            [_zBarReaderView start];
            _lineView.hidden = NO;
            _lineView.top = 1;
            if(_timer && _timer.isValid){
                [_timer invalidate];
                _timer = nil;
            }
            _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(moveLine) userInfo:nil repeats:YES];
        }
            break;
        default:
            break;
    }
}

- (void)readerControllerDidFailToRead:(ZBarReaderController *)reader withRetry:(BOOL)retry
{
    NSLog(@"not a twodimensionalcode");
    [reader dismissViewControllerAnimated:YES completion:^{
        
    }];
    _lineView.hidden = NO;
    _lineView.top = 1;
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(moveLine) userInfo:nil repeats:YES];
    [PROMPT_VIEW showMessage:@"未发现二维码"];
}

- (void)imagePickerController:(UIImagePickerController *)reader didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"is a twodimensionalcode");
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    [reader dismissViewControllerAnimated:YES completion:^{
        
    }];
    NSLog(@"symbol.data here is %@",symbol.data);

    NSString *resultString = symbol.data;
    if([resultString hasPrefix:@"http://"]){
        SZWebViewController *webViewController = [[SZWebViewController alloc] initWithNibName:@"SZWebViewController" bundle:nil];
        webViewController.urlStr = resultString;
        [self pushMasterViewController:webViewController];
    }
    else{
        TwoDimensionalCodeResultViewController *twoDimensionalCodeResultViewController = [[TwoDimensionalCodeResultViewController alloc] initWithNibName:@"TwoDimensionalCodeResultViewController" bundle:nil];
        twoDimensionalCodeResultViewController.symbolString = resultString;
        twoDimensionalCodeResultViewController.onlyView = false;
        [[UserManager sharedUserManager] setInt:0 withKey:kWWPourWasteStep];
        [self.navigationController pushViewController:twoDimensionalCodeResultViewController animated:YES];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)reader
{
    [reader dismissViewControllerAnimated:YES completion:^{
        
    }];
}



@end










