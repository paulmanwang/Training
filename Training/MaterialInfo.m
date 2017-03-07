//
//  MaterialInfo.m
//  Training
//
//  Created by lichunwang on 17/1/5.
//  Copyright © 2017年 springcome. All rights reserved.
//

#import "MaterialInfo.h"

@implementation MaterialInfo

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"department_id":@"departmentId",
                                                       @"create_time":@"createTime",
                                                       @"modify_time":@"modifyTime",
                                                       @"approve_time":@"approveTime",
                                                       @"is_approve":@"isApprove",
                                                       @"user":@"userInfo"
                                                       }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}


@end
