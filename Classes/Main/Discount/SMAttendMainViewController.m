//
//  SMAttendMainViewController.m
//  com.knowesoft.oax
//
//  Created by Golun on 14-8-19.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMAttendMainViewController.h"
#import "SMAttendanceViewController.h"

@interface SMAttendMainViewController ()

@end

@implementation SMAttendMainViewController

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
    [self setTitle:@"考勤"];
    [self hiddenBackButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)OneButtonDidClicked:(id)sender {
    UIButton *button = (UIButton *)sender;
    int tag = button.tag;
    __weak typeof(self) weakSelf = self;
    switch (tag) {
        case kTagKaoQinOneChoiceMyReg:
        {
            [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken) {
                typeof(self) strongSelf = weakSelf;
                SMAttendanceViewController *attendanceViewController = [[SMAttendanceViewController alloc] initWithNibName:@"SMAttendanceViewController" bundle:nil];
                [attendanceViewController setIsFromHomePage:YES];
                [attendanceViewController setChoiceType:tag];
                [strongSelf pushMasterViewController:attendanceViewController];
            }];
        }
            break;
        case kTagKaoQinOneChoiceMyLeave:
        {
            [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken) {
                typeof(self) strongSelf = weakSelf;
                SMAttendanceViewController *attendanceViewController = [[SMAttendanceViewController alloc] initWithNibName:@"SMAttendanceViewController" bundle:nil];
                [attendanceViewController setIsFromHomePage:YES];
                [attendanceViewController setChoiceType:tag];
                [strongSelf pushMasterViewController:attendanceViewController];
            }];
        }
            break;
        case kTagKaoQinOneChoiceAuditLeave:
        {
            [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken) {
                typeof(self) strongSelf = weakSelf;
                SMAttendanceViewController *attendanceViewController = [[SMAttendanceViewController alloc] initWithNibName:@"SMAttendanceViewController" bundle:nil];
                [attendanceViewController setIsFromHomePage:YES];
                [attendanceViewController setChoiceType:tag];
                [strongSelf pushMasterViewController:attendanceViewController];
            }];
        }
            break;
        case kTagKaoQinOneChoiceAuditReg:
        {
            [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken) {
                typeof(self) strongSelf = weakSelf;
                SMAttendanceViewController *attendanceViewController = [[SMAttendanceViewController alloc] initWithNibName:@"SMAttendanceViewController" bundle:nil];
                [attendanceViewController setIsFromHomePage:YES];
                [attendanceViewController setChoiceType:tag];
                [strongSelf pushMasterViewController:attendanceViewController];
            }];
        }
            break;
        case kTagKaoQinOneChoiceMyTx:
        {
            [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken) {
                typeof(self) strongSelf = weakSelf;
                SMAttendanceViewController *attendanceViewController = [[SMAttendanceViewController alloc] initWithNibName:@"SMAttendanceViewController" bundle:nil];
                [attendanceViewController setIsFromHomePage:YES];
                [attendanceViewController setChoiceType:tag];
                [strongSelf pushMasterViewController:attendanceViewController];
            }];
        }
            break;
        case kTagKaoQinOneChoiceAuditTx:
        {
            [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken) {
                typeof(self) strongSelf = weakSelf;
                SMAttendanceViewController *attendanceViewController = [[SMAttendanceViewController alloc] initWithNibName:@"SMAttendanceViewController" bundle:nil];
                [attendanceViewController setIsFromHomePage:YES];
                [attendanceViewController setChoiceType:tag];
                [strongSelf pushMasterViewController:attendanceViewController];
            }];
        }
            break;
        default:
        {
            
        }
            break;
    }
}

@end
