//
//  TrainingManager+MeetingRoom.h
//  Training
//
//  Created by lichunwang on 16/12/27.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrainingManager (MeetingRoom)

- (void)queryMeetingRoomsWithCompletion:(void(^)(NSError *error, NSArray *meetingRoomList))completion;

@end
