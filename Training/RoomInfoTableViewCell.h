//
//  RoomInfoTableViewCell.h
//  Training
//
//  Created by lichunwang on 16/12/20.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainingBaseTableViewCell.h"
#import "RoomArrangementInfo.h"

@protocol RoomInfoTableViewCellDelegate <NSObject>

- (void)onModifyWithArragementInfo:(RoomArrangementInfo *)info time:(NSInteger)time;
- (void)onAllocateWithTime:(NSInteger)time;

@end

@interface RoomInfoTableViewCell : TrainingBaseTableViewCell

@property (weak, nonatomic) id<RoomInfoTableViewCellDelegate> delegate;

- (void)setArrangementInfo:(RoomArrangementInfo *)info withTime:(NSInteger)time;


@end
