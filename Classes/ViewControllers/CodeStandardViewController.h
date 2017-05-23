//
//  CodeStandardViewController.h
//  iTotemFramework
//
//  Created by lian jie on 8/29/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger{
    SampleEnumUndefined = 0,
    SampleEnumOne,
    SampleEnumTwo
} SampleEnum;

@interface CodeStandardViewController : UIViewController

@property (nonatomic, strong) NSString *samplePropertyString;

- (void)samplePublicMethodWithParam:(NSString*)sampleParam;
@end
