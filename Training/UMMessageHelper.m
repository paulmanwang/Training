//
//  UMPushHelper.m
//  Training
//
//  Created by lichunwang on 16/12/28.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "UMMessageHelper.h"
#import "TrainingDetailViewController.h"
#import "MyMessageViewController.h"
#import "AppDelegate.h"

@implementation UMMessageHelper

WLC_IMPLEMENTATE_SHARED_INSTANCE(UMMessageHelper)

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUserLoginSuccess:) name:kUserLoginSuccess object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUserLogoutSuccess:) name:kUserLogoutSuccess object:nil];
    }
    
    return self;
}

#pragma mark - Notifications

- (void)onUserLoginSuccess:(NSNotification *)notification
{
    [UMessage registerForRemoteNotifications];
    NSString *userId = notification.userInfo[@"userId"];
    [self addAlias:userId];
}

- (void)onUserLogoutSuccess:(NSNotification *)notification
{
    //暂时不移除别名
    
//    [UMessage unregisterForRemoteNotifications];
//    NSString *userId = notification.userInfo[@"userId"];
//    [self removeAlias:userId];
}

#pragma mark - Private

- (void)addAlias:(NSString *)aliasId
{
    [UMessage setAlias:aliasId type:UMengAliasType response:^(id responseObject, NSError *error) {
        if (error) {
            NSLog(@"add alias type error: %@", error.localizedDescription);
        }else {
            NSLog(@"add alias type success: %@", responseObject);
        }
    }];
}

- (void)removeAlias:(NSString *)aliasId
{
    [UMessage removeAlias:aliasId type:UMengAliasType response:^(id responseObject, NSError *error) {
        if (error) {
            NSLog(@"remove alias type error: %@", error.localizedDescription);
        }else {
            NSLog(@"remove alias type success: %@", responseObject);
        }
    }];
}

#pragma mark - Public

- (void)startWithLauchOptions:(NSDictionary *)launchOptions
{
    [UMessage startWithAppkey:UMengAppKey launchOptions:launchOptions];
#ifdef DEBUG
    [UMessage setLogEnabled:YES];
#endif
    [UMessage registerForRemoteNotifications];
}

- (void)onDidReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // 判断前台还是后台做不同的交互
//    UIApplicationState state = [UIApplication sharedApplication].applicationState;
//    if (state == UIApplicationStateActive) {
//    }
//    else if (state == UIApplicationStateBackground) {
//    }
//
    // 判断是否登录
    if ([TrainingManager sharedInstance].userInfo == nil) {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        delegate.isLanuchFromNotification = YES;
        delegate.notificationUserInfo  = userInfo;
        return;
    }
    
    NSInteger messageType = [userInfo[@"message_type"] integerValue];
    UIWindow *topWindow = [WLCToastView topWindow];
    UIViewController *rootViewController = topWindow.rootViewController;
    NSLog(@"rootViewController = %@", rootViewController);
    UIViewController *skipViewController = nil;
    if (messageType == 1 || messageType == 2) {
        // 跳转至详情页
        TrainingDetailViewController *detailViewController = [TrainingDetailViewController new];
        detailViewController.cid = userInfo[@"cid"];
        skipViewController = detailViewController;
    }
    else {
        // 跳转至消息页
        MyMessageViewController *messageViewController = [MyMessageViewController new];
        skipViewController = messageViewController;
    }
    
    [rootViewController presentViewControllerWithNavi:skipViewController completion:nil];
}

@end
