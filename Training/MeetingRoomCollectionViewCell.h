//
//  MeetingRoomCollectionViewCell.h
//  Training
//
//  Created by lichunwang on 16/12/19.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeetingRoomCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *roomNameLabel;

- (void)toggleSelected:(BOOL)selected;

- (void)setRoomColor:(UIColor *)color;

@end
