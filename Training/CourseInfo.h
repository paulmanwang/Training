//
//  CourseItem.h
//  Training
//
//  Created by lichunwang on 16/12/26.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>
#import "DepartmentInfo.h"

//audience = "\U5168\U4f53\U4eba\U5458";
//cid = "d8d14f95-948d-4563-8803-c4dcc4b11690";
//"create_time" = "2016-12-20T18:32:07.000Z";
//deleted = 0;
//department =             {
//    "department_name" = "\U7efc\U5408\U529e\U516c\U5ba4";
//    id = 1;
//};
//"department_id" = 1;
//"end_time" = "2016-12-21T04:00:00.000Z";
//place = 101;
//"start_time" = "2016-12-21T02:00:00.000Z";
//theme = "\U7ba1\U7406\U5458\U57f9\U8bad2";

@interface CourseInfo : JSONModel

@property (copy, nonatomic) NSString *audience;
@property (copy, nonatomic) NSString *cid;
@property (copy, nonatomic) NSString *sid;
@property (copy, nonatomic) NSString *createTime;
@property (assign, nonatomic) NSInteger deleted;
@property (strong, nonatomic) DepartmentInfo *department;
@property (copy, nonatomic) NSString *departmentName;
@property (copy, nonatomic) NSString *departmentId;
@property (copy, nonatomic) NSString *place;
@property (copy, nonatomic) NSString *theme;
@property (copy, nonatomic) NSString *startTime;
@property (copy, nonatomic) NSString *endTime;

@property (strong, nonatomic) UserInfo *userInfo;

// 可选的属性
@property (copy, nonatomic) NSString *mobile;
@property (copy, nonatomic) NSString *contacts;
@property (assign, nonatomic) NSInteger applyCount;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *userName;
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *picture;

@end
