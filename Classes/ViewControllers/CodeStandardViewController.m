//
//  CodeStandardViewController.m
//  iTotemFramework
//
//  Created by lian jie on 8/29/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "CodeStandardViewController.h"

//define your private variables and methods here
@interface CodeStandardViewController ()
{
}
@end

#define THIS_IS_AN_SAMPLE_MACRO @"THIS_IS_AN_SAMPLE_MACRO"

@implementation CodeStandardViewController

#pragma mark - private methods


/*!
 *	Convert a dictionary to a string of json format
 *	\param dictionary A dictionary the key of dictionary must be NSString type,
 *  value of dictionary can be custom object and system primary object. The super class of custom object must be ITTBaseModelObject
 *	\returns A string of json format
 */
- (void)samplePrivateMethod
{
    //some code
}

- (void)sampleForIf
{
    BOOL someCondition = YES;
    if (someCondition) {
        // do something here
    }
}

- (void)sampleForWhile
{
    int i = 0;
    while (i < 10) {
        // do something here
        i = i + 1;
    }
}

- (void)sampleForSwitch
{
    SampleEnum testEnum = SampleEnumTwo;
    switch (testEnum) {
        case SampleEnumUndefined:{
            // do something
            break;
        }
        case SampleEnumOne:{
            // do something
            break;
        }
        case SampleEnumTwo:{
            // do something
            break;
        }
            
        default:{
            NSLog(@"WARNING: there is an enum type not handled properly!");
            break;
        }
    }
}

- (void)wrongExamples
{
    BOOL someCondition = YES;
    
    if (someCondition)
        NSLog(@"this is wrong!!!");
    
    while (someCondition)
        NSLog(@"this is wrong!!!");
}

#pragma mark - public methods

- (void)samplePublicMethodWithParam:(NSString*)sampleParam
{
    //some code
}

#pragma mark - life cycle methods
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
