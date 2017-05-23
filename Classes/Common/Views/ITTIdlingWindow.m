//
//  KSDIdlingWindow.h
//  CEBBank
//
//  Created by Sword Zhou on 7/8/13.
//  Copyright (c) 2013 iSoftstone. All rights reserved.
//

#import "ITTIdlingWindow.h"

NSString * const ITTIDIdlingWindowIdleNotification   = @"ITTIDIdlingWindowIdleNotification";

@interface ITTIdlingWindow ()
{
	NSTimer         *_idleTimer;
}

@end


@implementation ITTIdlingWindow

- (void)dealloc
{
	if (_idleTime) {
		[_idleTimer invalidate];
		_idleTimer = nil;
	}
}

- (id) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
        _idleTime = 0;
        _idleTimeFrequence = 1.0;
		_idleTimeInterval = 3*60.0;
        if (!_idleTimer) {
            _idleTimer = [NSTimer scheduledTimerWithTimeInterval:_idleTimeFrequence
                                                              target:self
                                                            selector:@selector(idleTicker)
                                                            userInfo:nil repeats:TRUE];
        }
	}
	return self;
}

#pragma mark activity timer
- (void)sendEvent:(UIEvent *)event
{
    [super sendEvent:event];	
    NSSet *allTouches = [event allTouches];
    if ([allTouches count] > 0) {
        self.idleTime = 0;
	}
}

- (void)idleTicker
{
    _idleTime++;
    if (_idleTime > _idleTimeInterval) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ITTIDIdlingWindowIdleNotification object:nil userInfo:nil];
    }
}

#pragma mark - public methods
- (void)reset
{
    _idleTime = 0;
}
@end
