//
//  ITTPageView.h
//  AiQiChe
//
//  Created by lian jie on 7/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#define PAGE_VIEW_SPACE_BETWEEN_DOTS 8
#define PAGE_VIEW_DOT_WIDTH 5
#define PAGE_VIEW_DOT_HEIGHT 5
#define PAGE_VIEW_SELECTED_DOT_IMAGE @"SZ_HOME_DOT_H"
#define PAGE_VIEW_DOT_IMAGE @"SZ_HOME_DOT"

@interface ITTPageView : UIView

@property (nonatomic,assign)int pageNum;
@property (nonatomic,assign)int currentPage;
@property (nonatomic, copy) NSString *imageDot;
@property (nonatomic, copy) NSString *imageDotH;
- (id)initWithPageNum:(int)pageNum;

- (void)setInitStateFromNib:(int)pageNum;

@end
