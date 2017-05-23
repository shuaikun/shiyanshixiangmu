//
//  Catalog.m
//  iTotemFramework
//
//  Created by Sword on 13-1-30.
//  Copyright (c) 2013年 iTotemStudio. All rights reserved.
//

#import "Catalog.h"

@implementation Catalog

@synthesize name = _name;
@synthesize type = _type;
@synthesize catalogType = _catalogType;

- (NSDictionary*)attributeMapDictionary
{
    return @{@"name":@"name", @"type":@"type"};
}

- (CatalogType)catalogType
{
    return [_type integerValue];
}

- (id)copyWithZone:(NSZone *)zone
{
    Catalog *copy = [[self class] allocWithZone:zone];
    copy->_name = [self.name copy];
    return copy;
}
@end
