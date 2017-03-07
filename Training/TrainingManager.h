//
//  TrainingManager.h
//  Training
//
//  Created by lichunwang on 16/12/22.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "UserInfo.h"
#import "AdminInfo.h"

@interface TrainingManager : NSObject

WLC_DECLARA_SHARED_INSTANCE

@property (strong, nonatomic) UserInfo *userInfo;
@property (copy, nonatomic) NSString *sid;
@property (copy, nonatomic) NSArray *departmentList;

@property (strong, nonatomic) AFHTTPSessionManager *httpSessionManager;

NSError* commonErrorWithJsonData(NSDictionary *jsonData);

- (void)sendRequestWithMethod:(NSString *)method
                         path:(NSString *)path
                   parameters:(NSDictionary *)parameters
            completionHandler:(void(^)(NSError *error, NSInteger code, id responseObject))completionHandler;

@end
