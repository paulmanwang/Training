//
//  TrainingManager+MeetingRoom.m
//  Training
//
//  Created by lichunwang on 16/12/27.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "TrainingManager+MeetingRoom.h"
#import "MeetingRoomInfo.h"

@implementation TrainingManager (MeetingRoom)

- (void)queryMeetingRoomsWithCompletion:(void(^)(NSError *error, NSArray *meetingRoomList))completion
{
    [self sendRequestWithMethod:@"GET" path:kGetMeetingRoomListPath parameters:nil completionHandler:^(NSError *error, NSInteger code, id responseObject) {
        if (code != 0) {
            error = error ? error : commonErrorWithJsonData(responseObject);
            if (completion) {
                completion(error, nil);
            }
            return;
        }
        
        // 处理数据
        NSArray *dataList = responseObject[@"data"];
        NSMutableArray *result = [NSMutableArray new];
        for (NSDictionary *data in dataList) {
            MeetingRoomInfo *info = [[MeetingRoomInfo alloc] initWithDictionary:data error:nil];
            [result addObject:info];
        }
        if (completion) {
            completion(nil, result);
        }
    }];
}

@end
