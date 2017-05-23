//
//  SHK.m
//  ShareKit
//
//  Created by Nathan Weiner on 6/10/10.
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
//

#import "SHK.h"
#import "SHKActivityIndicator.h"
#import "SHKViewControllerWrapper.h"
#import "SHKActionSheet.h"
#import "SFHFKeychainUtils.h"
#import "Reachability.h"
//#import <objc/Object.h>
//#import </usr/include/objc/objc-class.h>
#import <MessageUI/MessageUI.h>

@interface SHK()

@end

@implementation SHK

static SHK *currentHelper = nil;
BOOL SHKinit;


+ (SHK *)currentHelper{
	if (currentHelper == nil){
		currentHelper = [[SHK alloc] init];
    }
	
	return currentHelper;
}
/*
+ (void)initialize{
	[super initialize];
	
	if (!SHKinit){
		SHKSwizzle([MFMailComposeViewController class], @selector(viewDidDisappear:), @selector(SHKviewDidDisappear:));	
		SHKinit = YES;
	}
}*/

- (void)dealloc{
	[_currentViewController release];
	[_pendingViewController release];
	[super dealloc];
}

#pragma mark - View Management

+ (void)setRootViewController:(UIViewController *)vc{	
	SHK *helper = [self currentHelper];
	[helper setRootViewController:vc];	
}

- (void)showViewController:(UIViewController *)vc{	
	if (_rootViewController == nil){
		// Try to find the root view controller programmically
		
		// Find the top window (that is not an alert view or other window)
		UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
		if (topWindow.windowLevel != UIWindowLevelNormal){
			NSArray *windows = [[UIApplication sharedApplication] windows];
			for(UIWindow *win in windows){
				if (win.windowLevel == UIWindowLevelNormal){
                    topWindow = win;
					break;
                }
			}
		}
		
		UIView *rootView = [topWindow subviews][0];	
		id nextResponder = [rootView nextResponder];
		
		if ([nextResponder isKindOfClass:[UIViewController class]]){
			self.rootViewController = nextResponder;
        }else{
			NSAssert(NO, @"ShareKit: Could not find a root view controller.  You can assign one manually by calling [[SHK currentHelper] setRootViewController:YOURROOTVIEWCONTROLLER].");
        }
	}
	
	// Find the top most view controller being displayed (so we can add the modal view to it and not one that is hidden)
	UIViewController *topViewController = [self getTopViewController];	
	if (topViewController == nil){
		NSAssert(NO, @"ShareKit: There is no view controller to display from");
    }
	
		
	// If a view is already being shown, hide it, and then try again
	if (_currentViewController != nil){
		self.pendingViewController = vc;
        if([_currentViewController parentViewController]){
            [[_currentViewController parentViewController] dismissModalViewControllerAnimated:YES];
        }else{
            [[_currentViewController presentingViewController] dismissModalViewControllerAnimated:YES];
        }
		return;
	}
		
	// Wrap the view in a nav controller if not already
	if (![vc respondsToSelector:@selector(pushViewController:animated:)]){
		UINavigationController *nav = [[[UINavigationController alloc] initWithRootViewController:vc] autorelease];
		
		if ([nav respondsToSelector:@selector(modalPresentationStyle)]){
			nav.modalPresentationStyle = [SHK modalPresentationStyle];
        }
		
		if ([nav respondsToSelector:@selector(modalTransitionStyle)]){
			nav.modalTransitionStyle = [SHK modalTransitionStyle];
        }
		
		nav.navigationBar.barStyle = [SHK barStyle];
		nav.toolbar.barStyle = [SHK barStyle];
		
		[topViewController presentModalViewController:nav animated:YES];			
		self.currentViewController = nav;
	}else{
        // Show the nav controller
		[topViewController presentModalViewController:vc animated:YES];
		[(UINavigationController *)vc navigationBar].barStyle = [SHK barStyle];
		[(UINavigationController *)vc toolbar].barStyle = [SHK barStyle];
		self.currentViewController = vc;
	}
		
	self.pendingViewController = nil;		
}

- (void)hideCurrentViewController{
	[self hideCurrentViewControllerAnimated:YES];
}

- (void)hideCurrentViewControllerAnimated:(BOOL)animated{
	if (_isDismissingView){
		return;
    }
	
	if (_currentViewController != nil){
		// Dismiss the modal view
		if ([_currentViewController parentViewController] != nil){
			_isDismissingView = YES;
			[[_currentViewController parentViewController] dismissModalViewControllerAnimated:animated];
		}else if([_currentViewController presentingViewController]){
			_isDismissingView = YES;
			[[_currentViewController presentingViewController] dismissModalViewControllerAnimated:animated];
        }else{
			self.currentViewController = nil;
        }
	}
}

- (void)showPendingView{
    if (_pendingViewController){
        [self showViewController:_pendingViewController];
    }
}


- (void)viewWasDismissed{
	_isDismissingView = NO;
	
	if (_currentViewController != nil){
		_currentViewController = nil;
    }
	
	if (_pendingViewController){
		// This is an ugly way to do it, but it works.
		// There seems to be an issue chaining modal views otherwise
		// See: http://github.com/ideashower/ShareKit/issues#issue/24
		[self performSelector:@selector(showPendingView) withObject:nil afterDelay:0.02];
		return;
	}
}
										   
- (UIViewController *)getTopViewController{
	UIViewController *topViewController = _rootViewController;
    if ([topViewController respondsToSelector:@selector(presentedViewController)]) {
        while (topViewController.presentedViewController != nil){
            topViewController = topViewController.presentedViewController;
        }
    }else if([topViewController respondsToSelector:@selector(modalViewController)]){
        while (topViewController.modalViewController != nil){
            topViewController = topViewController.modalViewController;
        }
    }
	return topViewController;
}
			
+ (UIBarStyle)barStyle{
	if ([SHKBarStyle isEqualToString:@"UIBarStyleBlack"]){
		return UIBarStyleBlack;
    }else if ([SHKBarStyle isEqualToString:@"UIBarStyleBlackOpaque"]){
		return UIBarStyleBlackOpaque;
    }else if ([SHKBarStyle isEqualToString:@"UIBarStyleBlackTranslucent"]){
        return UIBarStyleBlackTranslucent;
    }
	
	return UIBarStyleDefault;
}

+ (UIModalPresentationStyle)modalPresentationStyle{
	if ([SHKModalPresentationStyle isEqualToString:@"UIModalPresentationFullScreen"]){
        return UIModalPresentationFullScreen;
    }else if ([SHKModalPresentationStyle isEqualToString:@"UIModalPresentationPageSheet"]){
        return UIModalPresentationPageSheet;
    }else if ([SHKModalPresentationStyle isEqualToString:@"UIModalPresentationFormSheet"]){
        return UIModalPresentationFormSheet;
    }
	
	return UIModalPresentationCurrentContext;
}

+ (UIModalTransitionStyle)modalTransitionStyle{
	if ([SHKModalTransitionStyle isEqualToString:@"UIModalTransitionStyleFlipHorizontal"]){
        return UIModalTransitionStyleFlipHorizontal;
    }else if ([SHKModalTransitionStyle isEqualToString:@"UIModalTransitionStyleCrossDissolve"]){
        return UIModalTransitionStyleCrossDissolve;
    }else if ([SHKModalTransitionStyle isEqualToString:@"UIModalTransitionStylePartialCurl"]){
        return UIModalTransitionStylePartialCurl;
    }
	
	return UIModalTransitionStyleCoverVertical;
}

#pragma mark - User Exclusions

+ (NSDictionary *)getUserExclusions{
	return [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@Exclusions", SHK_FAVS_PREFIX_KEY]];
}

+ (void)setUserExclusions:(NSDictionary *)exclusions{
	return [[NSUserDefaults standardUserDefaults] setObject:exclusions forKey:[NSString stringWithFormat:@"%@Exclusions", SHK_FAVS_PREFIX_KEY]];	
}



#pragma mark -  Credentials

// TODO someone with more keychain experience may want to clean this up.  The use of SFHFKeychainUtils may be unnecessary?

+ (NSString *)getAuthValueForKey:(NSString *)key forSharer:(NSString *)sharerId{
#if TARGET_IPHONE_SIMULATOR
	// Using NSUserDefaults for storage is very insecure, but because Keychain only exists on a device
	// we use NSUserDefaults when running on the simulator to store objects.  This allows you to still test
	// in the simulator.  You should NOT modify in a way that does not use keychain when actually deployed to a device.
	return [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%@%@",SHK_AUTH_PREFIX,sharerId,key]];
#else
	return [SFHFKeychainUtils getPasswordForUsername:key andServiceName:[NSString stringWithFormat:@"%@%@",SHK_AUTH_PREFIX,sharerId] error:nil];
#endif
}

+ (void)setAuthValue:(NSString *)value forKey:(NSString *)key forSharer:(NSString *)sharerId{
#if TARGET_IPHONE_SIMULATOR
	// Using NSUserDefaults for storage is very insecure, but because Keychain only exists on a device
	// we use NSUserDefaults when running on the simulator to store objects.  This allows you to still test
	// in the simulator.  You should NOT modify in a way that does not use keychain when actually deployed to a device.
	[[NSUserDefaults standardUserDefaults] setObject:value forKey:[NSString stringWithFormat:@"%@%@%@",SHK_AUTH_PREFIX,sharerId,key]];
#else
	[SFHFKeychainUtils storeUsername:key andPassword:value forServiceName:[NSString stringWithFormat:@"%@%@",SHK_AUTH_PREFIX,sharerId] updateExisting:YES error:nil];
#endif
}

+ (void)removeAuthValueForKey:(NSString *)key forSharer:(NSString *)sharerId{
#if TARGET_IPHONE_SIMULATOR
	// Using NSUserDefaults for storage is very insecure, but because Keychain only exists on a device
	// we use NSUserDefaults when running on the simulator to store objects.  This allows you to still test
	// in the simulator.  You should NOT modify in a way that does not use keychain when actually deployed to a device.
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%@%@%@",SHK_AUTH_PREFIX,sharerId,key]];
#else
	[SFHFKeychainUtils deleteItemForUsername:key andServiceName:[NSString stringWithFormat:@"%@%@",SHK_AUTH_PREFIX,sharerId] error:nil];
#endif
}

#pragma mark -

static NSDictionary *sharersDictionary = nil;

+ (NSDictionary *)sharersDictionary{
	if (sharersDictionary == nil){
		sharersDictionary = [[NSDictionary dictionaryWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"SHKSharers.plist"]] retain];
    }
	
	return sharersDictionary;
}


#pragma mark -

+ (NSError *)error:(NSString *)description, ...{
	va_list args;
    va_start(args, description);
    NSString *string = [[[NSString alloc] initWithFormat:description arguments:args] autorelease];
    va_end(args);
	
	return [NSError errorWithDomain:@"sharekit" code:1 userInfo:@{NSLocalizedDescriptionKey: string}];
}

#pragma mark -
#pragma mark Network

+ (BOOL)connected {
	Reachability *hostReach = [Reachability reachabilityForInternetConnection];	
	NetworkStatus netStatus = [hostReach currentReachabilityStatus];	
	return !(netStatus == NotReachable);
}

@end


NSString * SHKStringOrBlank(NSString * value){
	return value == nil ? @"" : value;
}

NSString * SHKEncode(NSString * value){
	if (value == nil){
		return @"";
    }
	
	NSString *string = value;
	
	string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
	string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	string = [string stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
	
	return string;	
}

NSString * SHKEncodeURL(NSURL * value){
	if (value == nil){
		return @"";
    }
	
	NSString *result = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           (CFStringRef)value.absoluteString,
                                                                           NULL,
																		   CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                           kCFStringEncodingUTF8);
    [result autorelease];
	return result;
}
/*
void SHKSwizzle(Class c, SEL orig, SEL new){
    Method origMethod = class_getInstanceMethod(c, orig);
    Method newMethod = class_getInstanceMethod(c, new);
    if(class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))){
		class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    }else{
		method_exchangeImplementations(origMethod, newMethod);
    }
}*/

NSString* SHKLocalizedString(NSString* key, ...) {
	static NSBundle* bundle = nil;
	if (!bundle) {
		NSString* path = [[[NSBundle mainBundle] resourcePath]
						  stringByAppendingPathComponent:@"ShareKit.bundle"];
		bundle = [[NSBundle bundleWithPath:path] retain];
	}
	
	// Localize the format
	NSString *localizedStringFormat = [bundle localizedStringForKey:key value:key table:nil];
	
	va_list args;
    va_start(args, key);
    NSString *string = [[[NSString alloc] initWithFormat:localizedStringFormat arguments:args] autorelease];
    va_end(args);
	
	return string;
}
