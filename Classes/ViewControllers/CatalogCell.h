//
//  CatalogCell.h
//  iTotemFramework
//
//  Created by Sword on 13-1-30.
//  Copyright (c) 2013年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Catalog;

@protocol CatalogCellDelegate;

@interface CatalogCell : UITableViewCell

@property (nonatomic, unsafe_unretained) id<CatalogCellDelegate> delegate;
@property (nonatomic, assign) NSInteger numberOfRowsInSection;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) Catalog *catalog;

+ (CatalogCell*)cellFromNib;

@end

@protocol CatalogCellDelegate <NSObject>
@optional
- (void)catalogCellDidUseModalView:(CatalogCell*)catalogCell used:(BOOL)used;
@end
