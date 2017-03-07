//
//  TrainingManager+Material.m
//  Training
//
//  Created by lichunwang on 17/1/5.
//  Copyright © 2017年 springcome. All rights reserved.
//

#import "TrainingManager+Material.h"
#import "MaterialInfo.h"

@implementation TrainingManager (Material)

- (void)queryMaterialListWithStartTime:(NSString *)startTime
                               endTime:(NSString *)endTime
                          departmentId:(NSInteger)departmentId
                                 theme:(NSString *)theme
                               pageNum:(NSInteger)pageNum
                              pageSize:(NSInteger)pageSize
                            compeltion:(void(^)(NSError *error, NSArray *materialList))completion
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    if (startTime.length > 0) {
        parameters[@"start_time"] = startTime;
    }
    if (endTime.length > 0) {
        parameters[@"end_time"] = endTime;
    }
    if (theme.length > 0) {
        parameters[@"theme"] = theme;
    }
    if (departmentId > 0) {
        parameters[@"department_id"] = @(departmentId);
    }
    parameters[@"page_num"] = @(pageNum);
    parameters[@"page_size"] = @(pageSize);
    
    [self sendRequestWithMethod:@"GET" path:kGetMaterialListPath parameters:parameters completionHandler:^(NSError *error, NSInteger code, id responseObject) {
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
            MaterialInfo *item = [[MaterialInfo alloc] initWithDictionary:data error:&error];
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

- (void)addMaterialWithParameters:(NSDictionary *)parameters
                     completion:(void(^)(NSError *error))completion
{
    [self sendRequestWithMethod:@"POST" path:kAddMaterialPath parameters:parameters completionHandler:^(NSError *error, NSInteger code, id responseObject) {
        TrainingCallBackBlock
    }];
}

- (void)deleteMaterialWithMId:(NSString *)mid
                   completion:(void(^)(NSError *error))completion
{
    NSDictionary *parameters = @{@"mid":mid};
    [self sendRequestWithMethod:@"POST" path:kDeleteMaterialPath parameters:parameters completionHandler:^(NSError *error, NSInteger code, id responseObject) {
        TrainingCallBackBlock
    }];
}

- (void)verifyMaterailWithMId:(NSString *)mid
                    isApprove:(BOOL)isApprove
                   completion:(void(^)(NSError *error))completion
{
    NSNumber *approved = isApprove ? @(1):@(2);
    NSDictionary *parameters = @{@"mid":mid, @"is_approve":approved};
    [self sendRequestWithMethod:@"POST" path:kVerifyMaterialPath parameters:parameters completionHandler:^(NSError *error, NSInteger code, id responseObject) {
        TrainingCallBackBlock
    }];
}


@end
