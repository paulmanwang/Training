//
//  TrainingManager+User.m
//  Training
//
//  Created by lichunwang on 16/12/26.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "TrainingManager+User.h"

@implementation TrainingManager (User)

+ (BOOL)isCommonUser
{
    if ([TrainingManager sharedInstance].userInfo.userType == TrainingUserType_Normal) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)isSuperAdmin
{
    if ([TrainingManager sharedInstance].userInfo.userType == TrainingUserType_Super) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)isVerifyAdmin
{
    if ([TrainingManager sharedInstance].userInfo.userType == TrainingUserType_Verify) {
        return YES;
    }
    
    return NO;
}

- (void)registerUserWithParameters:(NSDictionary *)parameters
                              path:(NSString *)path
                        completion:(void (^)(NSError *))completion
{
    [self sendRequestWithMethod:@"POST" path:path parameters:parameters completionHandler:^(NSError *error, NSInteger code, id responseObject) {
        TrainingCallBackBlock
    }];
}

- (void)registerUserWithParameters:(NSDictionary *)parameters
                        completion:(void(^)(NSError *error))completion
{
    [self registerUserWithParameters:parameters path:kSignUpUserPath completion:completion];
}

- (void)registerMeetingAdminWithParameters:(NSDictionary *)parameters
                                completion:(void(^)(NSError *error))completion
{
    [self registerUserWithParameters:parameters path:kSignUpMeetingPath completion:completion];
}

- (void)registerVerifyAdminWithParameters:(NSDictionary *)parameters
                               completion:(void(^)(NSError *error))completion
{
    [self registerUserWithParameters:parameters path:kSignUpVerifyPath completion:completion];
}

- (void)registerTrainingAdminWithParameters:(NSDictionary *)parameters
                                 completion:(void(^)(NSError *error))completion
{
    [self registerUserWithParameters:parameters path:kSignUpTrainingPath completion:completion];
}

- (void)queryVerificationCodeWithCompletion:(void(^)(NSError *error, NSString *sid, NSString *codeUrl))completion
{
    [self sendRequestWithMethod:@"GET" path:kGetVerifyCodePath parameters:nil completionHandler:^(NSError *error, NSInteger code, id responseObject) {
        if (code != 0) {
            error = error ? error : commonErrorWithJsonData(responseObject);
            if (completion) {
                completion(error, nil, nil);
            }
            return;
        }
        
        NSDictionary *data = responseObject[@"data"];
        self.sid = data[@"sid"];
        if (completion) {
            completion(nil, data[@"sid"], data[@"url"]);
        }
    }];
}

- (void)loginWithUserName:(NSString *)userName
                 password:(NSString *)password
         verificationCode:(NSString *)verificationCode
        completionHandler:(void(^)(NSError *error))completion
{
    NSDictionary *parameters = @{@"username":userName,
                                 @"password":password,
                                 @"verificationCode":verificationCode};
    [self sendRequestWithMethod:@"POST" path:kSignInPath parameters:parameters completionHandler:^(NSError *error, NSInteger code, id responseObject) {
        if (code != 0) {
            error = error ? error : commonErrorWithJsonData(responseObject);
            if (completion) {
                completion(error);
            }
            return;
        }
        
        NSDictionary *jsonData = responseObject[@"data"];
        UserInfo *userInfo = [[UserInfo alloc] initWithDictionary:jsonData error:nil];
        userInfo.userName = userName;
        self.userInfo = userInfo;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginSuccess
                                                            object:self
                                                          userInfo:@{@"userId":userInfo.userId}];
        
        if (completion) {
            completion(nil);
        }
    }];
}

- (void)loginOutWithCompletion:(void(^)(NSError *error))completion
{
    [self sendRequestWithMethod:@"POST" path:kSignOutPath parameters:nil completionHandler:^(NSError *error, NSInteger code, id responseObject) {
        if (code != 0) {
            error = error ? error : commonErrorWithJsonData(responseObject);
            if (completion) {
                completion(error);
            }
            return;
        }
        
        NSString *userId = self.userInfo.userId;
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserLogoutSuccess
                                                            object:self
                                                          userInfo:@{@"userId":userId}];
        
        self.userInfo = nil;
        
        if (completion) {
            completion(nil);
        }
    }];
}

- (void)queryUserInfoWithCompletion:(void(^)(NSError *error, UserInfo *userInfo))completion
{
    [self sendRequestWithMethod:@"GET" path:kGetUserInfoPath parameters:nil completionHandler:^(NSError *error, NSInteger code, id responseObject) {
        if (code != 0) {
            if (completion) {
                error = error ? error : commonErrorWithJsonData(responseObject);
                completion(error, nil);
            }
            return;
        }
        
        NSDictionary *data = responseObject[@"data"];
        NSError *aerror;
        UserInfo *info = [[UserInfo alloc] initWithDictionary:data error:&aerror];
        if (aerror) {
            NSLog(@"error = %@", aerror);
        }
        if (completion) {
            completion(nil, info);
        }
        
    }];
}

- (void)queryUserListWithPath:(NSString *)path
                   parameters:(NSDictionary *)parameters
                   completion:(void(^)(NSError *error, NSArray *userList))completion
{
    [self sendRequestWithMethod:@"GET" path:path parameters:parameters completionHandler:^(NSError *error, NSInteger code, id responseObject) {
        if (code != 0) {
            error = error ? error : commonErrorWithJsonData(responseObject);
            if (completion) {
                completion(error, nil);
            }
            return;
        }
        
        NSArray *dataList = responseObject[@"data"];
        NSMutableArray *result = [NSMutableArray new];
        for (NSDictionary *data in dataList) {
            NSError *error;
            AdminInfo *info = [[AdminInfo alloc] initWithDictionary:data error:&error];
            if (error) {
                NSLog(@"error = %@", error);
            }
            [result addObject:info];
        }
        if (completion) {
            completion(nil, result);
        }
    }];
}

- (void)queryUnauditedUsersWithPageNum:(NSInteger)pageNum
                              pageSize:(NSInteger)pageSize
                            completion:(void(^)(NSError *error, NSArray *userList))completion
{
    NSDictionary *parameters = @{@"page_num":@(pageNum), @"page_size":@(pageSize)};
    [self queryUserListWithPath:kGetUnauditedPath parameters:parameters completion:completion];
}

- (void)auditUserWithUserId:(NSString *)userId
                  isApprove:(BOOL)isApprove
                 completion:(void(^)(NSError *error))completion
{
    NSNumber *approved = isApprove ? @(1):@(2);
    NSDictionary *parameters = @{@"uid":userId, @"is_approve":approved};
    [self sendRequestWithMethod:@"POST" path:kAuditPath parameters:parameters completionHandler:^(NSError *error, NSInteger code, id responseObject) {
        TrainingCallBackBlock
    }];
}

- (void)queryAdminsWithType:(NSInteger)type
                   userName:(NSString *)userName
                       name:(NSString *)name
               departmentId:(NSInteger)departmentId
                     mobile:(NSString *)mobile
                    pageNum:(NSInteger)pageNum
                   pageSize:(NSInteger)pageSize
                 completion:(void(^)(NSError *error, NSArray *adminList))completion
{
    NSMutableDictionary *paramters = [NSMutableDictionary new];
    paramters[@"user_type"] = @(type);
    if (userName.length > 0) {
        paramters[@"username"] = userName;
    }
    if (name.length > 0) {
        paramters[@"name"] = name;
    }
    if (departmentId > 0) {
        paramters[@"department_id"] = @(departmentId);
    }
    if (mobile.length > 0) {
        paramters[@"mobile"] = mobile;
    }
    paramters[@"page_num"] = @(pageNum);
    paramters[@"page_size"] = @(pageSize);
    [self queryUserListWithPath:kGetAdminListPath parameters:paramters completion:completion];
}

- (void)modifyPasswordWithParameters:(NSDictionary *)parameters
                          completion:(void(^)(NSError *error))completion
{
    [self sendRequestWithMethod:@"POST" path:kModifyPasswordPath parameters:parameters completionHandler:^(NSError *error, NSInteger code, id responseObject) {
        TrainingCallBackBlock
    }];
}

- (void)resetPasswordWithParameters:(NSDictionary *)parameters
                         completion:(void(^)(NSError *error))completion
{
    [self sendRequestWithMethod:@"POST" path:kResetPasswordPath parameters:parameters completionHandler:^(NSError *error, NSInteger code, id responseObject) {
        TrainingCallBackBlock
    }];
}

- (void)deleteAdminWithUserId:(NSString *)userId
                   completion:(void(^)(NSError *error))completion
{
    NSDictionary *parameters = @{@"uid":userId};
    [self sendRequestWithMethod:@"POST" path:kDeleteAdminPath parameters:parameters completionHandler:^(NSError *error, NSInteger code, id responseObject) {
        TrainingCallBackBlock
    }];
}

@end
