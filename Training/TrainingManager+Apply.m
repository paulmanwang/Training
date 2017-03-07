//
//  TrainingManager+Apply.m
//  Training
//
//  Created by lichunwang on 16/12/27.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "TrainingManager+Apply.h"
#import "ApplyInfo.h"

@implementation TrainingManager (Apply)

- (void)addApplyWithCId:(NSString *)cid
             completion:(void(^)(NSError *error))completion
{
    NSDictionary *parameters = @{@"cid":cid};
    [self sendRequestWithMethod:@"POST" path:kAddApplyPath parameters:parameters completionHandler:^(NSError *error, NSInteger code, id responseObject) {
       TrainingCallBackBlock
    }];
}

- (void)deleteApplyWithCId:(NSString *)cid
                completion:(void(^)(NSError *error))completion
{
    NSDictionary *parameters = @{@"cid":cid};
    [self sendRequestWithMethod:@"POST" path:kDeleteApplyPath parameters:parameters completionHandler:^(NSError *error, NSInteger code, id responseObject) {
        TrainingCallBackBlock
    }];
}

- (void)queryApplyStatusWithCId:(NSString *)cid
                     completion:(void(^)(NSError *error, NSInteger status))completion
{
    NSDictionary *parameters = @{@"cid":cid};
    [self sendRequestWithMethod:@"GET" path:kGetApplyStatusPath parameters:parameters completionHandler:^(NSError *error, NSInteger code, id responseObject) {
        if (code != 0) {
            error = error ? error : commonErrorWithJsonData(responseObject);
            if (completion) {
                completion(error, -1);
            }
            return;
        }
        
        // 获取status
        if (completion) {
            NSDictionary *data = responseObject[@"data"];
            completion(nil, [data[@"status"] integerValue]);
        }
    }];
}

- (void)queryApplyListWithExpired:(NSInteger)isExpired
                        startTime:(NSString *)startTime
                          endTime:(NSString *)endTime
                     departmentId:(NSInteger)departmentId
                            theme:(NSString *)theme
                          pageNum:(NSInteger)pageNum
                         pageSize:(NSInteger)pageSize
                       completion:(void(^)(NSError *error, NSArray *applyList))completion
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    if (isExpired >= 0) {
        parameters[@"expired"] = @(isExpired);
    }
    if (startTime.length > 0) {
        parameters[@"start_time"] = startTime;
    }
    if (endTime.length > 0) {
        parameters[@"end_time"] = endTime;
    }
    if (departmentId > 0) {
        parameters[@"department_id"] = @(departmentId);
    }
    if (theme.length > 0) {
        parameters[@"theme"] = theme;
    }
    
    parameters[@"page_num"] = @(pageNum);
    parameters[@"page_size"] = @(pageSize);
    NSLog(@"parameters = %@", parameters);
    
    [self sendRequestWithMethod:@"GET" path:kGetApplyListPath parameters:parameters completionHandler:^(NSError *error, NSInteger code, id responseObject) {
        if (code != 0) {
            error = error ? error : commonErrorWithJsonData(responseObject);
            if (completion) {
                completion(error, nil);
            }
            return;
        }
        
        NSArray *dataList = responseObject[@"data"];
        NSMutableArray *result = [NSMutableArray new];
        for (NSDictionary *data in dataList) {
            NSError *error;
            ApplyInfo *item = [[ApplyInfo alloc] initWithDictionary:data error:&error];
            if (error) {
                NSLog(@"error = %@", error);
            }
            [result addObject:item];
        }
        if (completion) {
            completion(nil, result);
        }
    }];
}

@end
