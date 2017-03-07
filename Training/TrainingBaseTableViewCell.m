//
//  TrainingBaseTableViewCell.m
//  Training
//
//  Created by lichunwang on 16/12/20.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "TrainingBaseTableViewCell.h"

@implementation TrainingBaseTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (CGFloat)height
{
    return 0;
}

+ (NSString *)identifer
{
    return NSStringFromClass(self);
}

+ (void)registerForTableView:(UITableView *)tableView
{
    UINib *nib = [UINib nibWithNibName:[self identifer] bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:[self identifer]];
}

+ (instancetype)dequeueReusableCellForTableView:(UITableView *)tableView
{
    return [tableView dequeueReusableCellWithIdentifier:[self identifer]];
}

@end
