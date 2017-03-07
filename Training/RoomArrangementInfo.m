//
//  RoomArrangementInfo.m
//  Training
//
//  Created by lichunwang on 16/12/27.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "RoomArrangementInfo.h"

@implementation RoomArrangementInfo

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"arrangement_date":@"arrangementDate",
                                                       @"arrangement_time":@"arrangementTime",
                                                       @"department":@"departmentInfo",
                                                       @"department_id":@"departmentId",
                                                       @"meeting_room":@"roomInfo",
                                                       @"room_id":@"roomId",
                                                       @"create_time":@"createTime",
                                                       @"modify_time":@"modifyTime",
                                                       @"use_type":@"useType"}];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
