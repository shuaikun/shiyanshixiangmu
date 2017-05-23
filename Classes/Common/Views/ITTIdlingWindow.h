//
//  KSDIdlingWindow.h
//  CEBBank
//
//  Created by Sword Zhou on 7/8/13.
//  Copyright (c) 2013 iSoftstone. All rights reserved.
//

/*! ITTIdlingWindow can detect app idle event and post a notification to observer
 *
 */
#import <UIKit/UIKit.h>

extern NSString * const ITTIDIdlingWindowIdleNotification;

@interface ITTIdlingWindow : UIWindow
{
}

@property (assign) NSTimeInterval idleTimeFrequence;        //default check frequence value:1 seconds
@property (assign) NSTimeInterval idleTimeInterval;         //default value:60 seconds
@property (assign) NSTimeInterval idleTime;

- (void)reset;

@end