//
//  WWGroupSetViewController.m
//  com.knowesoft.weifei
//
//  Created by Golun on 2015-03-18.
//  Copyright (c) 2015年 Knowesoft. All rights reserved.
//

#import "WWGroupSetViewController.h"
#import "ITTRefreshTableHeaderView.h"
#import "WWGroupItemModel.h"
#import "WWGroupDataRequest.h"
#import "WWGroupItemCell.h"
#import "ChineseToPinyin.h"

@interface WWGroupSetViewController ()
<
UITableViewDataSource,UITableViewDelegate,
ITTRefreshTableHeaderDelegate
,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) ITTRefreshTableHeaderView *refreshView;
@property (nonatomic, strong) NSMutableArray *preferentialCellArray;
@property (nonatomic, strong) NSArray *groupArray;
@property (nonatomic,readwrite) BOOL pullTableIsRefreshing;

@end

@implementation WWGroupSetViewController
{
    NSMutableDictionary *_groupDictionary;
    NSMutableArray *_titleArray;
    NSString *orgCode;
}

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
    
    [self setTitle:@"选择单位"];
    
    [self setTopViewBackgroundColor:[UIColor whiteColor]];
    _preferentialCellArray = [NSMutableArray array];
    [self setupRefrashHeader];
    
    if (IS_IOS_7){
        _tableView.top += 20;
        _tableView.height += 20;
    }
    
    [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
    
    [self startRefrash];
}

-(void)viewWillAppear:(BOOL)animated
{
    _scrollView.top = [[ self baseTopView] height] + 20;
    _scrollView.height = self.view.height - _scrollView.top;
    _scrollView.left = 180;
    [_scrollView setHidden:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)startRefrash
{
    NSDictionary *params = @{
                             @"parent_code":@""
                            };
    
    ITTDINFO(@"request params :[%@]" ,params);
    
    __weak typeof(self) weakSelf = self;
    [WWGroupDataRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
            [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
    } onRequestFinished:^(ITTBaseDataRequest *request) {
        if (request.isSuccess){
            weakSelf.pullTableIsRefreshing = NO;
            //typeof(weakSelf) strongSelf = weakSelf;
            
            NSMutableArray *dataArray = [NSMutableArray array];
            NSArray *list = request.handleredResult[@"list"];
            for (int i = 0; i < [list count]; i++) {
                NSDictionary *data = [list objectAtIndex:i];
                WWGroupItemModel *newsModel = [[WWGroupItemModel alloc] initWithDataDic:data];
                [dataArray addObject:newsModel];
            }
            
            [weakSelf setGroupListData:dataArray];
        }
        [_refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.scrollView];
        
        //不用处理 isSuccess 为 NO 的情况
    } onRequestCanceled:^(ITTBaseDataRequest *request) {
        [_refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.scrollView];
        self.pullTableIsRefreshing = NO;
    } onRequestFailed:^(ITTBaseDataRequest *request) {
        [_refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.scrollView];
        self.pullTableIsRefreshing = NO;
    }];
}

-(void)loadChildGroupList:(NSString *)code
{
    NSDictionary *params = @{
                             @"parent_code":code
                             };
    
    ITTDINFO(@"request params :[%@]" ,params);
    
    __weak typeof(self) weakSelf = self;
    [WWGroupDataRequest requestWithParameters:params withIndicatorView:nil withCancelSubject:nil onRequestStart:^(ITTBaseDataRequest *request) {
        [PROMPT_VIEW showActivityWithMask:@"数据载入中"];
    } onRequestFinished:^(ITTBaseDataRequest *request) {
        if (request.isSuccess){
            weakSelf.pullTableIsRefreshing = NO;
            //typeof(weakSelf) strongSelf = weakSelf;
            
            NSMutableArray *dataArray = [NSMutableArray array];
            NSArray *list = request.handleredResult[@"list"];
            for (int i = 0; i < [list count]; i++) {
                NSDictionary *data = [list objectAtIndex:i];
                WWGroupItemModel *newsModel = [[WWGroupItemModel alloc] initWithDataDic:data];
                newsModel.orgCode = newsModel.depCode;
                newsModel.orgName = newsModel.depName;
                [dataArray addObject:newsModel];
            }
            
            [weakSelf setChildGroupListData:dataArray];
        }
        [_refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.scrollView];
        
        //不用处理 isSuccess 为 NO 的情况
    } onRequestCanceled:^(ITTBaseDataRequest *request) {
        [_refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.scrollView];
        self.pullTableIsRefreshing = NO;
    } onRequestFailed:^(ITTBaseDataRequest *request) {
        [_refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.scrollView];
        self.pullTableIsRefreshing = NO;
    }];
}


-(void)setGroupListData:(NSArray *)groupList
{
    [self doGroupWithArray:groupList];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView reloadData];
}

-(void)setChildGroupListData:(NSArray *)groupList
{
    [_preferentialCellArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat curTop = 10;
    for (WWGroupItemModel *newsModel in groupList) {
        WWGroupItemCell *cell = [WWGroupItemCell cellFromNib];
        [cell showGroupCellWithFinishBlock:^(WWGroupItemModel *model) {
            [self selectItemEvent:model];
        } data:newsModel];
        //[cell getDataSourceFromModel:newsModel];
        [_preferentialCellArray addObject:cell];
        cell.top = curTop,curTop+=cell.height;
        [_scrollView addSubview:cell];
    }
    
    WWGroupItemModel *noneDW = [[WWGroupItemModel alloc] init];
    noneDW.orgName = @"暂无可选单位";
    noneDW.orgCode = @"-1";
    WWGroupItemCell *cell = [WWGroupItemCell cellFromNib];
    [cell showGroupCellWithFinishBlock:^(WWGroupItemModel *model) {
        [self selectItemEvent:model];
    } data:noneDW];
    //[cell getDataSourceFromModel:newsModel];
    [_preferentialCellArray addObject:cell];
    cell.top = curTop,curTop+=cell.height;
    [_scrollView addSubview:cell];
    
    _scrollView.contentSize = CGSizeMake(self.view.width - 140, self.view.height);
    //[_scrollView setBackgroundColor:[UIColor blueColor]];
    [_scrollView setLeft:120];
    [_scrollView setWidth:self.view.width - 120];

    [_scrollView setHidden:NO];
}


-(void)selectItemEvent:(WWGroupItemModel*) model
{
    NSLog(@"select item: %@", model);
    if ([model.orgCode isEqualToString:@"-1"]){
        [[UserManager sharedUserManager] storeUserInfoWithDeptcode:@""];
        [[UserManager sharedUserManager] storeUserInfoWithDeptname:@""];
    }
    else{
        [[UserManager sharedUserManager] storeUserInfoWithDeptcode:model.orgCode];
        [[UserManager sharedUserManager] storeUserInfoWithDeptname:model.orgName];
    }
    
    [self baseTopViewBackButtonClicked];
}

//---table view----------------------

// group with array(*a-z#)
- (void)doGroupWithArray:(NSArray *)groupList
{
    if (!_groupDictionary) {
        _groupDictionary = [[NSMutableDictionary alloc]init];
    }
    [_groupDictionary removeAllObjects];
    
    if (!_titleArray) {
        _titleArray = [[NSMutableArray alloc]init];
    }
    [_titleArray removeAllObjects];
    //    [_titleArray addObject:UITableViewIndexSearch];
    
    //add a-z to group
    NSInteger A = 65;//A
    char word[1];
    NSMutableArray *specialArray = [[NSMutableArray alloc] initWithArray:groupList];
    for (NSInteger i = 0; i < 26; i++){
        word[0] = (char)(A + i);
        NSString *wordString=[NSString stringWithFormat:@"%c",word[0]];
        NSMutableArray *groupArray = [[NSMutableArray alloc]init];
        for (NSInteger i=0; i<groupList.count; i++) {
            
            WWGroupItemModel *item = [groupList objectAtIndex:i];
            NSString *name = item.orgName;
            NSString *pinyin = [ChineseToPinyin pinyinFromChineseString:name];
            if (!pinyin || pinyin.length == 0){
                pinyin = @"#";
            }
            item.pinyin = pinyin;
            if (pinyin&&wordString&&pinyin&&[wordString isEqualToString: [pinyin substringToIndex:1]] ) {
                [groupArray addObject:item];
                [specialArray removeObject:item];
            }
            
        }
        if (groupArray.count>0 && wordString) {
            [_titleArray addObject: wordString];
            [_groupDictionary setObject:groupArray forKey:wordString];
        }
        //[groupArray release];
    }
    //add special word to group
    if (specialArray.count>0) {
        [_titleArray addObject:@"#"];
        [_groupDictionary setObject:specialArray forKey:@"#"];
    }
    // [specialArray release];
}



//----end of table view -------------




#pragma mark - 下拉刷新
- (void)setupRefrashHeader
{
    self.scrollView.delegate = self;
    /* Refresh View */
    _refreshView = [[ITTRefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -self.scrollView.bounds.size.height, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height)];
    _refreshView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    _refreshView.delegate = self;
    [self.scrollView addSubview:_refreshView];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    [_refreshView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_refreshView egoRefreshScrollViewWillBeginDragging:scrollView];
}

/*
 *set Load more view hidden
 */

- (void)setRefreshViewHidden:(BOOL)isHidden
{
    if (isHidden)
        [_refreshView removeFromSuperview];
    else
        [self.scrollView addSubview:_refreshView];
}

#pragma mark - EGORefreshTableHeaderDelegate

- (void)egoRefreshTableHeaderDidTriggerRefresh:(ITTRefreshTableHeaderView*)view
{
    self.pullTableIsRefreshing = YES;
    [_refreshView startAnimatingWithScrollView:self.scrollView];
    [self loadChildGroupList:orgCode];
    
}


#pragma mark - Table view data source

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *city = [_titleArray objectAtIndex:indexPath.section];
    WWGroupItemModel *model = [[_groupDictionary objectForKey:city] objectAtIndex:indexPath.row];
    
    [[UserManager sharedUserManager] storeUserInfoWithGroupCode:model.orgCode];
    [[UserManager sharedUserManager] storeUserInfoWithGroupName:model.orgName];
    [[UserManager sharedUserManager] storeUserInfoWithGroupType:model.groupType];
    [[UserManager sharedUserManager] storeUserInfoWithRoles:model.groupType];
    [[UserManager sharedUserManager] storeUserInfoWithDeptcode:@""];
    [[UserManager sharedUserManager] storeUserInfoWithDeptname:@""];

    //city = model.name;
    //city = [city stringByReplacingOccurrencesOfString:@" " withString:@""];
    orgCode = model.orgCode;
    [self loadChildGroupList:model.orgCode];
    //[self selectItemEvent:model];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *title = [_titleArray objectAtIndex:section];
    if ([title length] == 0){
        title = @"全部";
    }
    NSArray *items = [_groupDictionary objectForKey:title];
    return items.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_titleArray objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cityPickerCellIdentifier = @"cityPickerCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cityPickerCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cityPickerCellIdentifier];
    }
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    //cell.textLabel.text = ((CityInfoModel*)dataArray[indexPath.row]).nickname;
    
    NSString *title =  [_titleArray objectAtIndex:indexPath.section];
    NSArray *items = [_groupDictionary objectForKey:title];
    
    NSLog(@"%@",@(indexPath.row));
    cell.textLabel.text = ((WWGroupItemModel*)items[indexPath.row]).orgName;
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return  _titleArray;
}


@end
