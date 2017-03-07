//
//  TAAboutMeViewController.m
//  Training
//
//  Created by lichunwang on 16/12/17.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "TAAboutMeViewController.h"
#import "AboutMeTableViewCell.h"
#import "ModifyPwdViewController.h"
#import "ExportViewController.h"
#import "UnauditUserListViewController.h"

typedef NS_ENUM(NSInteger, TAAboutMeCellType)
{
    TAAboutMeCellType_AuditUser,
    TAAboutMeCellType_ExportCourse,
    TAAboutMeCellType_ExportPai,
    TAAboutMeCellType_ModifyPassword
};

@interface TAAboutMeViewController ()

@end

@implementation TAAboutMeViewController

WLC_VIEW_CONTROLLER_INIT

- (void)_init
{
    self.title = @"我的";
}

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
//    return @[@[@(TAAboutMeCellType_AuditUser),@(TAAboutMeCellType_ExportCourse),@(TAAboutMeCellType_ExportPai), @(TAAboutMeCellType_ModifyPassword)]];
    return @[@[@(TAAboutMeCellType_ExportCourse),@(TAAboutMeCellType_ExportPai), @(TAAboutMeCellType_ModifyPassword)]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger cellType = [self cellTypeForIndexPath:indexPath];
    AboutMeTableViewCell *cell = [AboutMeTableViewCell dequeueReusableCellForTableView:tableView];
    switch (cellType) {
        case TAAboutMeCellType_AuditUser:
            cell.titleLabel.text = @"新用户审核";
            break;
            
        case TAAboutMeCellType_ExportCourse:
            cell.titleLabel.text = @"导出课程";
            break;
            
        case TAAboutMeCellType_ExportPai:
            cell.titleLabel.text = @"导出随手拍";
            break;
            
        case TAAboutMeCellType_ModifyPassword:
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
        case TAAboutMeCellType_AuditUser: {
            UnauditUserListViewController *vc = [UnauditUserListViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case TAAboutMeCellType_ExportCourse:
        {
            ExportViewController *exportVC = [ExportViewController new];
            exportVC.title = @"导出培训课程";
            exportVC.exportType = ExportType_Training;
            [self.navigationController pushViewController:exportVC animated:YES];
        }
            break;
            
        case TAAboutMeCellType_ExportPai:
        {
            ExportViewController *exportVC = [ExportViewController new];
            exportVC.title = @"导出随手拍";
            exportVC.exportType = ExportType_Summary;
            [self.navigationController pushViewController:exportVC animated:YES];
        }
            break;
            
        case TAAboutMeCellType_ModifyPassword:
        {
            ModifyPwdViewController *modifyPwdVC = [ModifyPwdViewController new];
            [self.navigationController pushViewController:modifyPwdVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

@end
