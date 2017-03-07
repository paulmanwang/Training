//
//  DepartmentItem.m
//  Training
//
//  Created by lichunwang on 16/12/26.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "DepartmentInfo.h"

@implementation DepartmentInfo

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"department_name":@"departmentName",
                                                       @"id":@"departmentId"}];
}

- (NSString *)description
{
    return self.departmentName;
}

@end
