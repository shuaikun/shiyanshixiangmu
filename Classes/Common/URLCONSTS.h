//
//  URLCONSTS.h
//  iTotemFramework
//
//  Created by Grant on 14-4-15.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#ifndef iTotemFramework_URLCONSTS_h
#define iTotemFramework_URLCONSTS_h

//#define SZHOST_URL @"http://www.yuchanet.com/"
#define SZHOST_URL @"http://61.149.204.206:6767/"


//product
//#define SMHOST_URL @"http://218.241.2.191:8080/stm/admin/cms/"
//test
//#define SMHOST_URL @"http://218.241.2.191:8080/stoneman/admin/cms/"

//http://www.yuchanet.com/index.php?route=api/qrcode/data&qr=2342423432432sdlfdsafjdsa
//#define SMHOST_URL @"http://www.yuchanet.com/index.php?route=api/"
//http://wayintech.wicp.net:14767/api/qrcode/data.action
//#define SMHOST_URL @"http://x86063252.vicp.cc:8080/api/"
#define SMHOST_URL @"http://61.149.204.206:6767/api/"

//#define SMPUSH_URL @"http://www.yuchanet.com/index.php?route=push/oax/"


#define NETDATA     @"data"
#define NETMSG      @"message"
#define NETRESULT   @"success"

#define SZIOSPLATFORM_NUM @"1"
#define SZIOSPLATFORM_STR @"ios"

//request keys
#define PARAMS_METHOD_KEY @"method"
#define PARAMS_USER_ID    @"user_id"
#define PARAMS_PLAT       @"plat"

//methods
//1.首页取活动图片和热门优惠(app.index.datalist)
#define SZINDEX_DETAILIST_METHORD @"app.index.datalist"
//2.取app消息(app.index.sendmodel)
#define SZINDEX_BROADCAST_METHORD @"app.index.sendmodel"
//3. 取活动下商铺数据（app.activity.storelist）
#define SZACTIVITY_STORELIST_METHORD @"app.activity.storelist"
//4. 地理位置坐标反查 (app.)
#define SZINDEX_LOCATION_METHORD @"app.index.geocoding"

//优惠券模块
//1.商铺下优惠券列表(app.goods.storelist)
#define SZINDEX_GOODS_STORELIST_METHOD @"app.goods.storelist"
//2.优惠卷信息详情(app.goods.detail)
#define SZINDEX_GOODS_DETAIL_METHOD @"app.goods.detail"
//3.下载/删除优惠卷 (app.goods.record)
#define SZINDEX_GOODS_RECORD_METHOD @"app.goods.record"

//2.优惠券搜索列表(app.goodssearch.datalist)
#define SZINDEX_GOODSSEARCH_DATALIST_METHOD @"app.goodssearch.datalist"

//我的模块
//1.我的(app.user.center)
#define SZINDEX_USER_CENTER_METHOD @"app.user.center"
//5.好友列表(app.user.friends)
#define SZINDEX_USER_FRIENDS_METHOD @"app.user.friends"
//6.电话本归类(app.user.phonebook)
#define SZINDEX_USER_PHONEBOOK_METHOD @"app.user.phonebook"
//7.添加好友(app.user.addfriends)
#define SZINDEX_USER_ADDFRIENDS_METHOD @"app.user.addfriends"
//8.个人信息(app.user.info)
#define SZINDEX_USER_INFO_METHOD @"app.user.info"
//9.修改个人信息(app.user.editinfo)
#define SZINDEX_USER_EDITINFO_METHOD @"app.user.editinfo"
//10.我的优惠券(app.user.mycoupons)
#define SZINDEX_USER_COUPON_METHOD @"app.user.mycoupons"
//11.我的会员卡(app.user.mycard)
#define SZINDEX_USER_CARD_METHOD @"app.user.mycard"
//12.我的收藏(app.user.mycollects)
#define SZINDEX_USER_COLLECT_METHOD @"app.user.mycollects"
//13.我的点评(app.comment.personal)
#define SZINDEX_USER_COMMENT_METHOD @"app.comment.personal"
//14.最近浏览(app.user.lastviews)
#define SZINDEX_USER_LASTVIEWS_METHOD @"app.user.lastviews"
//15.新消息(app.html.news)
#define SZHTML_NEW_MESSAGE_METHOD @"app.html.news"
//16.删除好友(app.user.delfriends)
#define SZINDEX_USER_DELFRIENDS_METHOD @"app.user.delfriends"
//17.删除评论 (app.comment.del)
#define SZINDEX_USER_DELCOMMENT_METHOD @"app.comment.del"

//注册登录
//1. 发送手机激活短信(app.user.sendcode)
#define SZSENDCODE_USER_METHORD   @"app.user.sendcode"
//2. 手机注册(app.user.register)
#define SZREGISTER_USER_METHORD   @"user/reg"
//3. 登录(app.user.login)
#define SZLOGIN_USER_METHORD      @"user/login"
//4. 忘记密码(app.user.findpwd)
#define SZFINDPWD_USER_METHORD    @"app.user.findpwd"
//5. 忘记密码效验验证码(app.user.checkcode)
#define SZCHECKCODE_USER_METHORD  @"app.user.checkcode"

//商铺模块
//1.商铺搜索列表
#define SZSTORE_SEARCHLIST      @"app.storesearch.storelist"
//2.店铺详情接口
#define SZ_STORE_DETAIL         @"app.store.detail"	
//3.产品图册列表接口
#define SZNEARBY_PRODUCT_LIST   @"app.store.productpiclist"
//4.获取商铺评论
#define SZNEARBY_GETSTORECOMMENT @"app.comment.get"
//5.点评商铺
#define SZNEARBY_ADDSTORECOMMENT @"app.comment.add"
//6.收藏商铺
#define SZNEARBY_COLLECTSTOREC  @"app.store.collect"
//7.焦点图册列表接口
#define SZNEARBY_FOCUSLIST      @"app.store.focuslist"

//更多模块
//1.获取app的版本号
#define SZMORE_GETAAPPVERSION   @"app.index.ver"
//2.意见反馈
#define SZMORE_RECOMMENT        @"app.index.feedback"



//3. 登录(app.user.login)
#define SMLOGIN_USER_METHORD      @"user/login.action"



#endif
