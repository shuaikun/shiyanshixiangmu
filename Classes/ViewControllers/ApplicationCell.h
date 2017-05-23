//
//  ApplicationCell.h
//  iTotemFramework
//
//  Created by Sword Zhou on 8/20/13.
//  Copyright (c) 2013 iTotemStudio. All rights reserved.
//

#import "ITTBaseTableViewCell.h"

@class ApplicationModel;

@interface ApplicationCell : ITTBaseTableViewCell

@property (nonatomic, strong) ApplicationModel *application;

@end
