//
//  MyTrainingViewController.m
//  Training
//
//  Created by lichunwang on 16/12/20.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "MyTrainingViewController.h"
#import "TrainingDetailViewController.h"
#import "TrainingInfoTableViewCell.h"
#import "TrainingManager+Apply.h"
#import "ApplyInfo.h"
#import <MJRefresh/MJRefresh.h>

@interface MyTrainingViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataList;
@property (assign, nonatomic) BOOL isLoadingData;
@property (assign, nonatomic) NSInteger currentPageNum;

@end

@implementation MyTrainingViewController

WLC_VIEW_CONTROLLER_INIT

- (void)_init
{
    self.dataList = [NSMutableArray new];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [TrainingInfoTableViewCell registerForTableView:self.tableView];
    
    [self addRefreshHeader];
    [self addRefreshFooter];
    
    if (self.isSearch) {
        self.navigationItem.titleView = self.searchBar;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButtonClicked:)];
    }
    else {
        [self showLoadingViewWithText:@"正在加载..."];
        [self queryDataListWithPageNum:1];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if ([self.searchBar isFirstResponder]) {
        [self.searchBar resignFirstResponder];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.isSearch) {
        [self queryDataListWithPageNum:1];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Button actions

- (void)onCancelButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Header && Footer

- (void)addRefreshHeader
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (!self.isLoadingData) {
            [self queryDataListWithPageNum:1];
        }
    }];
}

- (void)addRefreshFooter
{
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (!self.isLoadingData) {
            if (self.dataList.count == self.currentPageNum * kPageSize) {
                ((MJRefreshAutoNormalFooter *)self.tableView.mj_footer).stateLabel.text = @"正在加载更多的数据...";
                [self queryDataListWithPageNum:self.currentPageNum+1];
            }
            else {
                [self.tableView.mj_footer endRefreshing];
                ((MJRefreshAutoNormalFooter *)self.tableView.mj_footer).stateLabel.text = @"暂无更多";
            }
        }
    }];
    
    // 默认设置为隐藏
    self.tableView.mj_footer.hidden = YES;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    
    [self showLoadingViewWithText:@"正在加载..."];
    [self queryDataListWithPageNum:1];
}

#pragma mark - Private

- (void)queryDataListWithPageNum:(NSInteger)pageNum
{
    if (self.isLoadingData) {
        return;
    }
    self.isLoadingData = YES;
    
    [[TrainingManager sharedInstance] queryApplyListWithExpired:self.isExpired
                                                      startTime:@""
                                                        endTime:@""
                                                   departmentId:-1
                                                          theme:self.searchBar.text
                                                        pageNum:pageNum
                                                       pageSize:kPageSize
                                                     completion:^(NSError *error, NSArray *dataList)
    {
        [self dismissLoadingView];
        self.isLoadingData = NO;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (error) {
            [WLCToastView toastWithMessage:@"加载失败" error:error];
            [WLCEmptyView showOnView:self.view withText:@"暂无培训安排" icon:@"training_info_icon"];
            return;
        }
        
        self.currentPageNum = pageNum;
        if (pageNum == 1) {
            [self.dataList removeAllObjects];
            if (dataList.count < kPageSize) {
                self.tableView.mj_footer.hidden = YES;
            }
            else {
                self.tableView.mj_footer.hidden = NO;
            }
        }
        [self.dataList addObjectsFromArray:dataList];
        [self.tableView reloadData];
        
        if (self.dataList.count == 0) {
            [WLCEmptyView showOnView:self.view withText:@"暂无培训安排" icon:@"training_info_icon"];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TrainingInfoTableViewCell *cell = [TrainingInfoTableViewCell dequeueReusableCellForTableView:tableView];
    ApplyInfo *info = self.dataList[indexPath.row];
    [cell setCourseInfo:info.courseInfo];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [TrainingInfoTableViewCell height];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TrainingDetailViewController *detailVC = [TrainingDetailViewController new];
    ApplyInfo *info = self.dataList[indexPath.row];
    detailVC.cid = info.cid;
    [self.navigationController pushViewController:detailVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
