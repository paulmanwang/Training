//
//  RoomInfoTableViewCell.m
//  Training
//
//  Created by lichunwang on 16/12/20.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "RoomInfoTableViewCell.h"

@interface RoomInfoTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UIButton *handleButton;
@property (weak, nonatomic) IBOutlet UILabel *freeLabel;

@property (strong, nonatomic) RoomArrangementInfo *info;
@property (assign, nonatomic) NSInteger time;

@end

@implementation RoomInfoTableViewCell

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
    return 88;
}

- (void)setArrangementInfo:(RoomArrangementInfo *)info withTime:(NSInteger)time
{
    self.info = info;
    self.time = time;
    
    if (time == 1) {
        self.timeLabel.text = @"上午";
    }
    else if (time == 2) {
        self.timeLabel.text = @"中午";
    }
    else {
        self.timeLabel.text = @"晚上";
    }
    
    if (info == nil) {
        self.departmentLabel.hidden = YES;
        self.nameLabel.hidden = YES;
        self.mobileLabel.hidden = YES;
        self.freeLabel.hidden = NO;
        [self.handleButton setTitle:@"分配"];
        return;
    }
    
    self.departmentLabel.hidden = NO;
    self.nameLabel.hidden = NO;
    self.mobileLabel.hidden = NO;
    self.freeLabel.hidden = YES;
    [self.handleButton setTitle:@"修改"];
    
    self.departmentLabel.text = [NSString stringWithFormat:@"申请单位：%@", info.departmentInfo.departmentName];
    self.nameLabel.text = [NSString stringWithFormat:@"申请人：%@", info.name];
    self.mobileLabel.text = [NSString stringWithFormat:@"联系电话：%@", info.mobile];
}


- (IBAction)onHandleButtonClicked:(id)sender
{
    if (self.info == nil) {
        if ([self.delegate respondsToSelector:@selector(onAllocateWithTime:)]) {
            [self.delegate onAllocateWithTime:self.time];
        }
    }
    else {
        if ([self.delegate respondsToSelector:@selector(onModifyWithArragementInfo:time:)]) {
            [self.delegate onModifyWithArragementInfo:self.info time:self.time];
        }
    }
}

@end
