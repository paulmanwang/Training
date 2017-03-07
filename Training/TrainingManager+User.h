//
//  TrainingManager+User.h
//  Training
//
//  Created by lichunwang on 16/12/26.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrainingManager.h"
#import "UserInfo.h"

@interface TrainingManager (User)

+ (BOOL)isCommonUser;
+ (BOOL)isSuperAdmin;
+ (BOOL)isVerifyAdmin;

- (void)queryVerificationCodeWithCompletion:(void(^)(NSError *error, NSString *sid, NSString *codeUrl))completion;

- (void)registerUserWithParameters:(NSDictionary *)parameters
                        completion:(void(^)(NSError *error))completion;

- (void)registerTrainingAdminWithParameters:(NSDictionary *)parameters
                                 completion:(void(^)(NSError *error))completion;

- (void)registerMeetingAdminWithParameters:(NSDictionary *)parameters
                                completion:(void(^)(NSError *error))completion;

- (void)registerVerifyAdminWithParameters:(NSDictionary *)parameters
                                completion:(void(^)(NSError *error))completion;

- (void)loginWithUserName:(NSString *)userName
                 password:(NSString *)password
         verificationCode:(NSString *)verificationCode
        completionHandler:(void(^)(NSError *error))completion;

- (void)loginOutWithCompletion:(void(^)(NSError *error))completion;

- (void)queryUserInfoWithCompletion:(void(^)(NSError *error, UserInfo *userInfo))completion;

- (void)queryAdminsWithType:(NSInteger)type
                   userName:(NSString *)userName
                       name:(NSString *)name
               departmentId:(NSInteger)departmentId
                     mobile:(NSString *)mobile
                    pageNum:(NSInteger)pageNum
                   pageSize:(NSInteger)pageSize
                 completion:(void(^)(NSError *error, NSArray *adminList))completion;

- (void)queryUnauditedUsersWithPageNum:(NSInteger)pageNum
                              pageSize:(NSInteger)pageSize
                            completion:(void(^)(NSError *error, NSArray *userList))completion;

- (void)auditUserWithUserId:(NSString *)userId
                  isApprove:(BOOL)isApprove
                 completion:(void(^)(NSError *error))completion;

- (void)modifyPasswordWithParameters:(NSDictionary *)parameters
                          completion:(void(^)(NSError *error))completion;

- (void)resetPasswordWithParameters:(NSDictionary *)parameters
                         completion:(void(^)(NSError *error))completion;

- (void)deleteAdminWithUserId:(NSString *)userId
                   completion:(void(^)(NSError *error))completion;


@end
