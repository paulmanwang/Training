//
//  PaiSearchViewController.m
//  Training
//
//  Created by lichunwang on 17/1/5.
//  Copyright © 2017年 springcome. All rights reserved.
//

#import "SummarySearchViewController.h"
#import "TrainingManager+Summary.h"
#import "TrainingInfoTableViewCell.h"

@interface SummarySearchViewController ()

@end

@implementation SummarySearchViewController

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
    [[TrainingManager sharedInstance] querySummaryListWithMine:-1
                                                     isExpired:NO
                                                     startTime:@""
                                                       endTime:@""
                                                  departmentId:-1
                                                         theme:self.searchBar.text
                                                       pageNum:1
                                                      pageSize:50
                                                    completion:^(NSError *error, NSArray *dataList) {
        [self dismissLoadingView];
        if (error) {
            [WLCToastView toastWithMessage:@"搜索失败" error:error];
            return;
        }
        
        [self.dataList removeAllObjects];
        [self.dataList addObjectsFromArray:dataList];
        [self.tableView reloadData];
        
        if (self.dataList.count == 0) {
            [WLCEmptyView showOnView:self.view withText:@"暂无随手拍" icon:@"summary_icon"];
        }
        else {
            [self dismissEmptyView];
        }
    }];
}

@end
