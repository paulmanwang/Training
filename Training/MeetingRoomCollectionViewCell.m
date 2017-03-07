//
//  MeetingRoomCollectionViewCell.m
//  Training
//
//  Created by lichunwang on 16/12/19.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "MeetingRoomCollectionViewCell.h"

@interface  MeetingRoomCollectionViewCell()


@end

@implementation MeetingRoomCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.roomNameLabel.layer.borderWidth = 1;
    self.roomNameLabel.layer.borderColor = [UIColor blackColor].CGColor;
}

- (void)toggleSelected:(BOOL)selected
{
    if (selected) {
        self.roomNameLabel.backgroundColor = [UIColor color255WithRed:42 green:142 blue:188];
    }
    else {
        self.roomNameLabel.backgroundColor = [UIColor whiteColor];
    }
}

- (void)setRoomColor:(UIColor *)color
{
    self.roomNameLabel.backgroundColor = color;
//    if (idle) {
//        self.roomNameLabel.backgroundColor = [UIColor color255WithRed:0 green:255 blue:0 alpha:0.5f];
//    }
//    else {
//        self.roomNameLabel.backgroundColor = [UIColor color255WithRed:255 green:0 blue:0 alpha:0.5f];
//    }
}

@end
