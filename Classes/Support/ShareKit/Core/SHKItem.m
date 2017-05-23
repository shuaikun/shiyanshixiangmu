//
//  SHKItem.m
//  ShareKit
//
//  Created by Nathan Weiner on 6/18/10.

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

#import "SHKItem.h"
#import "SHK.h"


@interface SHKItem()
@property (nonatomic, retain)	NSMutableDictionary *custom;
@end


@implementation SHKItem

- (void)dealloc{
	[_image release];
	
	[_title release];
	[_text release];
	
	[_custom release];
	
	[super dealloc];
}


+ (SHKItem *)image:(UIImage *)image{
	return [SHKItem image:image title:nil];
}

+ (SHKItem *)image:(UIImage *)image title:(NSString *)title{
	SHKItem *item = [[SHKItem alloc] init];
	item.image = image;
	item.title = title;
	
	return [item autorelease];
}

+ (SHKItem *)text:(NSString *)text{
	SHKItem *item = [[SHKItem alloc] init];
	item.text = text;
	
	return [item autorelease];
}

#pragma mark -

- (void)setCustomValue:(NSString *)value forKey:(NSString *)key{
	if (_custom == nil){
        _custom = [[NSMutableDictionary alloc] init];
    }
	
	if (value == nil){
		[_custom removeObjectForKey:key];
    }else{
		_custom[key] = value;
    }
}

- (NSString *)customValueForKey:(NSString *)key{
	return _custom[key];
}

- (BOOL)customBoolForSwitchKey:(NSString *)key{
	return [_custom[key] isEqualToString:SHKFormFieldSwitchOn];
}


#pragma mark -

+ (SHKItem *)itemFromDictionary:(NSDictionary *)dictionary{
	SHKItem *item = [[SHKItem alloc] init];
	item.title = dictionary[@"title"];
	item.text = dictionary[@"text"];
		
	if (dictionary[@"custom"] != nil){
		item.custom = [[dictionary[@"custom"] mutableCopy] autorelease];
    }
	
	return [item autorelease];
}


@end
