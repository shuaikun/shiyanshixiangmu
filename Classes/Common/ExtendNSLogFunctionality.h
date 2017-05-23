//
//  ExtendNSLogFunctionality.h
//  leju_MavericksRoom
//
//  Created by Grant on 13-12-4.
//  Copyright (c) 2013年 leju. All rights reserved.
//

//#ifdef DEBUG
//#define NSLog(args...)  ExtendNSLog(__FILE__,__LINE__,__PRETTY_FUNCTION__,args);
//#else
//#define NSLog(x...)
//#endif

void   ExtendNSLog(const char *file, int lineNumber, const char *functionName, NSString *format, ...);
