//
//  TrainingBaseTableViewCell.h
//  Training
//
//  Created by lichunwang on 16/12/20.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrainingBaseTableViewCell : UITableViewCell

+ (CGFloat)height;

+ (NSString *)identifer;

+ (void)registerForTableView:(UITableView *)tableView;

+ (instancetype)dequeueReusableCellForTableView:(UITableView *)tableView;

@end
