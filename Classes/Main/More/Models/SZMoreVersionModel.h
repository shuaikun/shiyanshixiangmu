//
//  SZMoreVersionModel.h
//  iTotemFramework
//
//  Created by 成焱 on 14-4-15.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "SZMoreModel.h"

@interface SZMoreVersionModel : SZMoreModel
@property (nonatomic, assign) BOOL haveNew;
@property (nonatomic, copy) NSString *currentVersion;
@property (nonatomic, copy) NSString *AppStoreVersion;
@property (nonatomic, copy) NSString *downloadUrl;
@end
