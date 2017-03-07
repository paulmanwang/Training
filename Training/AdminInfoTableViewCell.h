//
//  AdminInfoTableViewCell.h
//  Training
//
//  Created by lichunwang on 16/12/20.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainingBaseTableViewCell.h"
#import "AdminInfo.h"

@protocol  AdminInfoTableViewCellDelegate <NSObject>

- (void)onApproveAdminInfo:(AdminInfo *)adminInfo;

@end

@interface AdminInfoTableViewCell : TrainingBaseTableViewCell

@property (weak, nonatomic) id<AdminInfoTableViewCellDelegate> delegate;

- (void)setAdminInfo:(AdminInfo *)info needApprove:(BOOL)needApprove;

@end
