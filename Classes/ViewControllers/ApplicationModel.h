//
//  ApplicationModel.h
//  iTotemFramework
//
//  Created by Sword Zhou on 8/20/13.
//  Copyright (c) 2013 iTotemStudio. All rights reserved.
//

#import "ITTBaseModelObject.h"

@interface ApplicationModel : ITTBaseModelObject

@property (nonatomic, strong) NSString *itunesId;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *introduction;

@end
