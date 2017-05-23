//
//  SZCustomPickerView.m
//  iTotemFramework
//
//  Created by 王琦 on 14-4-16.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZCustomPickerView.h"

#define SOURCE_VALUE @"SOURCE_VALUE"
#define SOURCE_KEY   @"SOURCE_KEY"

@interface SZCustomPickerView()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (strong, nonatomic) NSMutableArray *classificationArray;
@property (strong, nonatomic) NSMutableArray *distanceArray;
@property (strong, nonatomic) NSMutableArray *sortArray;
@property (strong, nonatomic) NSString * chooseString;
@property (assign, nonatomic) int searchCondition;
@property (assign, nonatomic) int currentRow;
@property (assign, nonatomic) BOOL outPlace;

- (IBAction)finishButtonClicked:(id)sender;
- (IBAction)cancleButtonClicked:(id)sender;

@end

@implementation SZCustomPickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if(_filterCondition==kTagFilterConditionClassification){
        return 2;
    }
    else{
        return 1;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(_filterCondition==kTagFilterConditionClassification){
        if(component == 0){
            return [_classificationArray count];
        }
        else{
            NSMutableDictionary * dict = [_classificationArray objectAtIndex:_currentRow];
            NSMutableArray * arr = [dict objectForKey:SOURCE_VALUE];
            return [arr count];
        }
    }
    else if(_filterCondition==kTagFilterConditionDistance){
        return [_distanceArray count];
    }
    else{
        return [_sortArray count];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 44;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(_filterCondition==kTagFilterConditionClassification){
        if(component == 0){
            NSMutableDictionary * dict = [_classificationArray objectAtIndex:row];
            return [dict objectForKey:SOURCE_KEY];
        }
        else{
            NSMutableDictionary * dict = [_classificationArray objectAtIndex:_currentRow];
            NSMutableArray * arr = [dict objectForKey:SOURCE_VALUE];
            return [arr objectAtIndex:row];
        }
    }
    else if(_filterCondition==kTagFilterConditionDistance){
        return [_distanceArray objectAtIndex:row];
    }
    else{
        return [_sortArray objectAtIndex:row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    BOOL needReload = NO;
    if(component == 0){
        if(_currentRow != row){
            _currentRow = row;
            needReload = YES;
        }
    }
    if(_filterCondition==kTagFilterConditionClassification){
        NSMutableDictionary * dict = [_classificationArray objectAtIndex:_currentRow];
        NSMutableArray * arr = [dict objectForKey:SOURCE_VALUE];
        NSLog(@"component is %d,row is %d,_currentRow is %d",component,row,_currentRow);
        if(component == 0){
            NSMutableDictionary*tempDic = [_classificationArray objectAtIndex:row];
            NSMutableArray *tempArr = [tempDic objectForKey:SOURCE_VALUE];
            _chooseString = [tempArr objectAtIndex:0];
        }
        else{
            _chooseString = [arr objectAtIndex:row];
        }
        NSLog(@"_chooseString didSelectRow is %@",_chooseString);
        if(needReload){
             [_pickerView reloadAllComponents];
             [_pickerView selectRow:0 inComponent:1 animated:NO];
             NSLog(@"_currentRow is %d",_currentRow);
        }
    }
    else if(_filterCondition==kTagFilterConditionDistance){
        _chooseString = [_distanceArray objectAtIndex:row];
    }
    else{
        _chooseString = [_sortArray objectAtIndex:row];
    }
    NSLog(@"component is %d,row is %d,_chooseString is %@",component,row,_chooseString);
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _pickerView.height = 216;
    
    _classificationArray = [NSMutableArray array];
    NSMutableArray * arr0 = [NSMutableArray arrayWithObjects:@"全部分类", nil];
    NSMutableDictionary * dic0 = [NSMutableDictionary dictionaryWithObjectsAndKeys:arr0,SOURCE_VALUE,@"全部分类",SOURCE_KEY,nil];
    NSMutableArray * arr1 = [NSMutableArray arrayWithObjects:@"全部美食",@"地方菜",@"火锅",@"海鲜",@"小吃快餐",@"日餐",@"韩国料理",@"西餐",@"自助餐",@"面包甜点",@"其他中餐", nil];
    NSMutableDictionary * dic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:arr1,SOURCE_VALUE,@"美食",SOURCE_KEY,nil];
    NSMutableArray * arr2 = [NSMutableArray arrayWithObjects:@"全部休闲娱乐",@"电影院",@"ktv",@"洗浴",@"足疗",@"美容美发",@"其他娱乐", nil];
    NSMutableDictionary * dic2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:arr2,SOURCE_VALUE,@"休闲娱乐",SOURCE_KEY,nil];
    NSMutableArray * arr3 = [NSMutableArray arrayWithObjects:@"全部生活服务",@"酒店",@"摄影",@"课程培训",@"其他服务", nil];
    NSMutableDictionary * dic3 = [NSMutableDictionary dictionaryWithObjectsAndKeys:arr3,SOURCE_VALUE,@"生活服务",SOURCE_KEY,nil];
    NSMutableArray *arr4 = [NSMutableArray arrayWithObjects:@"更多", nil];
    NSMutableDictionary *dic4 = [NSMutableDictionary dictionaryWithObjectsAndKeys:arr4,SOURCE_VALUE,@"更多",SOURCE_KEY, nil];
    [_classificationArray addObject:dic0];
    [_classificationArray addObject:dic1];
    [_classificationArray addObject:dic2];
    [_classificationArray addObject:dic3];
    [_classificationArray addObject:dic4];
    //
    _distanceArray = [NSMutableArray array];
    [_distanceArray addObject:@"全部距离"];
    [_distanceArray addObject:@"500米"];
    [_distanceArray addObject:@"1000米"];
    [_distanceArray addObject:@"2000米"];
    [_distanceArray addObject:@"5000米"];
    NSString *city = [[UserManager sharedUserManager] city];
    if([city isEqualToString:@"宿州"]){
        _currentPlace = kTagCurrentPlaceSuZhou;
        [_distanceArray addObject:@"宿州全部商圈"];
        [_distanceArray addObject:@"汴河路"];
        [_distanceArray addObject:@"小隅口"];
        [_distanceArray addObject:@"东昌路"];
        [_distanceArray addObject:@"两淮"];
        [_distanceArray addObject:@"火车站"];
        [_distanceArray addObject:@"淮海路"];
        [_distanceArray addObject:@"胜利路"];
        [_distanceArray addObject:@"西昌南路"];
        [_distanceArray addObject:@"汴河西路"];
        [_distanceArray addObject:@"老槐树"];
        [_distanceArray addObject:@"大学城"];
    }
    else if([city isEqualToString:@"唐山"]){
        _currentPlace = kTagCurrentPlaceTangShan;
        [_distanceArray addObject:@"唐山全部商圈"];
        [_distanceArray addObject:@"万达"];
        [_distanceArray addObject:@"远洋城"];
        [_distanceArray addObject:@"银泰百货"];
        [_distanceArray addObject:@"龙泽路"];
        [_distanceArray addObject:@"新街"];
        [_distanceArray addObject:@"鹭港"];
        [_distanceArray addObject:@"八方"];
        [_distanceArray addObject:@"长宁道"];
        [_distanceArray addObject:@"百货大楼"];
        [_distanceArray addObject:@"丰润新区"];
        [_distanceArray addObject:@"福乐园"];
        [_distanceArray addObject:@"南湖美食广场"];
        [_distanceArray addObject:@"唐人街"];
    }
    else{
        _currentPlace = kTagCurrentPlaceOther;
    }
    //
    _sortArray = [NSMutableArray array];
    [_sortArray addObject:@"默认排序"];
    [_sortArray addObject:@"人气"];
    [_sortArray addObject:@"距离最近"];
    [_sortArray addObject:@"评分"];
    
}

- (void)show
{
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    if (self.bottom != window.bottom) {
        self.top = window.bottom;
        [window addSubview:self];
        [UIView animateWithDuration:0.15 animations:^{
            self.bottom = window.bottom;
        }];
    }
}

- (void)hide
{

    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    self.bottom = window.bottom;
    [UIView animateWithDuration:0.15 animations:^{
        self.top = window.bottom;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)updateDataWithCondition:(int)filterCondition
{
//    [self hide];
    _currentRow = 0;
    _filterCondition = filterCondition;
    [_pickerView reloadAllComponents];
    [_pickerView selectRow:0 inComponent:0 animated:YES];
    if(_filterCondition==kTagFilterConditionClassification){
        NSMutableDictionary * dict = [_classificationArray objectAtIndex:0];
        NSMutableArray * arr = [dict objectForKey:SOURCE_VALUE];
        _chooseString = [arr objectAtIndex:0];
    }
    else if(_filterCondition==kTagFilterConditionDistance){
        _chooseString = [_distanceArray objectAtIndex:0];
    }
    else{
        _chooseString = [_sortArray objectAtIndex:0];
    }
    NSLog(@"_chooseString is %@",_chooseString);
    [self show];
}

- (void)updateDataWithCondition:(int)filterCondition outPlace:(BOOL)outPlace
{
    _outPlace = outPlace;
    if(_outPlace){
        _currentPlace = kTagCurrentPlaceOther;
        [_distanceArray removeAllObjects];
        [_distanceArray addObject:@"全部距离"];
        NSString *city = [[UserManager sharedUserManager] city];
        if([city isEqualToString:@"宿州"]){
            if([_distanceArray count] < 5){
                [_distanceArray removeAllObjects];
                [_distanceArray addObject:@"全部距离"];
                [_distanceArray addObject:@"宿州全部商圈"];
                [_distanceArray addObject:@"汴河路"];
                [_distanceArray addObject:@"小隅口"];
                [_distanceArray addObject:@"东昌路"];
                [_distanceArray addObject:@"两淮"];
                [_distanceArray addObject:@"火车站"];
                [_distanceArray addObject:@"淮海路"];
                [_distanceArray addObject:@"胜利路"];
                [_distanceArray addObject:@"西昌南路"];
                [_distanceArray addObject:@"汴河西路"];
                [_distanceArray addObject:@"老槐树"];
                [_distanceArray addObject:@"大学城"];
            }
        }
        else if([city isEqualToString:@"唐山"]){
            if([_distanceArray count] < 5){
                [_distanceArray removeAllObjects];
                [_distanceArray addObject:@"全部距离"];
                [_distanceArray addObject:@"唐山全部商圈"];
                [_distanceArray addObject:@"万达"];
                [_distanceArray addObject:@"远洋城"];
                [_distanceArray addObject:@"银泰百货"];
                [_distanceArray addObject:@"龙泽路"];
                [_distanceArray addObject:@"新街"];
                [_distanceArray addObject:@"鹭港"];
                [_distanceArray addObject:@"八方"];
                [_distanceArray addObject:@"长宁道"];
                [_distanceArray addObject:@"百货大楼"];
                [_distanceArray addObject:@"丰润新区"];
                [_distanceArray addObject:@"福乐园"];
                [_distanceArray addObject:@"南湖美食广场"];
                [_distanceArray addObject:@"唐人街"];
            }
        }
    }
    else{
        NSString *city = [[UserManager sharedUserManager] city];
        if([city isEqualToString:@"宿州"]){
            _currentPlace = kTagCurrentPlaceSuZhou;
            if([_distanceArray count] < 5){
                [_distanceArray removeAllObjects];
                [_distanceArray addObject:@"全部距离"];
                [_distanceArray addObject:@"500米"];
                [_distanceArray addObject:@"1000米"];
                [_distanceArray addObject:@"2000米"];
                [_distanceArray addObject:@"5000米"];
                [_distanceArray addObject:@"宿州全部商圈"];
                [_distanceArray addObject:@"汴河路"];
                [_distanceArray addObject:@"小隅口"];
                [_distanceArray addObject:@"东昌路"];
                [_distanceArray addObject:@"两淮"];
                [_distanceArray addObject:@"火车站"];
                [_distanceArray addObject:@"淮海路"];
                [_distanceArray addObject:@"胜利路"];
                [_distanceArray addObject:@"西昌南路"];
                [_distanceArray addObject:@"汴河西路"];
                [_distanceArray addObject:@"老槐树"];
                [_distanceArray addObject:@"大学城"];
            }
        }
        else if([city isEqualToString:@"唐山"]){
            _currentPlace = kTagCurrentPlaceTangShan;
            if([_distanceArray count] < 5){
                [_distanceArray removeAllObjects];
                [_distanceArray addObject:@"全部距离"];
                [_distanceArray addObject:@"500米"];
                [_distanceArray addObject:@"1000米"];
                [_distanceArray addObject:@"2000米"];
                [_distanceArray addObject:@"5000米"];
                [_distanceArray addObject:@"唐山全部商圈"];
                [_distanceArray addObject:@"万达"];
                [_distanceArray addObject:@"远洋城"];
                [_distanceArray addObject:@"银泰百货"];
                [_distanceArray addObject:@"龙泽路"];
                [_distanceArray addObject:@"新街"];
                [_distanceArray addObject:@"鹭港"];
                [_distanceArray addObject:@"八方"];
                [_distanceArray addObject:@"长宁道"];
                [_distanceArray addObject:@"百货大楼"];
                [_distanceArray addObject:@"丰润新区"];
                [_distanceArray addObject:@"福乐园"];
                [_distanceArray addObject:@"南湖美食广场"];
                [_distanceArray addObject:@"唐人街"];
            }
        }
        else{
            _currentPlace = kTagCurrentPlaceOther;
        }
    }
    
    [self updateDataWithCondition:filterCondition];
    
}

- (IBAction)finishButtonClicked:(id)sender
{
    [self hide];
    
    //searchcondition ??  id ??
    
    NSLog(@"_chooseString finishButtonClicked is %@",_chooseString);
    
    if(_filterCondition==kTagFilterConditionClassification){
        int count = [_classificationArray count];
        NSLog(@"count is %d",count);
        for(int i=0;i<count;i++){
            NSDictionary *diction = [_classificationArray objectAtIndex:i];
            NSArray *array = [diction objectForKey:SOURCE_VALUE];
            int coun = [array count];
            NSLog(@"coun is %d",coun);
            for(int j=0;j<coun;j++){
                
                if([_chooseString isEqualToString:[array objectAtIndex:j]]){
                    NSLog(@"i j in _classificationArray is %d,%d",i,j);
                    NSString *searchId;
                    if(i==0){
                        searchId = @"";
                    }
                    else if(i==1){
                        if(j==0){
                            searchId = @"11";
                        }
                        else{
                            searchId = [NSString stringWithFormat:@"%d",j+11];
                        }
                    }
                    else if(i==2){
                        if(j==0){
                            searchId = @"1";
                        }
                        else{
                            searchId = [NSString stringWithFormat:@"%d",j+21];
                        }
                    }
                    else if(i==3){
                        if(j==0){
                            searchId = @"2";
                        }
                        else{
                            searchId = [NSString stringWithFormat:@"%d",j+27];
                        }
                    }
                    else if(i==4){
                        searchId = @"-1";
                    }
                    if(_delegate && [_delegate respondsToSelector:@selector(pickViewSelectedString:Condition:SearchCondition:SearchId:)]){
                        [_delegate pickViewSelectedString:_chooseString Condition:_filterCondition SearchCondition:kTagSearchConditionCate SearchId:searchId];
                        return;
                    }
                    break;
                }
            }
        }
    }
    else if(_filterCondition==kTagFilterConditionDistance){
        int count = [_distanceArray count];
        for(int i=0;i<count;i++){
            NSString *stirng = [_distanceArray objectAtIndex:i];
            if([_chooseString isEqualToString:stirng]){
                NSLog(@"i in _distanceArray is %d",i);
                int searchCondition;
                NSString *searchId;
                if(!_outPlace){
                    if(i==0){
                        searchCondition = kTagSearchConditionRange;
                        searchId = @"";
                    }
                    else if(i==1){
                        searchCondition = kTagSearchConditionRange;
                        searchId = @"500";
                    }
                    else if(i==2){
                        searchCondition = kTagSearchConditionRange;
                        searchId = @"1000";
                    }
                    else if(i==3){
                        searchCondition = kTagSearchConditionRange;
                        searchId = @"2000";
                    }
                    else if(i==4){
                        searchCondition = kTagSearchConditionRange;
                        searchId = @"5000";
                    }
                    else if(i==5){
                        searchCondition = kTagSearchConditionArea;
                        searchId = @"";
                    }
                    else{
                        if(_currentPlace == kTagCurrentPlaceSuZhou){
                            searchCondition = kTagSearchConditionArea;
                            searchId = [NSString stringWithFormat:@"%d",i-5];
                        }
                        else if(_currentPlace == kTagCurrentPlaceTangShan){
                            searchCondition = kTagSearchConditionArea;
                            searchId = [NSString stringWithFormat:@"%d",i-6+50];
                        }
                        else{
                            searchCondition = kTagSearchConditionArea;
                            searchId = @"";
                        }
                    }
                }
                else{
                    if(i==0){
                        searchCondition = kTagSearchConditionRange;
                        searchId = @"";
                    }
                    else if(i==1){
                        searchCondition = kTagSearchConditionArea;
                        searchId = @"";
                    }else{
                        searchCondition = kTagSearchConditionArea;
                        NSString *cityCode = [[UserManager sharedUserManager]cityCode];
                        if ([cityCode isEqualToString:@"sz"]) {
                            searchId = [NSString stringWithFormat:@"%d",i-1];
                        }else if ([cityCode isEqualToString:@"ts"]){
                            searchId = [NSString stringWithFormat:@"%d",i-2+50];
                        }
                    }
                }
                NSLog(@"searchId is %@",searchId);
                if(_delegate && [_delegate respondsToSelector:@selector(pickViewSelectedString:Condition:SearchCondition:SearchId:)]){
                    [_delegate pickViewSelectedString:_chooseString Condition:_filterCondition SearchCondition:searchCondition SearchId:searchId];
                    return;
                }
                break;
            }
        }
    }
    else{
        int count = [_sortArray count];
        for(int i=0;i<count;i++){
            NSString *stirng = [_sortArray objectAtIndex:i];
            if([_chooseString isEqualToString:stirng]){
                NSLog(@"i in _sortArray is %d",i);
                if(_delegate && [_delegate respondsToSelector:@selector(pickViewSelectedString:Condition:SearchCondition:SearchId:)]){
                    [_delegate pickViewSelectedString:_chooseString Condition:_filterCondition SearchCondition:kTagSearchConditionSort SearchId:[NSString stringWithFormat:@"%d",i+1]];
                    return;
                }
                break;
            }
        }
    }
    
}

- (IBAction)cancleButtonClicked:(id)sender
{
    [self hide];
}

@end






