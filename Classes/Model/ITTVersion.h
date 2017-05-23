//
//  ITTVersion.h
//  iTotemFramework
//
//  Created by Sword on 13-12-17.
//  Copyright (c) 2013年 iTotemStudio. All rights reserved.
//

#import "ITTBaseModelObject.h"

@interface ITTVersion : ITTBaseModelObject

@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) NSString *appid;
@property (nonatomic, strong) NSString *bundleIdentifier;
@property (nonatomic, strong) NSString *versionDetails;
@property (nonatomic, strong) NSString *countryCode;
@property (nonatomic, strong) NSString *applicationName;
@property (nonatomic, strong) NSString *storeUrl;
/*!
 * Default value is FALSE
 */
@property (nonatomic, assign) BOOL needForceUpdate;
/*!
 * A BOOL value indicates whether use built-in update when SKStoreProductViewController is available. Default value is TRUE
 */
@property (nonatomic, assign) BOOL builtinUpdate;

@end
