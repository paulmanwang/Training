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

@interface TrainingManager (Course)

- (void)queryCourseListWithMine:(NSInteger)mine
                      isExpired:(NSInteger)isExpired
                      startTime:(NSString *)startTime
                        endTime:(NSString *)endTime
                   departmentId:(NSInteger)departmentId
                          theme:(NSString *)theme
                        pageNum:(NSInteger)pageNum
                       pageSize:(NSInteger)pageSize
                     completion:(void(^)(NSError *error, NSArray *courseList))completion;

- (void)addCourseWithParameters:(NSDictionary *)parameters
                     completion:(void(^)(NSError *error))completion;

- (void)deleteCourseWithCId:(NSString *)cid
                 completion:(void(^)(NSError *error))completion;

- (void)editCourseWithParameters:(NSDictionary *)parameters
                      completion:(void(^)(NSError *error))completion;

- (void)queryCourseDetailWithCid:(NSString *)cid
                      completion:(void(^)(NSError *error, CourseInfo *courseInfo))completion;

- (void)verifyCourseWithCId:(NSString *)cid
                  isApprove:(BOOL)isApprove
                 completion:(void(^)(NSError *error))completion;

@end
