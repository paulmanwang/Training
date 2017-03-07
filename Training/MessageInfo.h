//
//  MessageInfo.h
//  Training
//
//  Created by lichunwang on 17/1/14.
//  Copyright © 2017年 springcome. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface MessageInfo : JSONModel

@property (copy, nonatomic) NSString *mid;
@property (copy, nonatomic) NSString *uid;
@property (copy, nonatomic) NSString *cid;
@property (assign, nonatomic) NSInteger messageType;

@property (copy, nonatomic) NSString *theme;
@property (copy, nonatomic) NSString *place;
@property (assign, nonatomic) NSInteger departmentId;
@property (copy, nonatomic) NSString *departmentName;

@property (copy, nonatomic) NSString *createTime;
@property (copy, nonatomic) NSString *startTime;
@property (copy, nonatomic) NSString *endTime;

@end
