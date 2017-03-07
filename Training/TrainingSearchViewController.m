//
//  TrainingSearchViewController.m
//  Training
//
//  Created by lichunwang on 17/1/5.
//  Copyright © 2017年 springcome. All rights reserved.
//

#import "TrainingSearchViewController.h"
#import "TrainingManager+Course.h"
#import "TrainingInfoTableViewCell.h"

@interface TrainingSearchViewController ()

@end

@implementation TrainingSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [TrainingInfoTableViewCell registerForTableView:self.tableView];
    
    self.searchBar.placeholder = @"请输入培训主题";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)queryDataList
{
    [self showLoadingViewWithText:@"正在搜索..."];
    [[TrainingManager sharedInstance] queryCourseListWithMine:-1
                                                    isExpired:-1
                                                    startTime:@""
                                                      endTime:@""
                                                 departmentId:-1
                                                        theme:self.searchBar.text
                                                      pageNum:1
                                                     pageSize:50
                                                   completion:^(NSError *error, NSArray *dataList)
     {
        [self dismissLoadingView];
        if (error) {
            [WLCToastView toastWithMessage:@"搜索失败" error:error];
            return;
        }
        
        [self.dataList removeAllObjects];
        [self.dataList addObjectsFromArray:dataList];
        [self.tableView reloadData];
        
        if (self.dataList.count == 0) {
            [WLCEmptyView showOnView:self.view withText:@"暂无培训安排" icon:@"training_info_icon"];
        }
        else {
            [self dismissEmptyView];
        }
    }];
}

@end
