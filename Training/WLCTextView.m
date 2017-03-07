//
//  WLCTextView.m
//  Training
//
//  Created by lichunwang on 17/1/14.
//  Copyright © 2017年 springcome. All rights reserved.
//

#import "WLCTextView.h"

@implementation WLCTextView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
}

@end
