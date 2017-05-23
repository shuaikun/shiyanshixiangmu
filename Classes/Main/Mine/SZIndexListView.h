//
//  SZIndexListView.h
//  iTotemFramework
//
//  Created by 王琦 on 14-4-16.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "ITTXibView.h"

@protocol SZIndexListViewDelegate <NSObject>
- (void)indexListViewDidSelectIndex:(int)index Content:(NSString *)content;
@end

@interface SZIndexListView : ITTXibView

@property (assign, nonatomic) id<SZIndexListViewDelegate>delegate;
- (void)setIndexListWithHeight:(CGFloat)height;

@end
