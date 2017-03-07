//
//  TrainingInfoTableViewCell.m
//  Training
//
//  Created by lichunwang on 16/12/20.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "MaterialInfoTableViewCell.h"

@interface MaterialInfoTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@end

@implementation MaterialInfoTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

+ (CGFloat)height
{
    return 93;
}

- (void)setMaterialInfo:(MaterialInfo *)info
{
    self.nameLabel.text = info.theme;
    self.timeLabel.text = [NSString stringWithFormat:@"上传时间：%@", [info.createTime substringToIndex:16]];
    self.userNameLabel.text = [NSString stringWithFormat:@"上传单位：%@", info.department.departmentName];
}

@end
