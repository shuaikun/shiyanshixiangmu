//
//  HelpView.h
//
//  Created by lt ji on 11-12-20.
//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITTXibView.h"

@interface ITTFirstTouchHelpView : ITTXibView
{

}

+ (id)loadFromXib;
-(void)startHelpWithHelpImageArray:(NSArray *)imageArray iphone5ImageArray:(NSArray *)iphone5ImageArray;

@end
