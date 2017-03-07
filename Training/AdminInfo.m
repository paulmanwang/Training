//
//  AdminInfo.m
//  Training
//
//  Created by lichunwang on 16/12/26.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "AdminInfo.h"

@implementation AdminInfo

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"department_id":@"departmentId",
                                                       @"name":@"realName",
                                                       @"uid":@"userId",
                                                       @"user_type":@"userType",
                                                       @"username":@"userName"
                                                       }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    if ([propertyName isEqualToString:@"userType"]) {
        return YES;
    }
    
    return NO;
}

@end
