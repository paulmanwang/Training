//
//  TrainingManager+Course.m
//  Training
//
//  Created by lichunwang on 16/12/26.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "TrainingManager+Summary.h"
#import "CourseInfo.h"

@implementation TrainingManager (Summary)

- (void)querySummaryListWithMine:(NSInteger)mine
                      isExpired:(BOOL)isExpired
                      startTime:(NSString *)startTime
                        endTime:(NSString *)endTime
                   departmentId:(NSInteger)departmentId
                          theme:(NSString *)theme
                        pageNum:(NSInteger)pageNum
                       pageSize:(NSInteger)pageSize
                     completion:(void(^)(NSError *error, NSArray *courseList))completion
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    if (mine == 1) {
        parameters[@"mine"] = @(1);
    }
    if (departmentId > 0) {
        parameters[@"department_id"] = @(departmentId);
    }
    if (theme.length > 0) {
        parameters[@"theme"] = theme;
    }
    if (startTime.length > 0) {
        parameters[@"create_start_time"] = startTime;
    }
    if (endTime.length > 0) {
        parameters[@"create_end_time"] = endTime;
    }
    
    parameters[@"page_num"] = @(pageNum);
    parameters[@"page_size"] = @(pageSize);
    
    [self sendRequestWithMethod:@"GET" path:kGetSummaryListPath parameters:parameters completionHandler:^(NSError *error, NSInteger code, id responseObject) {
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
            CourseInfo *item = [[CourseInfo alloc] initWithDictionary:data error:&error];
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

- (void)querySummaryThemeListWithCompletion:(void(^)(NSError *error, NSArray *themeList))completion
{
   [self sendRequestWithMethod:@"GET" path:kGetSummaryThemeListPath parameters:nil completionHandler:^(NSError *error, NSInteger code, id responseObject) {
       if (code != 0) {
           if (completion) {
               error = error ?: commonErrorWithJsonData(responseObject);
               completion(error, nil);
           }
           return;
       }
       
       NSArray *dataList = responseObject[@"data"];
       NSMutableArray *result = [NSMutableArray new];
       for (NSDictionary *data in dataList) {
           NSError *error;
           CourseInfo *item = [[CourseInfo alloc] initWithDictionary:data error:&error];
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

- (void)editSummaryWithParameters:(NSDictionary *)parameters
                      completion:(void(^)(NSError *error))completion
{
    [self sendRequestWithMethod:@"POST" path:kEditSummaryPath parameters:parameters completionHandler:^(NSError *error, NSInteger code, id responseObject) {
        TrainingCallBackBlock
    }];
}

- (void)addSummaryWithParameters:(NSDictionary *)parameters
                     completion:(void(^)(NSError *error))completion
{
    [self sendRequestWithMethod:@"POST" path:kAddSummaryPath parameters:parameters completionHandler:^(NSError *error, NSInteger code, id responseObject) {
       TrainingCallBackBlock
    }];
}

- (void)deleteSummaryWithSId:(NSString *)sid
                 completion:(void(^)(NSError *error))completion
{
    NSDictionary *parameters = @{@"sid":sid};
    [self sendRequestWithMethod:@"POST" path:kDeleteSummaryPath parameters:parameters completionHandler:^(NSError *error, NSInteger code, id responseObject) {
        TrainingCallBackBlock
    }];
}

- (void)querySummaryDetailWithSId:(NSString *)sid
                      completion:(void(^)(NSError *error, CourseInfo *courseInfo))completion
{
    NSDictionary *parameters = @{@"sid":sid};
    [self sendRequestWithMethod:@"GET" path:kGetSummaryDetailPath parameters:parameters completionHandler:^(NSError *error, NSInteger code, id responseObject) {
        if (code != 0) {
            error = error ? error : commonErrorWithJsonData(responseObject);
            if (completion) {
                completion(error, nil);
            }
            return;
        }
        
        CourseInfo *info = [[CourseInfo alloc] initWithDictionary:responseObject[@"data"] error:nil];
        if (completion) {
            completion(nil, info);
        }
    }];
}

- (void)verifySummaryWithSId:(NSString *)sid
                    isApprove:(BOOL)isApprove
                   completion:(void(^)(NSError *error))completion
{
    NSNumber *approved = isApprove ? @(1):@(2);
    NSDictionary *parameters = @{@"sid":sid, @"is_approve":approved};
    [self sendRequestWithMethod:@"POST" path:kVerifySummaryPath parameters:parameters completionHandler:^(NSError *error, NSInteger code, id responseObject) {
        TrainingCallBackBlock
    }];
}

@end
