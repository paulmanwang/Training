//
//  MaterialInfo.h
//  Training
//
//  Created by lichunwang on 17/1/5.
//  Copyright © 2017年 springcome. All rights reserved.
//

#import <JSONModel/JSONModel.h>

//mid 培训资料id
//department_id 单位id
//department: {
//    id:单位id
//department_name:单位名称
//}
//theme 培训资料主题
//link 培训资料url
//publisher 培训资料发布人
//deleted 是否删除
//is_approve 是否审核
//approver 审核者id
//create_time 创建时间
//modify_time 修改时间
//approve_time 审核时间

@interface MaterialInfo : JSONModel

@property (copy, nonatomic) NSString *mid;
@property (strong, nonatomic) DepartmentInfo *department;
@property (copy, nonatomic) NSString *departmentId;
@property (copy, nonatomic) NSString *theme;
@property (assign, nonatomic) NSInteger deleted;
@property (copy, nonatomic) NSString *createTime;
@property (copy, nonatomic) NSString *modifyTime;

@property (copy, nonatomic) NSString *publisher;
@property (copy, nonatomic) NSString *link;

@property (assign, nonatomic) BOOL isApprove;
@property (copy, nonatomic) NSString *approver;
@property (copy, nonatomic) NSString *approveTime;

@property (strong, nonatomic) UserInfo *userInfo;

@end
