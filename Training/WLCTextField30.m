//
//  WLCTextField.m
//  Training
//
//  Created by lichunwang on 16/12/21.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "WLCTextField30.h"

@implementation WLCTextField30

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.height = 32;
    
    self.clipsToBounds = YES;
    self.borderStyle = UITextBorderStyleRoundedRect;
    self.backgroundColor = [UIColor whiteColor];
    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 12, self.height)];
//    label.backgroundColor = [UIColor whiteColor];
//    label.layer.borderWidth = 1;
//    label.layer.backgroundColor = [UIColor blackColor].CGColor;
//    self.rightView = label;
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 28, self.height)];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(1, 5, 1, 22)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(9, 15, 12, 6)];
    imageView.image = [UIImage imageNamed:@"xljt"];
    lineView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    [rightView addSubview:lineView];
    [rightView addSubview:imageView];
    
    rightView.userInteractionEnabled = NO;
    
    self.rightView = rightView;
    self.rightViewMode = UITextFieldViewModeAlways;
}

@end
