//
//  UserManager.h
//  iTotemFramework
//
//  Created by Grant on 14-4-14.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//
#import "INTULocationManager.h"
#define kOnlyShowImageOnWifiSwitchOff @"kOnlyShowImageOnWifiSwitchOff"

typedef void(^GTLocationRequestBlock)(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, BOOL isSuccess);
extern NSString *const validationSecondNotificationName;
typedef NS_ENUM(NSUInteger, USER_GENDER)
{
    USER_GENDER_UNKNOWN = 0,
    USER_GENDER_MALE,
    USER_GENDER_FEMALE,
};

/*
typedef NS_ENUM(NSUInteger, SM_ATTENDACE_TYPE){
    SM_ATTENDACE_TYPE_REG = 0,
    SM_ATTENDACE_TYPE_LEAVE,
    SM_ATTENDACE_TYPE_AUDIT_REG,
    SM_ATTENDACE_TYPE_AUDIT_LEAVE
};
 */



@interface UserManager : NSObject
@property (readonly, nonatomic) NSInteger validationSecond;
@property (readonly, nonatomic) NSString *userId;
@property (readonly, nonatomic) NSString *mobileNum;
@property (readonly, nonatomic) NSString *realName;//现在与电话号码一致
@property (readonly, nonatomic) NSString *gender;
@property (readonly, nonatomic) NSString *portraitUrl;
@property (strong, nonatomic) NSString *apnsId;//推送消息设备号
@property (nonatomic, copy)     NSString *suggestCityCode;//成焱－添加，用来识别当前用户在本地还是异地
@property (readonly, nonatomic) NSString *groupCode;
@property (readonly, nonatomic) NSString *groupName;
@property (readonly, nonatomic) NSString *groupType;
@property (readonly, nonatomic) NSString *deptCode;
@property (readonly, nonatomic) NSString *deptName;

@property (strong, nonatomic) NSData *wasteImageData;

@property (strong, nonatomic) NSString *news;

@property (strong, nonatomic) NSArray *docCatalog;
@property (strong, nonatomic) NSArray *docUrls;

@property (readwrite, nonatomic) BOOL onlyShowImageOnWifi;
@property (readwrite, nonatomic) BOOL needNotificaionMsg;

@property (readwrite, nonatomic) BOOL needRefreshHomeViewHis;

@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSArray *wasteTypeArray;


- (NSString *)newsCode;
-(Boolean) isNewsType:(NSString *)newscode;
-(Boolean) isNoticeType:(NSString *)newscode;

- (NSString *)cityCode;
- (void)setCityCode:(NSString *)cityCode;
- (NSString *)getCityNameWithCode:(NSString *)cityCode;

- (BOOL)isFirstOpenForViewControllerClass:(Class)aClass;
- (NSString *)ssoTokenWithUserId:(NSString *)userId;
- (void)userIdWithLoginBlock:(void(^)(NSString *userId, NSString *ssoToken))block;
+ (void)didFinishLoginWithviewController:(UIViewController *)viewController;
- (BOOL)isLogin;
+ (UserManager *)sharedUserManager;
- (void)getCurrentLocationWithBlock:(GTLocationRequestBlock)block;
- (void)startValidationCodeTimer;
- (BOOL)isOnTimer;
- (void)storeUserInfoWithUserId:(NSString *)userId
                       realName:(NSString *)realName
                         gender:(NSString *)gender
                    portraitUrl:(NSString *)portraitUrl
                       ssoToken:(NSString *)ssoToken
                       deptname:(NSString *)deptname
                          roles:(NSString *)roles;
- (void)storeUserInfoWithMobileNum:(NSString *)mobileNum;
- (void)storeUserInfoWithRealName:(NSString *)realName;
- (void)storeUserInfoWithGender:(NSString *)gender;
- (void)storeUserInfoWithPortraitUrl:(NSString *)portraitUrl;
- (void)storeUserInfoWithRoles:(NSString *)roles;
- (void)storeUserInfoWithDeptname:(NSString *)deptname;
- (void)storeUserInfoWithDeptcode:(NSString *)deptcode;
- (void)storeUserInfoWithGroupCode:(NSString *)groupCode;
- (void)storeUserInfoWithGroupName:(NSString *)groupName;
- (void)storeUserInfoWithGroupType:(NSString *)groupType;
- (void)logout;

- (void)showWifiAlert;

-(BOOL) isAttendRegType;
-(BOOL) isAttendLeaveType;
-(BOOL) isAttendAuditRegType;
-(BOOL) isAttendAuditLeaveType;
-(void) setAttendType:(int)type;
-(int) attendType;

-(void) setReportType:(int)type;
 

-(void) setReportNeedtoRefresh:(BOOL)refresh;
-(BOOL) reportNeedtoRefresh;


-(NSArray*)addHomeViewHis:(NSString*)file;
-(BOOL)homeViewHisChanged;
-(void)setHomeViewHisChanged:(BOOL)changed;
-(NSArray*)getDocFileWithLayer:(int)layer filter:(NSString*) parent inPath:(NSString*)inpath;
-(NSArray*)getDocCatalogWithLayer:(int)layer filter:(NSString*)parent inPath:(NSString*)inpath;
-(NSArray*)getDocFileWithKeyword:(NSString*)keyword;
-(NSString*)formatDisplayTitle:(NSString*)title;


-(int)getIntWithKey:(NSString*)key;
-(void)setInt:(int)value withKey:(NSString*)key;
-(NSString*)getStringWithKey:(NSString*)key;
-(void)setString:(NSString*)value withKey:(NSString*)key;

@end
