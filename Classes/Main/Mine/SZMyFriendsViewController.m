//
//  SZMyFriendsViewController.m
//  iTotemFramework
//
//  Created by 王琦 on 14-4-14.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZMyFriendsViewController.h"
#import "SZMyAddressListViewController.h"
#import "SZIndexHeaderView.h"
#import "SZOneFriendCell.h"
#import "SZIndexListView.h"
#import "SZUserFriendsRequest.h"
#import "SZUserFriendsModel.h"
#import "SZPersonalDynamicViewController.h"

#define DATA_SOURCE @"DATA_SOURCE"
#define INDEX_SOURCE @"INDEX_SOURCE"
#define HEADER_VIEW_HEIGHT 21
#define CELL_VIEW_HEIGHT 52

@interface SZMyFriendsViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,SZIndexListViewDelegate,SZOneFriendCellDelegate>

@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) SZIndexListView * indexListView;
@property (strong, nonatomic) NSMutableArray *friendsListArray;
@property (strong, nonatomic) NSMutableArray *searchListArray;
@property (assign, nonatomic) BOOL isSearching;
@property (assign, nonatomic) CGFloat limitY;
@property (assign, nonatomic) int limitIndex;
@property (weak, nonatomic) IBOutlet UILabel *noDataLabel;


- (IBAction)onRightButtonClicked:(id)sender;

@end

@implementation SZMyFriendsViewController

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
    if(IS_STRING_NOT_EMPTY(_friendsCount) && ![_friendsCount isEqualToString:@"0"]){
        [self setTitle:[NSString stringWithFormat:@"我的好友(%@)",_friendsCount]];
    }else{
        [self setTitle:@"我的好友"];
    }
    [self.view bringSubviewToFront:_rightButton];
    _searchView.layer.masksToBounds = YES;
    _searchView.layer.cornerRadius = 3;
    _searchListArray = [NSMutableArray array];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.friendsListArray = [NSMutableArray array];
    [self beginUserFriendsRequest];
}

- (void)beginUserFriendsRequest
{
    __weak typeof(self) weakSelf = self;
    [[UserManager sharedUserManager] userIdWithLoginBlock:^(NSString *userId, NSString *ssoToken){
        typeof(weakSelf) strongSelf = weakSelf;
        NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
        [paramDict setObject:SZINDEX_USER_FRIENDS_METHOD forKey:PARAMS_METHOD_KEY];
        [paramDict setObject:userId forKey:PARAMS_USER_ID];
        NSLog(@"paramDict is %@",paramDict);
        [SZUserFriendsRequest requestWithParameters:paramDict withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
            NSLog(@"start loading");
            [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
        } onRequestFinished:^(ITTBaseDataRequest *request) {
            if (request.isSuccess) {
                NSArray *listsArray = [request.handleredResult objectForKey:@"listsArray"];
                if(listsArray && [listsArray isKindOfClass:[NSArray class]]){
                    NSLog(@"listsArray is %@",listsArray);
                    [strongSelf setFriendsListDataWithArray:listsArray];
                }
            }
        } onRequestCanceled:^(ITTBaseDataRequest *request) {
        } onRequestFailed:^(ITTBaseDataRequest *request) {
            
        }];
    }];
}

- (BOOL)isIndexAlphaExist:(NSString *)string InArray:(NSArray *)array
{
    if(array && [array isKindOfClass:[NSArray class]]){
        int arrayCount = [array count];
        for(int i=0;i<arrayCount;i++){
            if([[array objectAtIndex:i] isEqualToString:string]){
                return YES;
            }
        }
    }
    return NO;
}

- (void)setUserNameHeadData:(NSMutableArray *)indexArray ListArray:(NSArray *)listArray
{
    int indexCount = [indexArray count];
    NSLog(@"indexCount is %d",indexCount);
    for(int i =0;i<indexCount;i++){
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:[indexArray objectAtIndex:i],INDEX_SOURCE, nil];
        [_friendsListArray addObject:dictionary];
    }
    [self setUserNameDetailData:listArray];
}

- (void)setUserNameDetailData:(NSArray *)listArray
{
    int friendsCount = [_friendsListArray count];
    for(int i=0;i<friendsCount;i++){
        NSMutableArray *detailArray = [NSMutableArray array];
        NSMutableDictionary *dataIndexDic = [_friendsListArray objectAtIndex:i];
        int listCount = [listArray count];
        for(int j=0;j<listCount;j++){
            SZUserFriendsModel *model = [listArray objectAtIndex:j];
            if([model.first_letter isEqualToString:[dataIndexDic objectForKey:INDEX_SOURCE]]){
                [detailArray addObject:model];
            }
        }
        [dataIndexDic setObject:detailArray forKey:DATA_SOURCE];
    }
    [self sortUserNameDataArray];
}

- (void)sortUserNameDataArray
{
    NSDictionary *jingHaoDic = nil;
    int friendsCount = [_friendsListArray count];
    for (int i = 0 ; i < friendsCount; i++) {
        if ([[[_friendsListArray objectAtIndex:i] objectForKey:INDEX_SOURCE] isEqualToString:@"#"]) {
            jingHaoDic = [NSDictionary dictionaryWithDictionary:[_friendsListArray objectAtIndex:i]];
            [_friendsListArray removeObjectAtIndex:i];
            break;
        }
    }
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:INDEX_SOURCE ascending:YES];
    NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sorter count:1];
    NSMutableArray *sortedArray = [[_friendsListArray sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    if(jingHaoDic){
        [sortedArray addObject:jingHaoDic];
    }
    [_friendsListArray removeAllObjects];
    [_friendsListArray addObjectsFromArray:sortedArray];
    NSLog(@"friendsCount is %d",[_friendsListArray count]);
    [self computeLimitIndexAndY];
    [self addIndexListView];
}

- (void)setFriendsListDataWithArray:(NSArray *)listArray
{
    NSMutableArray *indexArray = [NSMutableArray array];
    int listCount = [listArray count];
    for(int i=0;i<listCount;i++){
        SZUserFriendsModel *model = [listArray objectAtIndex:i];
        model.first_letter = [model.first_letter uppercaseString];
        NSString *first_letter = model.first_letter;
        BOOL isExist = [self isIndexAlphaExist:first_letter InArray:indexArray];
        if(!isExist){
            [indexArray addObject:first_letter];
        }
    }
    [self setUserNameHeadData:indexArray ListArray:listArray];
//    [self setUserNameDetailData:listArray];
}

- (void)computeLimitIndexAndY
{
    CGFloat height = _tableView.height;
    CGFloat limit = 0;
    int count = [_friendsListArray count];
    for(int i=count-1;i>0;i--){
        NSMutableDictionary * dict = [_friendsListArray objectAtIndex:i];
        NSMutableArray * arr = [dict objectForKey:DATA_SOURCE];
        int cou = [arr count];
        limit+=HEADER_VIEW_HEIGHT;
        limit+=cou*CELL_VIEW_HEIGHT;
        if(limit>=height){
            _limitIndex = i;
            break;
        }
    }
    
    CGFloat y = 0;
    for(int i=0;i<_limitIndex;i++){
        NSMutableDictionary * dict = [_friendsListArray objectAtIndex:i];
        NSMutableArray * arr = [dict objectForKey:DATA_SOURCE];
        int con = [arr count];
        y+=HEADER_VIEW_HEIGHT;
        y+=con*CELL_VIEW_HEIGHT;
    }
    _limitY = y;
}

- (void)addIndexListView
{
    _indexListView = [SZIndexListView loadFromXib];
    _indexListView.top = 45;
    _indexListView.left = 288;
    _indexListView.delegate = self;
    [_backgroundView addSubview:_indexListView];
    [_tableView reloadData];
}

- (void)indexListViewDidSelectIndex:(int)index Content:(NSString *)content
{
    if(!_isSearching){
        NSLog(@"index is %d,content is %@",index,content);
        if(index == 0){
            _tableView.contentOffset = CGPointMake(0, 0);
            return;
        }
        int count = [_friendsListArray count];
        for(int i=0;i<count;i++){
            NSMutableDictionary * dict = [_friendsListArray objectAtIndex:i];
            NSString * indexString = [dict objectForKey:INDEX_SOURCE];
            if([indexString isEqualToString:content]){
                if(i>=_limitIndex){
                    _tableView.contentOffset = CGPointMake(0, _limitY);
                }
                else{
                    CGFloat y = 0;
                    for(int j=0;j<i;j++){
                        NSMutableDictionary * diction = [_friendsListArray objectAtIndex:j];
                        NSMutableArray * arr = [diction objectForKey:DATA_SOURCE];
                        int con = [arr count];
                        y+=HEADER_VIEW_HEIGHT;
                        y+=con*CELL_VIEW_HEIGHT;
                    }
                    _tableView.contentOffset = CGPointMake(0, y);
                }
                return;
            }
        }
    }
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
        int count = [_friendsListArray count];
        for(int i=0;i<count;i++){
            NSMutableDictionary *dictionary = [_friendsListArray objectAtIndex:i];
            NSMutableArray *searchArray = [NSMutableArray array];
            int arrayCount = [[dictionary objectForKey:DATA_SOURCE] count];
            for(int j=0;j<arrayCount;j++){
                SZUserFriendsModel *model = [[dictionary objectForKey:DATA_SOURCE] objectAtIndex:j];
                NSRange rangeRoad=[model.real_name rangeOfString:searchContent options:NSCaseInsensitiveSearch];
                if(rangeRoad.length>0){
                    [searchArray addObject:model];
                }
            }
            NSLog(@"searchArray is %@",searchArray);
            if([searchArray count]){
                NSMutableDictionary *oneDiction = [NSMutableDictionary dictionary];
                [oneDiction setObject:searchArray forKey:DATA_SOURCE];
                [oneDiction setObject:[dictionary objectForKey:INDEX_SOURCE] forKey:INDEX_SOURCE];
                [_searchListArray addObject:oneDiction];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(_isSearching){
        _noDataLabel.hidden = YES;
        return [_searchListArray count];
    }
    else{
        int count = [_friendsListArray count];
        if(count == 0){
            _noDataLabel.hidden = NO;
        }
        else{
            _noDataLabel.hidden = YES;
        }
        return count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableDictionary * dict;
    if(_isSearching){
        dict = [_searchListArray objectAtIndex:section];
    }
    else{
        dict = [_friendsListArray objectAtIndex:section];
    }
    NSMutableArray * arr = [dict objectForKey:DATA_SOURCE];
    NSLog(@"row count is %d",[arr count]);
    return [arr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEADER_VIEW_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_VIEW_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SZIndexHeaderView * headerView = [SZIndexHeaderView loadFromXib];
    NSMutableDictionary * dict;
    if(_isSearching){
        dict = [_searchListArray objectAtIndex:section];
    }
    else{
        dict = [_friendsListArray objectAtIndex:section];
    }
    headerView.indexLabel.text = [dict objectForKey:INDEX_SOURCE];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SZOneFriendCell";
    SZOneFriendCell *cell = (SZOneFriendCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil){
        cell = [SZOneFriendCell cellFromNib];
    }
    NSMutableDictionary * dict;
    if(_isSearching){
        dict = [_searchListArray objectAtIndex:indexPath.section];
    }
    else{
        dict = [_friendsListArray objectAtIndex:indexPath.section];
    }
    NSMutableArray * arr = [dict objectForKey:DATA_SOURCE];
    [cell getDataSourceFromModel:[arr objectAtIndex:indexPath.row]];
    cell.ifSearch = _isSearching;
    cell.delegate = self;
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)oneFriendCellFinishDeletePhone:(NSString *)phone ifSearch:(BOOL)ifSearch
{
    if(ifSearch){
        int searchListCount = [_searchListArray count];
        for(int i=0;i<searchListCount;i++){
            NSMutableDictionary *dict = [_searchListArray objectAtIndex:i];
            NSMutableArray * arr = [dict objectForKey:DATA_SOURCE];
            int arrCount = [arr count];
            for(int j=0;j<arrCount;j++){
                SZUserFriendsModel *model = [arr objectAtIndex:j];
                if([model.mobile isEqualToString:phone]){
                    [arr removeObject:model];
                    break;
                }
            }
            if([arr count] == 0){
                [_searchListArray removeObject:dict];
                break;
            }
        }
    }
    int friendListCount = [_friendsListArray count];
    for(int i=0;i<friendListCount;i++){
        NSMutableDictionary *dict = [_friendsListArray objectAtIndex:i];
        NSMutableArray * arr = [dict objectForKey:DATA_SOURCE];
        int arrCount = [arr count];
        for(int j=0;j<arrCount;j++){
            SZUserFriendsModel *model = [arr objectAtIndex:j];
            if([model.mobile isEqualToString:phone]){
                [arr removeObject:model];
                break;
            }
        }
        if([arr count] == 0){
            [_friendsListArray removeObject:dict];
            break;
        }
    }
    
    [_tableView reloadData];
    
    
    if(IS_STRING_NOT_EMPTY(_friendsCount) && ![_friendsCount isEqualToString:@"0"] && ![_friendsCount isEqualToString:@"1"]){
        [self setTitle:[NSString stringWithFormat:@"我的好友(%d)",[_friendsCount intValue]-1]];
    }else{
        [self setTitle:@"我的好友"];
    }
    
}

- (IBAction)onRightButtonClicked:(id)sender
{
    SZMyAddressListViewController *addressListViewController = [[SZMyAddressListViewController alloc] initWithNibName:@"SZMyAddressListViewController" bundle:nil];
    [self pushMasterViewController:addressListViewController];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary * dict;
    if(_isSearching){
        dict = [_searchListArray objectAtIndex:indexPath.section];
    }
    else{
        dict = [_friendsListArray objectAtIndex:indexPath.section];
    }
    NSMutableArray * arr = [dict objectForKey:DATA_SOURCE];
    SZUserFriendsModel *model = [arr objectAtIndex:indexPath.row];
    SZPersonalDynamicViewController *personalDynamicViewController = [[SZPersonalDynamicViewController alloc] initWithNibName:@"SZPersonalDynamicViewController" bundle:nil];
    personalDynamicViewController.name = model.real_name;
    [personalDynamicViewController setupUrlWithUserId:model.user_id isFriend:YES];
    [self pushMasterViewController:personalDynamicViewController];
}

@end






