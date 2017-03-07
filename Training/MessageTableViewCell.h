//
//  MessageTableViewCell.h
//  Training
//
//  Created by lichunwang on 16/12/21.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainingBaseTableViewCell.h"
#import "MessageInfo.h"

@interface MessageTableViewCell : TrainingBaseTableViewCell

- (void)setMessageInfo:(MessageInfo *)info;

@end
