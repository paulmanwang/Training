//
//  AppDelegate.m
//  Training
//
//  Created by lichunwang on 16/12/17.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "UMMessageHelper.h"
#import <Bugly/Bugly.h>
#import <JSPatchPlatform/JSPatch.h>

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self configGlobalNavigationBarAppearance];
    [self configGlobalStatusBarAppearance];
    [self configGlobalTabBarAppearance];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    LoginViewController *loginViewController = [LoginViewController new];
    self.loginViewController = loginViewController;
    UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    self.window.rootViewController = naviController;
    [self.window makeKeyAndVisible];
    
    // 判断是否从通知拉起
    if ([launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]) {
        NSLog(@"从通知拉起");
        self.isLanuchFromNotification = YES;
        self.notificationUserInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    }
    
    [[UMMessageHelper sharedInstance] startWithLauchOptions:launchOptions];
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            //这里可以添加一些自己的逻辑
        } else {
            //点击不允许
            //这里可以添加一些自己的逻辑
        }
    }];
    
    [self configBugly];
    
    [JSPatch startWithAppKey:JSPatchAppKey];
    [JSPatch sync];
    
    // NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    return YES;
}

void uncaughtExceptionHandler(NSException *exception)
{
    NSLog(@"exception = %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
}

- (void)configBugly
{
    [Bugly startWithAppId:BuglyAppID];
}

- (void)configGlobalNavigationBarAppearance
{
    UIColor *whiteColor = [UIColor whiteColor];
    UIColor *naviBarBgColor = [UIColor color255WithRed:42 green:142 blue:188];
    [[UINavigationBar appearance] setBarTintColor:naviBarBgColor];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:whiteColor, NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:18]}];
    [[UINavigationBar appearance] setTintColor:whiteColor];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
}

- (void)configGlobalTabBarAppearance
{
    // 注意，实验证明，tabbar的背景不透明时，vc的view不会延展至tabbar的底部
    // 如果tabbar的背景有任何透明像素，则vc的view会延展至tabbar的底部
    // UIColor *blackColor = [UIColor color255WithRed:0 green:0 blue:0 alpha:0.8];
    UIColor *blackColor = [UIColor color255WithRed:0 green:0 blue:0 alpha:1];
    UIImage *image = [UIImage imageWithColor:blackColor size:CGSizeMake(1, 1)];
    [[UITabBar appearance] setBackgroundImage:image];
    
    UIColor *selectedColor = [UIColor colorWithHexString:@"3676ee"];
    UIColor *unselectedColor = [UIColor colorWithHexString:@"b5babf"];
    
    // Change Selected Image color
    [[UITabBar appearance] setTintColor:selectedColor];
    
    // Change StateNormal text Color and font,
    [[UITabBarItem appearance] setTitleTextAttributes: @{NSForegroundColorAttributeName : unselectedColor,
                                                         NSFontAttributeName : [UIFont boldSystemFontOfSize:11]}
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes: @{NSForegroundColorAttributeName : selectedColor}
                                             forState:UIControlStateSelected];
    
    // [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -4)];
}

- (void)configGlobalStatusBarAppearance
{
    // 设置的正确方法为
    //    1. 在项目的Info.plist文件里设置UIViewControllerBasedStatusBarAppearance为NO。
    //    2. 使用[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];方法设置颜色。
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Push Notification

// 推送的参考文档：http://dev.umeng.com/push/ios/integration
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"deviceToken = %@", deviceToken);
    [UMessage registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"error = %@", error);
}

//iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"push message = %@", userInfo);
    //关闭友盟自带的弹出框
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
    
    [[UMMessageHelper sharedInstance] onDidReceiveRemoteNotification:userInfo];
}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center
      willPresentNotification:(UNNotification *)notification
        withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭友盟自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
        [[UMMessageHelper sharedInstance] onDidReceiveRemoteNotification:userInfo];
    }else{
        //应用处于前台时的本地推送接受
    }
    
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        [[UMMessageHelper sharedInstance] onDidReceiveRemoteNotification:userInfo];
    }else{
        //应用处于后台时的本地推送接受
    }
}

@end
