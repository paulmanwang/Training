//
//  RefreshBaseViewController.m
//  Training
//
//  Created by lichunwang on 17/1/17.
//  Copyright © 2017年 springcome. All rights reserved.
//

#import "DataListViewController.h"
#import <MJRefresh/MJRefresh.h>

@interface DataListViewController ()

@end

@implementation DataListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataList = [NSMutableArray new];
    
    [self addRefreshHeader];
    [self addRefreshFooter];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)queryDataListWithPageNum:(NSInteger)pageNum
{
    // for subclassing
}

- (void)addRefreshHeader
{
    UITableView *tableView = [self valueForKey:@"tableView"];
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (!self.isLoadingData) {
            [self queryDataListWithPageNum:1];
        }
    }];
}

- (void)addRefreshFooter
{
    UITableView *tableView = [self valueForKey:@"tableView"];
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (!self.isLoadingData) {
            if (self.dataList.count == self.currentPageNum * kPageSize) {
                ((MJRefreshAutoNormalFooter *)tableView.mj_footer).stateLabel.text = @"正在加载更多的数据...";
                [self queryDataListWithPageNum:self.currentPageNum+1];
            }
            else {
                [tableView.mj_footer endRefreshing];
                ((MJRefreshAutoNormalFooter *)tableView.mj_footer).stateLabel.text = @"暂无更多";
            }
        }
    }];
    
    // 默认设置为隐藏
    tableView.mj_footer.hidden = YES;
}


@end
