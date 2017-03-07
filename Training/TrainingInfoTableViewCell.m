//
//  TrainingInfoTableViewCell.m
//  Training
//
//  Created by lichunwang on 16/12/20.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "TrainingInfoTableViewCell.h"
#import "TrainingManager+User.h"
#import <AFNetworking/UIImageView+AFNetworking.h>


@interface TrainingInfoTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;


@property (strong, nonatomic) CourseInfo *courseInfo;

@end

@implementation TrainingInfoTableViewCell

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

- (void)setCourseInfo:(CourseInfo *)courseInfo
{
    _courseInfo = courseInfo;
    
    self.subjectLabel.text = courseInfo.theme;
    if (courseInfo.sid.length > 0) {
        self.timeLabel.text = [NSString stringWithFormat:@"上传时间：%@", [courseInfo.createTime substringToIndex:16]];
        self.placeLabel.text = [NSString stringWithFormat:@"上传单位：%@", courseInfo.departmentName];
    }
    else {
        NSString *startTime = [courseInfo.startTime substringToIndex:(courseInfo.startTime.length - 3)];
        NSRange range = NSMakeRange(11,5);
        NSString *endTime = [courseInfo.endTime substringWithRange:range];
        if ([UIScreen isNarrowScreen]) {
            NSString *timeString = [NSString stringWithFormat:@"培训时间：%@-%@", startTime, endTime];
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:timeString];
            [attrString setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],
                                        NSForegroundColorAttributeName:[UIColor colorWithHexString:@"444444"]} range:NSMakeRange(0, 5)];
            [attrString setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],
                                        NSForegroundColorAttributeName:[UIColor colorWithHexString:@"444444"]} range:NSMakeRange(5, timeString.length - 5)];
            self.timeLabel.attributedText = attrString;
        }
        else {
            self.timeLabel.text = [NSString stringWithFormat:@"培训时间：%@-%@", startTime, endTime];
        }
        
        self.placeLabel.text = [NSString stringWithFormat:@"培训地点：%@", courseInfo.place];
    }
    
    if (courseInfo.sid.length > 0) {
        [self setThumbnailImage];
    }
}

- (void)setThumbnailImage
{
    UIImage *image = [UIImage imageNamed:@"summary_icon"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kServerBaseUrl, self.courseInfo.picture]];
    [self.thumbnailImageView setImageWithURL:url placeholderImage:image];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

@end
