//
//  SMNewsPickerViewController.m
//  KnoweSoft.OAX
//
//  Created by Golun on 14-8-4.
//  Copyright (c) 2014年 Knowesoft. All rights reserved.
//

#import "SMNewsPickerViewController.h"

@interface SMNewsPickerViewController ()
<UITableViewDelegate, UITableViewDataSource>
@end

@implementation SMNewsPickerViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *news = cell.textLabel.text;
    [_newsPickerBtn setTitle:news forState:(UIControlStateNormal)];
    [[UserManager sharedUserManager] setNews:news];
    __weak typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        typeof(self) strongSelf = weakSelf;
        if (_finishPickBlock) {
            _finishPickBlock(news);
        }
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *newsPickerCellIdentifier = @"newsPickerCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:newsPickerCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:newsPickerCellIdentifier];
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"新闻";
            break;
        case 1:
            cell.textLabel.text = @"通知";
            break;
            
        default:
            break;
    }
    return cell;
}

@end
