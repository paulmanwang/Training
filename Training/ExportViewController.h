//
//  PublishTrainingViewController.h
//  Training
//
//  Created by lichunwang on 16/12/19.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ExportType)
{
    ExportType_Training,
    ExportType_Summary,
    ExportType_RoomArrangement
};

@interface ExportViewController : UIViewController

@property (assign, nonatomic) ExportType exportType;

@end
