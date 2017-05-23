//
//  SZCityPickerViewController.m
//  iTotemFramework
//
//  Created by Grant on 14-5-6.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZCityPickerViewController.h"

@interface SZCityPickerViewController ()
<UITableViewDelegate
,UITableViewDataSource
>
@end

@implementation SZCityPickerViewController

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
    NSString *city = cell.textLabel.text;
    [_cityPickerBtn setTitle:city forState:(UIControlStateNormal)];
    [[UserManager sharedUserManager] setCity:city];
    __weak typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        typeof(self) strongSelf = weakSelf;
        if (_finishPickBlock) {
            _finishPickBlock(city);
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
    static NSString *cityPickerCellIdentifier = @"cityPickerCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cityPickerCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cityPickerCellIdentifier];
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"宿州";
            break;
        case 1:
            cell.textLabel.text = @"唐山";
            break;
            
        default:
            break;
    }
    return cell;
}
@end
