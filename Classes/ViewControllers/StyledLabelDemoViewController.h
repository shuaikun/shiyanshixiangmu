//
//  StyledLabelDemoViewController.h
//  iTotemFramework
//
//  Created by jack 廉洁 on 4/11/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "BaseDemoViewController.h"
#import "ITTStyledLabel.h"

@interface StyledLabelDemoViewController : BaseDemoViewController<ITTStyledLabelDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet ITTStyledLabel *styleLabel;
@end
