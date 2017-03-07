//
//  MeetingRoomInfo.m
//  Training
//
//  Created by lichunwang on 16/12/27.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "MeetingRoomInfo.h"

@implementation MeetingRoomInfo

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"contain_number":@"containNumber",
                                                       @"id":@"roomId",
                                                       @"room_name":@"roomName",
                                                       @"room_type":@"roomType"}];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
