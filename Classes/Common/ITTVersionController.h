//
//  ITTVersionManager.h
//  iTotemFramework
//
//  Created by Sword on 13-12-17.
//  Copyright (c) 2013年 iTotemStudio. All rights reserved.
//

#import "ITTBaseModelObject.h"

@class ITTVersion;

@interface ITTVersionController : ITTBaseModelObject

/*!
 * 
 */
@property (nonatomic, strong) UIViewController *rootViewController;
/*!
 * A BOOL value indicates whether display loading view when network request. Default value is FALSE
 */
@property (nonatomic, assign) BOOL showLoadingWhenCheck;

+ (ITTVersionController *)sharedInstance;

- (void)checkUpdate;
- (void)forceCheckUpdate;

/*!
 * The caller sends version check request to server and encapsulate response data to ITTVersion object, then
 * pass to the method
 * \param version server respond data
 */
- (void)checkUpdateWithVersion:(ITTVersion*)vewsion;

@end

#define VERSION_CONTROLLER [ITTVersionController sharedInstance]
