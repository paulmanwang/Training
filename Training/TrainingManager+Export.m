//
//  TrainingManager+Export.m
//  Training
//
//  Created by lichunwang on 17/1/6.
//  Copyright © 2017年 springcome. All rights reserved.
//

#import "TrainingManager+Export.h"

@implementation TrainingManager (Export)

- (void)exportWithPath:(NSString *)path
          departmentId:(NSInteger)departmentId
             startDate:(NSString *)startDate
               endDate:(NSString *)endDate
            completion:(void(^)(NSError *error, NSString *url))completion
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    if (departmentId > 0) {
        parameters[@"department_id"] = @(departmentId);
    }
    
    parameters[@"start_date"] = startDate;
    parameters[@"end_date"] = endDate;
    
    [self sendRequestWithMethod:@"GET" path:path parameters:parameters completionHandler:^(NSError *error, NSInteger code, id responseObject) {
        if (code != 0) {
            error = error ? error : commonErrorWithJsonData(responseObject);
            if (completion) {
                completion(error, nil);
            }
            return;
        }
        
        NSDictionary *data = responseObject[@"data"];
        if (completion) {
            completion(error, data[@"url"]);
        }
    }];
}

- (void)exportCourseWithDepartmentId:(NSInteger)departmentId
                           startDate:(NSString *)startDate
                             endDate:(NSString *)endDate
                          completion:(void(^)(NSError *error, NSString *url))completion
{
    [self exportWithPath:kExportCoursePath departmentId:departmentId startDate:startDate endDate:endDate completion:completion];
}

- (void)exportSummaryWithDepartmentId:(NSInteger)departmentId
                            startDate:(NSString *)startDate
                              endDate:(NSString *)endDate
                           completion:(void(^)(NSError *error, NSString *url))completion
{
    [self exportWithPath:kExportSummaryPath departmentId:departmentId startDate:startDate endDate:endDate completion:completion];
}

- (void)exportRoomArrangementWithDepartmentId:(NSInteger)departmentId
                                    startDate:(NSString *)startDate
                                      endDate:(NSString *)endDate
                                   completion:(void(^)(NSError *error, NSString *url))completion;
{
    [self exportWithPath:kExportRoomArrangementPath departmentId:departmentId startDate:startDate endDate:endDate completion:completion];
}

@end
