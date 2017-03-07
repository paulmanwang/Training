//
//  AdminInfo.h
//  Training
//
//  Created by lichunwang on 16/12/26.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>
#import "DepartmentInfo.h"

@interface AdminInfo : JSONModel

@property (strong, nonatomic) DepartmentInfo *department;
@property (copy, nonatomic) NSString *departmentId;
@property (copy, nonatomic) NSString *mobile;
@property (copy, nonatomic) NSString *realName;
@property (copy, nonatomic) NSString *userId;
@property (assign, nonatomic) NSInteger userType;
@property (copy, nonatomic) NSString *userName;

@end
