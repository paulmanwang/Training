//
//  WLCSearchBar.m
//  Training
//
//  Created by lichunwang on 16/12/28.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "WLCSearchBar.h"

@implementation WLCSearchBar

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // 去掉一像素黑线
    UIColor *backgroundColor = self.barTintColor;
    self.backgroundImage = [UIImage imageWithColor:backgroundColor size:CGSizeMake(1, 1)];
}

@end
