//
//  SAAboutMeViewController.m
//  Training
//
//  Created by lichunwang on 16/12/17.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "VAAboutMeViewController.h"
#import "ModifyPwdViewController.h"
#import "ExportViewController.h"
#import "AboutMeTableViewCell.h"
#import "UnauditUserListViewController.h"
#import "ResetPwdViewController.h"

typedef NS_ENUM(NSInteger, SAAboutMeCellType)
{
    VAAboutMeCellType_AuditUser,
    VAAboutMeCellType_ResetPassword,
    VAAboutMeCellType_ModifyPassword
};

@interface VAAboutMeViewController ()

@end

@implementation VAAboutMeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSArray *)onConfigDataSource
{
    return @[@[@(VAAboutMeCellType_AuditUser),@(VAAboutMeCellType_ResetPassword),@(VAAboutMeCellType_ModifyPassword)]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger cellType = [self cellTypeForIndexPath:indexPath];
    AboutMeTableViewCell *cell = [AboutMeTableViewCell dequeueReusableCellForTableView:tableView];
    switch (cellType) {
        case VAAboutMeCellType_AuditUser:
            cell.titleLabel.text = @"新用户审核";
            break;
            
        case VAAboutMeCellType_ResetPassword:
            cell.titleLabel.text = @"重置用户密码";
            break;
            
        case VAAboutMeCellType_ModifyPassword:
            cell.titleLabel.text = @"修改密码";
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableViewDidSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger cellType = [self cellTypeForIndexPath:indexPath];
    switch (cellType) {

        case VAAboutMeCellType_ResetPassword:
            [self.navigationController pushViewController:[ResetPwdViewController new] animated:YES];
            break;

        case VAAboutMeCellType_AuditUser:
            [self.navigationController pushViewController:[UnauditUserListViewController new] animated:YES];
            break;
            
        case VAAboutMeCellType_ModifyPassword:
            [self.navigationController pushViewController:[ModifyPwdViewController new] animated:YES];
            break;
            
        default:
            break;
    }
}

@end
