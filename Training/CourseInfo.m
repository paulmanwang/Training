//
//  CourseItem.m
//  Training
//
//  Created by lichunwang on 16/12/26.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "CourseInfo.h"

@implementation CourseInfo

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"department_id":@"departmentId",
                                                       @"department_name":@"departmentName",
                                                       @"create_time":@"createTime",
                                                       @"start_time":@"startTime",
                                                       @"end_time":@"endTime",
                                                       @"apply_count":@"applyCount",
                                                       @"username":@"userName",
                                                       @"user":@"userInfo"}];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
