//
//  AdminInfoTableViewCell.m
//  Training
//
//  Created by lichunwang on 16/12/20.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "AdminInfoTableViewCell.h"

@interface AdminInfoTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *departmentNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileTextField;
@property (weak, nonatomic) IBOutlet UIButton *approveButton;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@property (strong, nonatomic) AdminInfo *adminInfo;

@end

@implementation AdminInfoTableViewCell

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
    return 100;
}

- (void)setAdminInfo:(AdminInfo *)info needApprove:(BOOL)needApprove
{
    self.adminInfo = info;
    
    self.nameLabel.text = [NSString stringWithFormat:@"姓名：%@", info.realName];
    self.userNameLabel.text = [NSString stringWithFormat:@"账号：%@", info.userName];
    self.mobileTextField.text = [NSString stringWithFormat:@"手机：%@", info.mobile];
    self.departmentNameLabel.text = [NSString stringWithFormat:@"单位：%@", info.department.departmentName];
    
    if (needApprove) {
        self.approveButton.hidden = NO;
        self.headerImageView.image = [UIImage imageNamed:@"user_icon"];
    }
    else {
        self.headerImageView.image = [UIImage imageNamed:@"manager_icon"];
    }
}

- (IBAction)onApproveButtonClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(onApproveAdminInfo:)]) {
        [self.delegate onApproveAdminInfo:self.adminInfo];
    }
}

@end
