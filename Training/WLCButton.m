//
//  WLCButton.m
//  Training
//
//  Created by lichunwang on 17/1/11.
//  Copyright © 2017年 springcome. All rights reserved.
//

#import "WLCButton.h"

@implementation WLCButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.cornerRadius = 6;
    self.layer.masksToBounds = YES;
}

@end
