//
//  MeetingRoomInfo.h
//  Training
//
//  Created by lichunwang on 16/12/27.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "RoomArrangementInfo.h"

@class RoomArrangementInfo;

@interface MeetingRoomInfo : JSONModel

@property (assign, nonatomic) NSInteger containNumber;
@property (assign, nonatomic) NSInteger roomId;
@property (copy, nonatomic) NSString *roomName;
@property (copy, nonatomic) NSString *roomType;

@property (assign, nonatomic) BOOL idle;
@property (strong, nonatomic) RoomArrangementInfo *arrangementInfo;


@end
