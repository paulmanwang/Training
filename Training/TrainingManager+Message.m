//
//  TrainingManager+Message.m
//  Training
//
//  Created by lichunwang on 17/1/14.
//  Copyright © 2017年 springcome. All rights reserved.
//

#import "TrainingManager+Message.h"
#import "MessageInfo.h"

@implementation TrainingManager (Message)

- (void)queryMessageListWithPageNum:(NSInteger)pageNum
                           pageSize:(NSInteger)pageSize
                         completion:(void(^)(NSError *error, NSArray *dataList))completion
{
    NSDictionary *parameters = @{@"page_num":@(pageNum), @"page_size":@(pageSize)};
    [self sendRequestWithMethod:@"GET" path:kGetMessageListPath parameters:parameters completionHandler:^(NSError *error, NSInteger code, id responseObject) {
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
            MessageInfo *item = [[MessageInfo alloc] initWithDictionary:data error:&error];
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

- (void)deleteMessageWithMId:(NSString *)mid
                  completion:(void(^)(NSError *error))completion
{
    NSDictionary *parameters = @{@"mid":mid};
    [self sendRequestWithMethod:@"POST" path:kDeleteMessagePath parameters:parameters completionHandler:^(NSError *error, NSInteger code, id responseObject) {
       TrainingCallBackBlock
    }];
}

@end
