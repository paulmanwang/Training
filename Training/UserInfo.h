//
//  UserInfo.h
//  Training
//
//  Created by lichunwang on 16/12/26.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>

typedef NS_ENUM(NSInteger, TrainingUserType)
{
    TrainingUserType_Normal = 1,
    TrainingManager_Meeting = 2,
    TrainingUserType_Training = 3,
    TrainingUserType_Super = 4,
    TrainingUserType_Verify = 5
};

@interface UserInfo : JSONModel

@property (copy, nonatomic) NSString *skey;
@property (copy, nonatomic) NSString *userId;
@property (assign, nonatomic) TrainingUserType userType; // 1普通用户  2会议室管理员 3课程管理员 4 超级管理员

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *userName;
@property (copy, nonatomic) NSString *mobile;
@property (assign, nonatomic) NSInteger departmentId;

@end
