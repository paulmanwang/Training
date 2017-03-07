//
//  UserAboutMeViewController.m
//  Training
//
//  Created by lichunwang on 16/12/17.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "UserAboutMeViewController.h"
#import "ModifyPwdViewController.h"
#import "MyTrainingMainViewController.h"
#import "AboutMeTableViewCell.h"
#import "MyMessageViewController.h"

typedef NS_ENUM(NSInteger, UserAboutMeCellType)
{
    UserAboutMeCellType_MyTraining,
    UserAboutMeCellType_MyMessage,
    UserAboutMeCellType_ModifyPassword
};

@interface UserAboutMeViewController ()

@end

@implementation UserAboutMeViewController

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
    return @[@[@(UserAboutMeCellType_MyTraining),@(UserAboutMeCellType_MyMessage), @(UserAboutMeCellType_ModifyPassword)]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger cellType = [self cellTypeForIndexPath:indexPath];
    AboutMeTableViewCell *cell = [AboutMeTableViewCell dequeueReusableCellForTableView:tableView];
    switch (cellType) {
        case UserAboutMeCellType_MyTraining:
            cell.titleLabel.text = @"我报名的培训";
            break;
            
        case UserAboutMeCellType_MyMessage:
            cell.titleLabel.text = @"我的消息";
            break;
            
        case UserAboutMeCellType_ModifyPassword:
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
        case UserAboutMeCellType_MyTraining:
        {
            MyTrainingMainViewController *myTrainingMainVC = [MyTrainingMainViewController new];
            [self.navigationController pushViewController:myTrainingMainVC animated:YES];
        }
            break;
            
        case UserAboutMeCellType_MyMessage:
        {
            MyMessageViewController *messageVC = [MyMessageViewController new];
            [self.navigationController pushViewController:messageVC animated:YES];
        }
            break;
            
        case UserAboutMeCellType_ModifyPassword:
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
