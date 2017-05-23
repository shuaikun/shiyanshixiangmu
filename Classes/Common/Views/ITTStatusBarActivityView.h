//
//  ITTStatusBarActivityView.h
//  
//
//  Created by jack 廉洁 on 9/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITTXibView.h"
typedef enum : NSUInteger{
    ITTStatusBarActivityViewStatusNone,
    ITTStatusBarActivityViewStatusSuccess,
    ITTStatusBarActivityViewStatusFail,
    ITTStatusBarActivityViewStatusInProgress
}ITTStatusBarActivityViewStatus;   

@interface ITTStatusBarActivityView : ITTXibView

@property (nonatomic, assign) ITTStatusBarActivityViewStatus status;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UILabel *statusLbl;

- (void)setStatus:(ITTStatusBarActivityViewStatus)status;
- (void)hide;

@end
