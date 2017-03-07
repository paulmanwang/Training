//
//  MessageTableViewCell.m
//  Training
//
//  Created by lichunwang on 16/12/21.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "MessageTableViewCell.h"


@interface MessageTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *messageTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation MessageTableViewCell

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
    return 83;
}

- (void)setMessageInfo:(MessageInfo *)info
{
    if (info.messageType == 1) {
        self.messageTitleLabel.text = @"参加培训通知";
        NSRange range = {5, 11};
        NSString *startTime = [info.startTime substringWithRange:range];
        self.contentLabel.text = [NSString stringWithFormat:@"您报名的培训\"%@\"，将于%@在%@举行，请准时参加。", info.theme, startTime, info.place];
    }
    else if (info.messageType == 2) {
        self.messageTitleLabel.text = @"培训变更通知";
        self.contentLabel.text = [NSString stringWithFormat:@"您报名的培训\"%@\"，管理员已修改，请查看详情。", info.theme];
    }
    else if (info.messageType == 3) {
        self.messageTitleLabel.text = @"培训取消通知";
        self.contentLabel.text = [NSString stringWithFormat:@"您报名的培训\"%@\"，已被管理员取消，请知悉。", info.theme];
    }

    NSRange range = {5 ,11};
    self.timeLabel.text = [info.createTime substringWithRange:range];
}


@end
