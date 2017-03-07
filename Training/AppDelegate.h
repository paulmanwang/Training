//
//  AppDelegate.h
//  Training
//
//  Created by lichunwang on 16/12/17.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (assign, nonatomic) BOOL isLanuchFromNotification;
@property (copy, nonatomic) NSDictionary *notificationUserInfo;
@property (strong, nonatomic) LoginViewController *loginViewController;


@end

