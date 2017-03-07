//
//  UMPushHelper.h
//  Training
//
//  Created by lichunwang on 16/12/28.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMessage.h"

@interface UMMessageHelper : NSObject

WLC_DECLARA_SHARED_INSTANCE

- (void)startWithLauchOptions:(NSDictionary *)launchOptions;

- (void)onDidReceiveRemoteNotification:(NSDictionary *)userInfo;

@end
