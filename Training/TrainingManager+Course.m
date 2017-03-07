//
//  TrainingManager+Course.m
//  Training
//
//  Created by lichunwang on 16/12/26.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "TrainingManager+Course.h"
#import "CourseInfo.h"

@implementation TrainingManager (Course)

- (void)queryCourseListWithMine:(NSInteger)mine
                      isExpired:(NSInteger)isExpired
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
    if (isExpired > 0) {
        parameters[@"expired"] = isExpired ? @(1) : @(0);
    }
    if (startTime.length > 0) {
        parameters[@"start_time"] = startTime;
    }
    if (endTime.length > 0) {
        parameters[@"end_time"] = endTime;
    }
    if (theme.length > 0) {
        parameters[@"theme"] = theme;
    }
    parameters[@"page_num"] = @(pageNum);
    parameters[@"page_size"] = @(pageSize);
    
    [self sendRequestWithMethod:@"GET" path:kGetCourseListPath parameters:parameters completionHandler:^(NSError *error, NSInteger code, id responseObject) {
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

- (void)addCourseWithParameters:(NSDictionary *)parameters
                     completion:(void(^)(NSError *error))completion
{
    [self sendRequestWithMethod:@"POST" path:kAddCoursePath parameters:parameters completionHandler:^(NSError *error, NSInteger code, id responseObject) {
       TrainingCallBackBlock
    }];
}

- (void)deleteCourseWithCId:(NSString *)cid
                 completion:(void(^)(NSError *error))completion
{
    NSDictionary *parameters = @{@"cid":cid};
    [self sendRequestWithMethod:@"POST" path:kDeleteCoursePath parameters:parameters completionHandler:^(NSError *error, NSInteger code, id responseObject) {
        TrainingCallBackBlock
    }];
}

- (void)editCourseWithParameters:(NSDictionary *)parameters
                      completion:(void(^)(NSError *error))completion
{
    [self sendRequestWithMethod:@"POST" path:kEditCoursePath parameters:parameters completionHandler:^(NSError *error, NSInteger code, id responseObject) {
        TrainingCallBackBlock
    }];
}

- (void)queryCourseDetailWithCid:(NSString *)cid
                      completion:(void(^)(NSError *error, CourseInfo *courseInfo))completion;
{
    NSDictionary *parameters = @{@"cid":cid};
    [self sendRequestWithMethod:@"GET" path:kGetCourseDetailPath parameters:parameters completionHandler:^(NSError *error, NSInteger code, id responseObject) {
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

- (void)verifyCourseWithCId:(NSString *)cid
                  isApprove:(BOOL)isApprove
                 completion:(void(^)(NSError *error))completion
{
    NSNumber *approved = isApprove ? @(1):@(2);
    NSDictionary *parameters = @{@"cid":cid, @"is_approve":approved};
    [self sendRequestWithMethod:@"POST" path:kVerifyCoursePath parameters:parameters completionHandler:^(NSError *error, NSInteger code, id responseObject) {
        TrainingCallBackBlock
    }];
}

@end
