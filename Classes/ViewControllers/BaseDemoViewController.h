//
//  BaseDemoViewController.h
//  
//
//  Created by jack 廉洁 on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface BaseDemoViewController : UIViewController{
    NSString *_navTitle;
}
@property (nonatomic, strong)NSString *navTitle;
- (void)setNav;
- (void)onBackBtnClicked;
@end
