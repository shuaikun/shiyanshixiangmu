//
//  Person.h
//  magicalrecordtestproject
//
//  Created by Yannick Loriot on 25/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Person : NSManagedObject

@property (nonatomic, strong) NSString * firstname;
@property (nonatomic, strong) NSString * lastname;
@property (nonatomic, strong) NSNumber * age;

@end
