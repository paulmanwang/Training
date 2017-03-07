//
//  RoomArrangementInfo.h
//  Training
//
//  Created by lichunwang on 16/12/27.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "DepartmentInfo.h"
#import "MeetingRoomInfo.h"

//"arrangement_date" = "2016-12-25";
//"arrangement_time" = 3;
//deleted = 0;
//department =             {
//    "department_name" = "\U6295\U8d44\U63a7\U80a1\U6709\U9650\U516c\U53f8";
//    id = 15;
//};
//"department_id" = 15;
//"meeting_room" =             {
//    "contain_number" = 10;
//    id = 1;
//    "room_name" = 1001;
//    "room_type" = "\U957f\U5f62";
//};
//mobile = 18924608778;
//name = rockyye;
//rid = "929a324e-e200-4c53-9710-5c6ef462f556";
//"room_id" = 1;

@interface RoomArrangementInfo : JSONModel

@property (copy, nonatomic) NSString *rid;

@property (assign, nonatomic) NSInteger roomId;

@property (copy, nonatomic) NSString *arrangementDate;

@property (assign, nonatomic) NSInteger arrangementTime;

@property (copy, nonatomic) NSString *mobile;

@property (copy, nonatomic) NSString *name;

@property (strong, nonatomic) DepartmentInfo *departmentInfo;

@property (assign, nonatomic) NSInteger departmentId;

@property (copy, nonatomic) NSString *createTime;

@property (copy, nonatomic) NSString *modifyTime;

@property (assign, nonatomic) NSInteger deleted;

@property (assign, nonatomic) NSInteger useType;

@end
