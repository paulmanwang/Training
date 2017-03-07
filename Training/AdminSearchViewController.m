//
//  AdminSearchViewController.m
//  Training
//
//  Created by lichunwang on 17/1/17.
//  Copyright © 2017年 springcome. All rights reserved.
//

#import "AdminSearchViewController.h"
#import "AdminInfo.h"
#import "AdminInfoTableViewCell.h"

@interface AdminSearchViewController ()

@end

@implementation AdminSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.allowsSelection = NO;
    
    [AdminInfoTableViewCell registerForTableView:self.tableView];
    
    self.searchBar.placeholder = @"请输入管理员姓名";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)queryDataList
{
    [self showLoadingViewWithText:@"正在搜索..."];
    [[TrainingManager sharedInstance] queryAdminsWithType:self.adminType
                                                 userName:@""
                                                     name:self.searchBar.text
                                             departmentId:-1
                                                   mobile:@""
                                                  pageNum:1
                                                 pageSize:kPageSize
                                               completion:^(NSError *error, NSArray *adminList)
     {
         [self dismissLoadingView];
         if (error) {
             [WLCToastView toastWithMessage:@"搜索失败" error:error];
             return;
         }
        
         [self.dataList removeAllObjects];
         [self.dataList addObjectsFromArray:adminList];
         [self.tableView reloadData];
        
         if (self.dataList.count == 0) {
             [WLCEmptyView showOnView:self.view withText:@"暂无管理员" icon:@"manager_icon"];
         }
         else {
             [self dismissEmptyView];
         }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [AdminInfoTableViewCell height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AdminInfoTableViewCell *cell = [AdminInfoTableViewCell dequeueReusableCellForTableView:tableView];
    AdminInfo *info = self.dataList[indexPath.row];
    [cell setAdminInfo:info needApprove:NO];
    return cell;
}

@end
