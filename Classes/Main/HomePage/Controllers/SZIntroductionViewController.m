//
//  SZIntroductionViewController.m
//  iTotemFramework
//
//  Created by Grant on 14-5-4.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZIntroductionViewController.h"

@interface SZIntroductionViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *introImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *introScrollView;
@property (nonatomic, copy) void(^finishBlock)(void);
@end

@implementation SZIntroductionViewController

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
    // Do any additional setup after loading the view from its nib.
    self.introScrollView.contentSize = self.introImageView.size;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showIntroductionWithFinishBlock:(void(^)(void))finishBlock
{
    self.finishBlock = finishBlock;
}

- (IBAction)startBtnDidClicked:(id)sender {
    __weak typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 typeof(self) strongSelf = weakSelf;
                                 if (_finishBlock) {
                                    strongSelf.finishBlock();
                                 }
                             }];
}

@end
