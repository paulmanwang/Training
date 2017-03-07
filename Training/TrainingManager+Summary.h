//
//  TrainingManager+Course.h
//  Training
//
//  Created by lichunwang on 16/12/26.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrainingManager.h"
#import "CourseInfo.h"

@interface TrainingManager (Summary)

- (void)querySummaryListWithMine:(NSInteger)mine
                      isExpired:(BOOL)isExpired
                      startTime:(NSString *)startTime
                        endTime:(NSString *)endTime
                   departmentId:(NSInteger)departmentId
                          theme:(NSString *)theme
                        pageNum:(NSInteger)pageNum
                       pageSize:(NSInteger)pageSize
                     completion:(void(^)(NSError *error, NSArray *courseList))completion;

- (void)addSummaryWithParameters:(NSDictionary *)parameters
                     completion:(void(^)(NSError *error))completion;

- (void)editSummaryWithParameters:(NSDictionary *)parameters
                       completion:(void(^)(NSError *error))completion;

- (void)deleteSummaryWithSId:(NSString *)sid
                 completion:(void(^)(NSError *error))completion;

- (void)querySummaryDetailWithSId:(NSString *)sid
                      completion:(void(^)(NSError *error, CourseInfo *courseInfo))completion;

- (void)querySummaryThemeListWithCompletion:(void(^)(NSError *error, NSArray *themeList))completion;

- (void)verifySummaryWithSId:(NSString *)sid
                   isApprove:(BOOL)isApprove
                  completion:(void(^)(NSError *error))completion;

@end
