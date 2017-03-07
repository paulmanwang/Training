//
//  TrainingManager+Export.h
//  Training
//
//  Created by lichunwang on 17/1/6.
//  Copyright © 2017年 springcome. All rights reserved.
//

#import "TrainingManager.h"

@interface TrainingManager (Export)

- (void)exportCourseWithDepartmentId:(NSInteger)departmentId
                           startDate:(NSString *)startDate
                             endDate:(NSString *)endDate
                          completion:(void(^)(NSError *error, NSString *url))completion;

- (void)exportSummaryWithDepartmentId:(NSInteger)departmentId
                           startDate:(NSString *)startDate
                             endDate:(NSString *)endDate
                          completion:(void(^)(NSError *error, NSString *url))completion;

- (void)exportRoomArrangementWithDepartmentId:(NSInteger)departmentId
                            startDate:(NSString *)startDate
                              endDate:(NSString *)endDate
                           completion:(void(^)(NSError *error, NSString *url))completion;

@end
