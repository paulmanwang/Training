//
//  ApplyInfo.m
//  Training
//
//  Created by lichunwang on 16/12/27.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "ApplyInfo.h"

@implementation ApplyInfo

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"apply_time":@"applyTime",
                                                       @"course":@"courseInfo",
                                                       @"modify_time":@"modifyTime"}];
}

@end
