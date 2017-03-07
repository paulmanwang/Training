//
//  TrainingManager+Department.m
//  Training
//
//  Created by lichunwang on 16/12/26.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "TrainingManager+Department.h"
#import "DepartmentInfo.h"

@implementation TrainingManager (Department)

- (void)queryDepartmentsWithCompletion:(void(^)(NSError *error, NSArray *departments))completion
{
    [self sendRequestWithMethod:@"GET" path:kGetDepartmentsPath parameters:nil completionHandler:^(NSError *error, NSInteger code, id responseObject) {
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
            DepartmentInfo *item = [[DepartmentInfo alloc] initWithDictionary:data error:nil];
            [result addObject:item];
        }
        self.departmentList = (NSArray *)result;
        if (completion) {
            completion(nil, result);
        }
    }];
}

@end
