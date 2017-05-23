//
//  SZMyAddressListViewController.m
//  iTotemFramework
//
//  Created by 王琦 on 14-4-14.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZMyAddressListViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MessageUI.h>
#import "AddressBookUtils.h"
#import "SZOneContactCell.h"
#import "SZUserPhonebookRequest.h"
#import "SZUserPhoneBookModel.h"
#import "SZUserAddFriendsRequest.h"

@interface SZMyAddressListViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,MFMessageComposeViewControllerDelegate,SZOneContactCellDelegate>

@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *addressListArray;
@property (strong, nonatomic) NSMutableArray *searchListArray;
@property (assign, nonatomic) BOOL isSearching;

@end

@implementation SZMyAddressListViewController

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
    [self setTitle:@"我的通讯录"];
    [self setAddressBookData];
    _searchView.layer.masksToBounds = YES;
    _searchView.layer.cornerRadius = 3;
    _addressListArray = [NSMutableArray array];
    _searchListArray = [NSMutableArray array];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)setAddressBookData
{
    __block BOOL accessGranted = NO;
    ABAddressBookRef addressBook = nil;
    if (ABAddressBookRequestAccessWithCompletion != NULL){
        addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        //等待同意后向下执行
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error){
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    else{
        if(IS_IOS_7){
            addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        }
        else{
            addressBook = ABAddressBookCreate();
        }
    }
    //
    if (accessGranted) {
        NSArray *addressListArray = [AddressBookUtils getAllContacts];
        int count = [addressListArray count];
        NSString *phone_book = @"";
        for(int i=0;i<count;i++){
            NSDictionary *diction = [addressListArray objectAtIndex:i];
            NSString *phone = [diction objectForKey:@"phone"];
            NSString *name = [diction objectForKey:@"name"];
            NSLog(@"name is %@,phone is %@",name,phone);
            NSString *tempString = [NSString stringWithFormat:@"%@|%@",name,phone];
            if(IS_STRING_EMPTY(phone_book)){
                phone_book = [phone_book stringByAppendingString:tempString];
            }
            else{
                phone_book = [phone_book stringByAppendingString:[NSString stringWithFormat:@",%@",tempString]];
            }
        }
        [self beginUserPhonebookRequestWithPhoneBook:phone_book];
    }
    else{
        [PROMPT_VIEW showMessage:@"没有被允许访问通讯录，请到设置中修改权限"];
    }
}

- (void)beginUserPhonebookRequestWithPhoneBook:(NSString *)phone_book
{
    __weak typeof(self) weakSelf = self;
    [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken){
        typeof(weakSelf) strongSelf = weakSelf;
        NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
        [paramDict setObject:SZINDEX_USER_PHONEBOOK_METHOD forKey:PARAMS_METHOD_KEY];
        [paramDict setObject:userId forKey:PARAMS_USER_ID];
        [paramDict setObject:phone_book forKey:@"phone_book"];
        NSLog(@"paramDict is %@",paramDict);
        [SZUserPhonebookRequest requestWithParameters:paramDict withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
            NSLog(@"start loading");
            [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
        } onRequestFinished:^(ITTBaseDataRequest *request) {
            if (request.isSuccess) {
                NSArray *listsArray = [request.handleredResult objectForKey:@"listsArray"];
                if(listsArray && [listsArray isKindOfClass:[NSArray class]]){
                    NSLog(@"listsArray is %@",listsArray);
                    [strongSelf.addressListArray addObjectsFromArray:listsArray];
                }
                [strongSelf.tableView reloadData];
            }
        } onRequestCanceled:^(ITTBaseDataRequest *request) {
        } onRequestFailed:^(ITTBaseDataRequest *request) {
        }];
    }];
}

- (void)oneContactCellDidChooseAddOnUserPhone:(NSString *)phoneNumber
{
//    __weak typeof(self) weakSelf = self;
    [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken){
//        typeof(weakSelf) strongSelf = weakSelf;
        NSLog(@"phoneNumber is %@",phoneNumber);
        NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
        [paramDict setObject:SZINDEX_USER_ADDFRIENDS_METHOD forKey:PARAMS_METHOD_KEY];
        [paramDict setObject:userId forKey:PARAMS_USER_ID];
        [paramDict setObject:phoneNumber forKey:@"friends_name"];
        [SZUserAddFriendsRequest requestWithParameters:paramDict withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
            NSLog(@"start loading");
            [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
        } onRequestFinished:^(ITTBaseDataRequest *request) {
            if (request.isSuccess) {
                //refresh
                [PROMPT_VIEW showMessage:@"添加好友成功"];
                [self refreshDataWithPhoneNumber:phoneNumber];
            }
        } onRequestCanceled:^(ITTBaseDataRequest *request) {
        } onRequestFailed:^(ITTBaseDataRequest *request) {
        }];
    }];
}

- (void)refreshDataWithPhoneNumber:(NSString *)phoneNumber
{
    if(_isSearching){
        int searchCount = [_searchListArray count];
        for(int i=0;i<searchCount;i++){
            SZUserPhoneBookModel *model = [_searchListArray objectAtIndex:i];
            model.type = @"1";
            break;
        }
    }
    
    int addressCount = [_addressListArray count];
    for(int i=0;i<addressCount;i++){
        SZUserPhoneBookModel *model = [_addressListArray objectAtIndex:i];
        model.type = @"1";
        break;
    }
    
    [_tableView reloadData];
}

- (void)oneContactCellDidChooseInviteOnUserPhone:(NSString *)phoneNumber
{
    if([MFMessageComposeViewController canSendText]){
        MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
        NSArray *recipients = [[NSArray alloc] initWithObjects:phoneNumber, nil];
        picker.messageComposeDelegate = self;
        picker.recipients = recipients;
        picker.body = [NSString stringWithFormat:@"我在使用泰优惠，很不错哦，推荐给你！%@",APP_DOWNLOAD_URL];
        [self presentViewController:picker animated:YES completion:nil];
    }
    else{
        [PROMPT_VIEW showMessage:@"您的设备不能发信息"];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result)
    {
        case MessageComposeResultCancelled:
            break;
        case MessageComposeResultSent:
            {
                [PROMPT_VIEW showMessage:@"短信发送成功"];
            }
            break;
        case MessageComposeResultFailed:
            {
                [PROMPT_VIEW showMessage:@"短信发送失败，请重试。"];
            }
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)textFieldDidChange
{
    if([_textField.text isEqualToString:@""]){
        _isSearching = NO;
        [_searchListArray removeAllObjects];
        [_tableView reloadData];
    }
    else{
        _isSearching = YES;
        [_searchListArray removeAllObjects];
        NSString *searchContent = _textField.text;
        int count = [_addressListArray count];
        for(int i=0;i<count;i++){
            SZUserPhoneBookModel *model = [_addressListArray objectAtIndex:i];
            NSRange rangeRoad=[model.friend_name rangeOfString:searchContent options:NSCaseInsensitiveSearch];
            if(rangeRoad.length>0){
                [_searchListArray addObject:model];
            }
        }
        [_tableView reloadData];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_textField resignFirstResponder];
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_isSearching){
        return [_searchListArray count];
    }
    else{
        return [_addressListArray count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SZOneContactCell";
    SZOneContactCell *cell = (SZOneContactCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil){
        cell = [SZOneContactCell cellFromNib];
        cell.delegate = self;
    }
    if(_isSearching){
        [cell getDataSourceFromModel:[_searchListArray objectAtIndex:indexPath.row]];
    }
    else{
        [cell getDataSourceFromModel:[_addressListArray objectAtIndex:indexPath.row]];
    }
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end






