//
//  MaterialSearchViewController.m
//  Training
//
//  Created by lichunwang on 17/1/8.
//  Copyright © 2017年 springcome. All rights reserved.
//

#import "MaterialSearchViewController.h"
#import "TrainingManager+Material.h"
#import "MaterialInfo.h"
#import "MaterialInfoTableViewCell.h"
#import "MaterialDetailViewController.h"

@interface MaterialSearchViewController ()

@end

@implementation MaterialSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.searchBar.placeholder = @"请输入资料名称";
    [MaterialInfoTableViewCell registerForTableView:self.tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)queryDataList
{
    [self showLoadingViewWithText:@"正在搜索..."];
    [[TrainingManager sharedInstance] queryMaterialListWithStartTime:@""
                                                             endTime:@""
                                                        departmentId:-1
                                                               theme:self.searchBar.text
                                                             pageNum:1
                                                            pageSize:kPageSize
                                                          compeltion:^(NSError *error, NSArray *materialList)
    {
        [self dismissLoadingView];
        if (error) {
            [WLCToastView toastWithMessage:@"搜索失败" error:error];
            return;
        }
        
        [self.dataList removeAllObjects];
        [self.dataList addObjectsFromArray:materialList];
        [self.tableView reloadData];
        
        if (self.dataList.count == 0) {
            [WLCEmptyView showOnView:self.view withText:@"暂无培训资料" icon:@"material_icon"];
        }
        else {
            [self dismissEmptyView];
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MaterialInfoTableViewCell *cell = [MaterialInfoTableViewCell dequeueReusableCellForTableView:tableView];
    MaterialInfo *info = self.dataList[indexPath.row];
    [cell setMaterialInfo:info];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MaterialDetailViewController *detailVC = [MaterialDetailViewController new];
    MaterialInfo *info = self.dataList[indexPath.row];
    detailVC.materialInfo = info;
    [self.navigationController pushViewController:detailVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
