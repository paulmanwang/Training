//
//  MessageInfo.m
//  Training
//
//  Created by lichunwang on 17/1/14.
//  Copyright © 2017年 springcome. All rights reserved.
//

#import "MessageInfo.h"

@implementation MessageInfo

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"department_id":@"departmentId",
                                                       @"department_name":@"departmentName",
                                                       @"create_time":@"createTime",
                                                       @"start_time":@"startTime",
                                                       @"end_time":@"endTime",
                                                       @"message_type":@"messageType"
                                                       }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}


@end
