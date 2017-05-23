//
//  SectionHeader.h
//  iTotemFramework
//
//  Created by Sword Zhou on 8/20/13.
//  Copyright (c) 2013 iTotemStudio. All rights reserved.
//

#import "ITTBaseModelObject.h"

@class SectionHeaderView;

@interface ApplicationSectionHeader : ITTBaseModelObject

@property (nonatomic, strong) SectionHeaderView *headerView;
@property (nonatomic, strong) NSArray *applications;
@property (nonatomic, assign) BOOL open;

@end
