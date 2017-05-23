//
//  CONSTS.h
//  Hupan
//
//  Copyright 2010 iTotem Studio. All rights reserved.
//


#define REQUEST_DOMAIN @"http://cx.itotemstudio.com/api.php" // default env

//text
#define TEXT_LOAD_MORE_NORMAL_STATE @"向上拉动加载更多..."
#define TEXT_LOAD_MORE_LOADING_STATE @"更多数据加载中..."

#define APP_KEY         @"1"
#define APP_SECRET      @"5hVrCyuUXJQroBwz5hRgA6pY6NIMSQRQ8xjTjBQoGmwUMwMKIQ=="
#define APP_SECRET_KEY  @"app_key"
#define TOKEN_KEY       @"token" 

//请求超时时间
#define REQUEST_TIMEOUT_SECONDS 15


//other consts
typedef enum : NSUInteger{
	kTagWindowIndicatorView = 501,
	kTagWindowIndicator,
} WindowSubViewTag;

typedef enum : NSUInteger{
    kTagHintView = 101
} HintViewTag;

typedef enum{
    kTagFilterConditionClassification = 201,
    kTagFilterConditionDistance,
    kTagFilterConditionSort,
} FilterConditionTag;

typedef enum{
    kTagSearchConditionCate = 901,
    kTagSearchConditionRange,
    kTagSearchConditionArea,
    kTagSearchConditionSort,
} SearchConditionTag;

typedef enum{
    kTagMineOneChoiceUserDynamic = 301,
    kTagMineOneChoiceCoupon,
    kTagMineOneChoiceMembershipCard,
    kTagMineOneChoiceSave,
    kTagMineOneChoiceComment,
    kTagMineOneChoiceHistory,
    kTagMineOneChoiceFriends,
    kTagMineOneChoiceCircle,
    kTagMineOneChoiceDimensionCode,
} MineOneChoiceTag;

typedef enum{
    kTagCurrentUserSexMan = 401,
    kTagCurrentUserSexWoman,
    kTagCurrentUserSexSecret,
} CurrentUserSexTag;

typedef enum{
    kTagCurrentPlaceSuZhou = 701,
    kTagCurrentPlaceTangShan,
    kTagCurrentPlaceOther,
} CurrenPlaceTag;

//add by cheng yan
typedef NS_ENUM(NSUInteger, SZNearByPageFrom){
    SZNearByPageFromDefault = 0,
    SZNearByPageFromSearch,
    SZNearByPageFromFood,
    SZNearByPageFromPlay,
    SZNearByPageFromLife,
    SZNearByPageFromMore,
};



//KaoQin type Tag
typedef enum{
    kTagKaoQinOneChoiceMyReg = 101,
    kTagKaoQinOneChoiceMyLeave,
    kTagKaoQinOneChoiceAuditReg,
    kTagKaoQinOneChoiceAuditLeave,
    kTagKaoQinOneChoiceMyTx,
    kTagKaoQinOneChoiceAuditTx,
} KaoQinOneChoiceTag;

//KaoQin batch audit type
typedef enum{
    kTagKaoQinBatchAuditOperNormal = 0,
    ktagkaoqinBatchAuditOperCancel,
    ktagkaoqinBatchAuditOper,
} KaoQinBatchAuditType;


//Report type Tag
typedef enum {
    kTagReportOneChoiceRB = 200,
    kTagReportOneChoiceZB,
    kTagReportOneChoiceYB,
    kTagReportOneChoiceWork,
    kTagReportOneChoiceGoon,
    kTagReportOneChoiceAuditRB,
    kTagReportOneChoiceAuditZB,
    kTagReportOneChoiceAuditYB,
} ReportChoiceTag;

//Pick View tag
typedef enum{
    kTagKaoQinPickViewTx = 6000,
    kTagKaoQinPickViewAuditTx,
} PickViewTag;


typedef enum{
    kCellAddNew = 3000,
    kCellEdit,
} SMOnButtonCellOperType;


typedef enum {
    kPackageBoxNone = -1,
    kPackageBoxActive = 0,
    kPackageBoxBinded = 2,
    kPackageBoxFreeze = 3,
    kPackageBoxDestory = 99,
} WWPackageBoxStatus;



#pragma mark - framework demo

#define PAGE_COUNT 10
#define KEY_APPLICATION                         @"KEY_APPLICATION"
#define APPLICATION_LIST_REQUEST_CANCEL_SUBJECT @"APPLICATION_LIST_REQUEST_CANCEL_SUBJECT"
#define KEY_VERSION                             @"KEY_VERSION"

#define APP_DOWNLOAD_URL              @"http://www.knowesoft.com/oax_download.html"
#define APP_APPLE_DOWNLOAD_URL        @"https://itunes.apple.com/us/app/knowesoft-oax/id886453563?ls=1&mt=8"
#define APP_ID                  @"886453563"
#define PROMPT_VIEW             [ITTPromptView sharedPromptView]

#define UIColorBlue             [UIColor colorWithRed:35.f/255.f green:119.f/255.f blue:194.f/255.f alpha:1.f];
#define UIColorBackground       [UIColor colorWithRed:248.f/255.f green:248.f/255.f blue:248.f/255.f alpha:1.f];

//weifei
#define kWWPourWasteStep        @"kWWPourWasteStep"
#define WWasteTypeCode          @"WWasteTypeCode"
#define WWasteTypeName          @"WWasteTypeName"
#define WWasteType              @"WWasteType"
#define WWasteDescription       @"WWasteDescription"
#define WWasteContainerType     @"WWasteContainerType"
#define WWasteWeight            @"WWasteWeight"
#define WWasteForm              @"WWasteForm"
#define WWasteDange             @"WWasteDange"
#define WWastePH                @"WWastePH"
#define WWasteRemark            @"WWasteRemark"
#define WWastePhone             @"WWastePhone"
#define WWasteImage             @"WWasteImage"

/*************友盟统计事件id******************/

#define UMDiscountCallPhone             @"DiscountCallPhone"
#define UMDiscountFilter                @"DiscountFilter"
#define UMDiscountLoading               @"DiscountLoading"
#define UMDiscountShare                 @"DiscountShare"
#define UMDiscountTabBarClick           @"DiscountTabBarClick"
#define UMHomePageActivityClick         @"HomePageActivityClick"
#define UMHomePageFocusPicClick         @"HomePageFocusPicClick"
#define UMHomePageFoodClick             @"HomePageFoodClick"
#define UMHomePageLifeClick             @"HomePageLifeClick"
#define UMHomePageMoreClick             @"HomePageMoreClick"
#define UMHomePagePlayClick             @"HomePagePlayClick"
#define UMHomePageSearchBarSearch       @"HomePageSearchBarSearch"
#define UMHomePageTabBarClick           @"HomePageTabBarClick"
#define UMMemberShipCardCallPhone       @"MemberShipCardCallPhone"
#define UMMemberShipCardLoading         @"MemberShipCardLoading"
#define UMMemberShipCardShare           @"MemberShipCardShare"
#define UMMerchantDetailCallPhone       @"MerchantDetailCallPhone"
#define UMMerchantDetailLoading         @"MerchantDetailLoading"
#define UMMerchantDetailShare           @"MerchantDetailShare"
#define UMMoreTabBarClick               @"MoreTabBarClick"
#define UMMyFriendsShipLoading          @"MyFriendsShipLoading"
#define UMMyTabBarClick                 @"MyTabBarClick"
#define UMNearByShopMapClick            @"NearByShopMapClick"
#define UMNearByShopsFilter             @"NearByShopsFilter"
#define UMNearByTabBarClick             @"NearByTabBarClick"
#define UMNotificationClick             @"NotificationClick"
