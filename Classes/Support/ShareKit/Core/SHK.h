//
//  SHK.h
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

#define SHK_VERSION @"0.2.0"

#import <Foundation/Foundation.h>
#import "SHKConfig.h"
#import "SHKItem.h"
#import "SHKActionSheet.h"
#import "SHKRequest.h"
#import "SHKActivityIndicator.h"
#import "SHKFormFieldSettings.h"
#import "UIWebView+SHK.h"


@class SHKActionSheet;
@class SHKViewControllerWrapper;


@interface SHK : NSObject {
	UIViewController *_rootViewController;
	UIViewController *_currentViewController;
	UIViewController *_pendingViewController;
	BOOL _isDismissingView;
}

@property (nonatomic, assign) UIViewController *rootViewController;
@property (nonatomic, retain) UIViewController *currentViewController;
@property (nonatomic, retain) UIViewController *pendingViewController;
@property (nonatomic, assign) BOOL isDismissingView;

#pragma mark -
+ (SHK *)currentHelper;
+ (NSDictionary *)sharersDictionary;

#pragma mark - View Management
+ (UIBarStyle)barStyle;
+ (UIModalPresentationStyle)modalPresentationStyle;
+ (UIModalTransitionStyle)modalTransitionStyle;
+ (void)setRootViewController:(UIViewController *)vc;

- (void)showViewController:(UIViewController *)vc;
- (void)hideCurrentViewControllerAnimated:(BOOL)animated;
- (void)viewWasDismissed;
- (UIViewController *)getTopViewController;


#pragma mark - User Exclusions

+ (NSDictionary *)getUserExclusions;
+ (void)setUserExclusions:(NSDictionary *)exclusions;


#pragma mark - Credentials

+ (NSString *)getAuthValueForKey:(NSString *)key forSharer:(NSString *)sharerId;
+ (void)setAuthValue:(NSString *)value forKey:(NSString *)key forSharer:(NSString *)sharerId;
+ (void)removeAuthValueForKey:(NSString *)key forSharer:(NSString *)sharerId;

#pragma mark -

+ (NSError *)error:(NSString *)description, ...;

#pragma mark - Network

+ (BOOL)connected;

@end


NSString * SHKStringOrBlank(NSString * value);
NSString * SHKEncode(NSString * value);
NSString * SHKEncodeURL(NSURL * value);
NSString* SHKLocalizedString(NSString* key, ...);
void SHKSwizzle(Class c, SEL orig, SEL new);
