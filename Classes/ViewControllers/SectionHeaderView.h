//
//  SectionHeaderView.h
//  iTotemFramework
//
//  Created by Sword Zhou on 8/20/13.
//  Copyright (c) 2013 iTotemStudio. All rights reserved.
//

#import "ITTXibView.h"

@class ApplicationSectionHeader;
@protocol ApplicationSectionHeaderDelegate;

@interface SectionHeaderView : ITTXibView

@property (nonatomic, weak) id<ApplicationSectionHeaderDelegate> delegate;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, strong) ApplicationSectionHeader *sectionHeader;

@end


@protocol ApplicationSectionHeaderDelegate <NSObject>

@optional
- (void)sectionHeaderView:(SectionHeaderView*)cellHeader didOpenedSection:(NSInteger)section;
- (void)sectionHeaderView:(SectionHeaderView*)cellHeader didClosedSection:(NSInteger)section;

@end