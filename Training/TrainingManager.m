//
//  TrainingManager.m
//  Training
//
//  Created by lichunwang on 16/12/22.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "TrainingManager.h"
#import "AppDelegate.h"

@interface TrainingManager ()

@end

@implementation TrainingManager

WLC_IMPLEMENTATE_SHARED_INSTANCE(TrainingManager)

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.httpSessionManager = [AFHTTPSessionManager manager];
        self.httpSessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.httpSessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        self.httpSessionManager.requestSerializer.timeoutInterval = 30.0f;
    }
    
    return self;
}

- (void)logout
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow resignKeyWindow];
    keyWindow.hidden = YES;
    keyWindow = nil;
    [WLCToastView toastWithMessage:@"您已在其他设备上登录"];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.loginViewController queryVerifyCode];
}

- (void)sendRequestWithMethod:(NSString *)method
                         path:(NSString *)path
                   parameters:(NSDictionary *)parameters
            completionHandler:(void(^)(NSError *error, NSInteger code, id responseObject))completionHandler
{
    // 带上cookie
    if (self.userInfo.userId.length > 0) {
        NSString *strCookie = [NSString stringWithFormat:@"uid=%@; skey=%@", self.userInfo.userId, self.userInfo.skey];
        [self.httpSessionManager.requestSerializer setValue:strCookie forHTTPHeaderField:@"Cookie"];
    }
    else {
        if (self.sid.length > 0) {
            NSString *strCookie = [NSString stringWithFormat:@"sid=%@", self.sid];
            [self.httpSessionManager.requestSerializer setValue:strCookie forHTTPHeaderField:@"Cookie"];
        }
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@", kServerBaseUrl, path];
    
    void(^successBlock)(NSURLSessionDataTask *task, id responseObject) = ^(NSURLSessionDataTask *task,id responseObject){
        if (completionHandler) {
            NSDictionary *jsonData = (NSDictionary *)responseObject;
            NSLog(@"%@ path = %@ responseObject = %@", NSStringFromSelector(_cmd), path, jsonData);
            NSInteger code = [jsonData[@"code"] integerValue];
            if (code == 403) {
                [self logout];
            }
            else {
                completionHandler(nil, code, responseObject);
            }
        }
    };
    void(^failureBlock)(NSURLSessionDataTask *task, NSError *error) = ^(NSURLSessionDataTask *task, NSError *error){
        if (completionHandler) {
            completionHandler(error, -1, nil);
        }
    };
    
    if ([method isEqualToString:@"POST"]) {
        [self.httpSessionManager POST:url parameters:parameters progress:nil success:successBlock failure:failureBlock];
    }
    else if ([method isEqualToString:@"GET"]) {
        [self.httpSessionManager GET:url parameters:parameters progress:nil success:successBlock failure:failureBlock];
    }
    else if ([method isEqualToString:@"PUT"]) {
        [self.httpSessionManager PUT:url parameters:parameters success:successBlock failure:failureBlock];
    }
    else if ([method isEqualToString:@"DELETE"]) {
        [self.httpSessionManager DELETE:url parameters:parameters success:successBlock failure:failureBlock];
    }
}

NSError* commonErrorWithJsonData(NSDictionary *jsonData)
{
    NSInteger code = [jsonData[@"code"] integerValue];
    NSString *message = jsonData[@"msg"];
    
    return [NSError errorWithDomain:@"TrainingManager Error Domain" code:code userInfo:@{@"message":message}];
}

@end
