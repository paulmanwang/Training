//
//  TrainingInfoTableViewCell.h
//  Training
//
//  Created by lichunwang on 16/12/20.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainingBaseTableViewCell.h"
#import "CourseInfo.h"

@interface TrainingInfoTableViewCell : TrainingBaseTableViewCell

- (void)setCourseInfo:(CourseInfo *)courseInfo;

@end
