//
//  EGORefreshTableHeaderView.m
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
//  modified by sowrd.zhou on 12/20/2011
//  add load more footer
//

#import "EGORefreshTableHeaderView.h"


//#define TEXT_COLOR	 [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]
#define TEXT_COLOR	 [UIColor blackColor]
#define FLIP_ANIMATION_DURATION 0.18f
#define RefreshViewHight        50
#define LoadMoreCellHeight      50

@interface EGORefreshTableHeaderView (Private)
- (void)setState:(EGOPullRefreshState)aState;
    @end

@implementation EGORefreshTableHeaderView
    
    @synthesize delegate = _delegate;
    @synthesize type = _type;
    
    
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _type = EGOPullRefreshTypeHeader;
        _hintMessage = NSLocalizedString(@"PULL_DOWN_TO_RELEASE_STATUS", @"Pull down to refresh...");
        _normalMessage = NSLocalizedString(@"RELEASE_TO_REFRESH_STATUS", @"Pull up to refresh...");
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont systemFontOfSize:12.0f];
		label.textColor = TEXT_COLOR;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_lastUpdatedLabel = label;
		
		label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 48.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:13.0f];
		label.textColor = TEXT_COLOR;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
		
		CALayer *layer = [CALayer layer];
		layer.frame = CGRectMake(25.0f, frame.size.height - 65.0f >= 0 ?frame.size.height - 65.0f:0, 30.0f, 55.0f);
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)[UIImage imageNamed:@"blueArrow.png"].CGImage;
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		
		[[self layer] addSublayer:layer];
		_arrowImage=layer;
		
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		view.frame = CGRectMake(25.0f, frame.size.height - 38.0f, 20.0f, 20.0f);
		[self addSubview:view];
		_activityView = view;
        /*
         UIImage *image = ImageNamed([[ThemeManager sharedInstance] resourceFileName:@"timeline_bg@2x.png"]);
         UIImageView *bgView = [[UIImageView alloc] initWithFrame:self.bounds];
         bgView.image = image;
         [self addSubview:bgView];
         [self sendSubviewToBack:bgView];
         [bgView release];
         */
        _lastUpdatedLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        
		[self setState:EGOOPullRefreshNormal];
    }
	
    return self;
	
}
    
    
#pragma mark -
#pragma mark Setters
    
- (void)refreshLastUpdatedDate {
	
	if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceLastUpdated:)]) {
		
		NSDate *date = [_delegate egoRefreshTableHeaderDataSourceLastUpdated:self];
		
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setAMSymbol:@"上午"];
		[formatter setPMSymbol:@"下午"];
		[formatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
		_lastUpdatedLabel.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"LAST_UPDATED_HINT_MESSAGE", @""), [formatter stringFromDate:date]];
		[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
	} else {
		_lastUpdatedLabel.text = nil;
	}
    
}
    
- (void)refresh:(UIScrollView*)scrollView {
    [self setState:EGOOPullRefreshLoading];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    scrollView.contentInset = UIEdgeInsetsMake(RefreshViewHight, 0.0f, 0.0f, 0.0f);
    [UIView commitAnimations];
}
    
- (void)refresh:(UIScrollView*)scrollView type:(EGOPullRefreshType) type {
    [self setState:EGOOPullRefreshLoading];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    if (type == EGOPullRefreshTypeHeader) {
        scrollView.contentInset = UIEdgeInsetsMake(RefreshViewHight, 0.0f, 0.0f, 0.0f);
    }
    else {
        scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, LoadMoreCellHeight, 0.0f);
    }
    [UIView commitAnimations];
}
    
- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[self setState:EGOOPullRefreshNormal];
}
    
- (void)reset:(UIScrollView*)scrollView {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[self setState:EGOOPullRefreshNormal];
}
    
- (void)setState:(EGOPullRefreshState)aState{
	
	switch (aState) {
		case EGOOPullRefreshPulling:
        _statusLabel.text = _normalMessage;
        [CATransaction begin];
        [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
        _arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
        [CATransaction commit];
        break;
		case EGOOPullRefreshNormal:
        if (_state == EGOOPullRefreshPulling) {
            [CATransaction begin];
            [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
            _arrowImage.transform = CATransform3DIdentity;
            [CATransaction commit];
        }
        _statusLabel.text = _hintMessage;
        [_activityView stopAnimating];
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
        _arrowImage.hidden = NO;
        _arrowImage.transform = CATransform3DIdentity;
        [CATransaction commit];
        
        [self refreshLastUpdatedDate];
        
        break;
		case EGOOPullRefreshLoading:
        
        _statusLabel.text = NSLocalizedString(@"LOADING_STATUS", @"Loading...");
        [_activityView startAnimating];
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
        _arrowImage.hidden = YES;
        [CATransaction commit];
        
        break;
		default:
        break;
	}
	
	_state = aState;
}
    
    
#pragma mark -
#pragma mark ScrollView Methods
    
- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView {
	if (_state == EGOOPullRefreshLoading) {
        if(scrollView.contentOffset.y < 0)
        scrollView.contentInset = UIEdgeInsetsMake(RefreshViewHight, 0.0f,0.0f, 0.0f);
        else
        scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0f, LoadMoreCellHeight, 0.0f);
	}
    else if (scrollView.isDragging) {
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
			_loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
		}
        if (!_loading) {
            //load more footer
            if (_type == EGOPullRefreshTypeFooter) {
                if (_state == EGOOPullRefreshPulling && scrollView.contentOffset.y + (scrollView.frame.size.height) <= scrollView.contentSize.height + LoadMoreCellHeight/2) {
                    [self setState:EGOOPullRefreshNormal];
                }
                else if (_state == EGOOPullRefreshNormal &&  scrollView.contentOffset.y + (scrollView.frame.size.height) >= scrollView.contentSize.height + LoadMoreCellHeight/2) {
                    [self setState:EGOOPullRefreshPulling];
                }
            }
            else {
                if (_state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y <= 0.0f) {
                    [self setState:EGOOPullRefreshNormal];
                }
                else if (_state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -65.0f) {
                    [self setState:EGOOPullRefreshPulling];
                }
                
                if (scrollView.contentInset.top != 0) {
                    scrollView.contentInset = UIEdgeInsetsZero;
                }
            }
        }
	}
	
}
    
- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
		_loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
	}
    
    if (!_loading) {
        if (_type == EGOPullRefreshTypeHeader) {
            if (scrollView.contentOffset.y < 0 - RefreshViewHight) {
                if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:)]) {
                    [_delegate egoRefreshTableHeaderDidTriggerRefresh:self];
                }
                [self setState:EGOOPullRefreshLoading];
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.2];
                scrollView.contentInset = UIEdgeInsetsMake(RefreshViewHight, 0.0f, 0.0f, 0.0f);
                [UIView commitAnimations];
            }
        }
        else {
            if (scrollView.contentOffset.y > 0) {
                if (scrollView.contentOffset.y + (scrollView.frame.size.height) >= scrollView.contentSize.height + LoadMoreCellHeight/2) {
                    if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:)]) {
                        [_delegate egoRefreshTableHeaderDidTriggerRefresh:self];
                    }
                    [self setState:EGOOPullRefreshLoading];
                    [UIView beginAnimations:nil context:NULL];
                    [UIView setAnimationDuration:0.2];
                    scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, LoadMoreCellHeight, 0.0f);
                    [UIView commitAnimations];
                }
            }
        }
    }
}
    
- (void) setType:(EGOPullRefreshType)type {
    _type = type;
    if (_type == EGOPullRefreshTypeFooter) {
//        _arrowImage.opacity = 0.0;
        _hintMessage = NSLocalizedString(@"PUll_UP_TO_REFRESH_STATUS", @"Pull up to refresh...");
        _statusLabel.text = _hintMessage;

        _normalMessage = NSLocalizedString(@"RELEASE_TO_LOADMORE_STATUS", @"Pull up to refresh...");
    }
}
    
#pragma mark -
#pragma mark Dealloc
    
- (void)dealloc {
	_delegate = nil;
	_activityView = nil;
	_statusLabel = nil;
	_arrowImage = nil;
	_lastUpdatedLabel = nil;
}
    
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //    [super touchesBegan:touches withEvent:event];
    ITTDINFO(@"- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event");
    if (_delegate && [_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTouched:)]) {
        [_delegate egoRefreshTableHeaderDidTouched:self];
    }
}
    @end
