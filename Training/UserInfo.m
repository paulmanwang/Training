//
//  UserInfo.m
//  Training
//
//  Created by lichunwang on 16/12/26.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"uid":@"userId",
                                                       @"username":@"userName",
                                                       @"user_type":@"userType"}];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}


@end
