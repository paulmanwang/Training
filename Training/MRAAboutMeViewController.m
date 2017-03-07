//
//  RoomAdminAboutMeViewController.m
//  Training
//
//  Created by lichunwang on 16/12/17.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "MRAAboutMeViewController.h"
#import "ModifyPwdViewController.h"
#import "ExportViewController.h"
#import "AboutMeTableViewCell.h"

typedef NS_ENUM(NSInteger, UserAboutMeCellType)
{
    MRAAboutMeCellType_Export,
    MRAAboutMeCellType_ModifyPassword
};

@interface MRAAboutMeViewController ()

@end

@implementation MRAAboutMeViewController


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
    return @[@[@(MRAAboutMeCellType_Export), @(MRAAboutMeCellType_ModifyPassword)]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger cellType = [self cellTypeForIndexPath:indexPath];
    AboutMeTableViewCell *cell = [AboutMeTableViewCell dequeueReusableCellForTableView:tableView];
    switch (cellType) {
        case MRAAboutMeCellType_Export:
            cell.titleLabel.text = @"导出会议室使用情况";
            break;
            
        case MRAAboutMeCellType_ModifyPassword:
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
        case MRAAboutMeCellType_Export:
        {
            ExportViewController *exportVC = [ExportViewController new];
            exportVC.title = @"导出会议室使用情况";
            exportVC.exportType = ExportType_RoomArrangement;
            [self.navigationController pushViewController:exportVC animated:YES];
        }
            break;
            
        case MRAAboutMeCellType_ModifyPassword:
            [self.navigationController pushViewController:[ModifyPwdViewController new] animated:YES];
            break;
            
        default:
            break;
    }
}

@end
