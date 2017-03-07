//
//  PublishTrainingViewController.h
//  Training
//
//  Created by lichunwang on 16/12/19.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomArrangementInfo.h"

@interface AllocateRoomViewController : UIViewController

@property (copy, nonatomic) NSString *arrangementDate;
@property (assign, nonatomic) NSInteger arrangementTime;
@property (assign, nonatomic) NSInteger roomId;

// 修改时需要传
@property (strong, nonatomic) RoomArrangementInfo *arrangementInfo;

@end
