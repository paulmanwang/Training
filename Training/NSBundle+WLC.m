//
//  NSBundle+WLC.m
//  Training
//
//  Created by lichunwang on 17/2/7.
//  Copyright © 2017年 springcome. All rights reserved.
//

#import "NSBundle+WLC.h"

@implementation NSBundle_WLC

+ (NSString *)appName
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return infoDictionary[@"CFBundleDisplayName"];
}

+ (NSString *)appVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return infoDictionary[@"CFBundleShortVersionString"];
}

+ (NSString *)appBuildVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return infoDictionary[@"CFBundleVersion"];
}

@end
