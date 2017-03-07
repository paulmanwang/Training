//
//  TrainingManager+RoomArrange.m
//  Training
//
//  Created by lichunwang on 16/12/27.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "TrainingManager+RoomArrangement.h"
#import "RoomArrangementInfo.h"

@implementation TrainingManager (RoomArrangement)

- (void)addRoomArrangementWithParameters:(NSDictionary *)parameters
                              completion:(void(^)(NSError *error))completion
{
    [self sendRequestWithMethod:@"POST" path:kAddArrangementPath parameters:parameters completionHandler:^(NSError *error, NSInteger code, id responseObject) {
        TrainingCallBackBlock
    }];
}

- (void)deleteRoomArrangementWithRId:(NSString *)rid
                          completion:(void(^)(NSError *error))completion
{
    NSDictionary *parameters = @{@"rid":rid};
    [self sendRequestWithMethod:@"POST" path:kDeleteArrangementPath parameters:parameters completionHandler:^(NSError *error, NSInteger code, id responseObject) {
        TrainingCallBackBlock
    }];
}

- (void)editRoomArrangementWithParameters:(NSDictionary *)parameters
                               completion:(void(^)(NSError *error))completion
{
    [self sendRequestWithMethod:@"POST" path:kEditArrangementPath parameters:parameters completionHandler:^(NSError *error, NSInteger code, id responseObject) {
        TrainingCallBackBlock
    }];
}

- (void)queryRoomArrangementListWithDate:(NSString *)date
                                   time:(NSInteger)time
                             completion:(void(^)(NSError *error, NSArray *idleList, NSArray *arrangementList))completion
{
    NSDictionary *parameters = @{@"arrangement_time":@(time), @"arrangement_date":date};
    [self sendRequestWithMethod:@"GET" path:kGetArrangementListPath parameters:parameters completionHandler:^(NSError *error, NSInteger code, id responseObject) {
        if (code != 0) {
            error = error ? error : commonErrorWithJsonData(responseObject);
            if (completion) {
                completion(error, nil, nil);
            }
            return;
        }
        
        NSArray *dataList = responseObject[@"data"];
        NSMutableArray *idleList = [NSMutableArray new];
        NSMutableArray *arragementList = [NSMutableArray new];
        for (NSDictionary *data in dataList) {
            NSInteger idle = [data[@"idle"] integerValue];
            if (idle == 1) {
                [idleList addObject:data[@"room_id"]];
            }
            else {
                RoomArrangementInfo *info = [[RoomArrangementInfo alloc] initWithDictionary:data error:&error];
                [arragementList addObject:info];
            }
        }
        if (completion) {
            completion(nil, idleList, arragementList);
        }
    }];
}

@end
