//
//  DataRequestTestViewController.h
//  iTotemFrame
//
//  Created by jack 廉洁 on 3/12/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITTBaseDataRequest.h"

#import "BaseDemoViewController.h"

@interface DataRequestTestViewController : BaseDemoViewController<DataRequestDelegate>
{
    NSMutableArray *_requestResultArray;
}

@end
