//
//  MyWalletViewController.m
//  TimeCloud
//
//  Created by lichunwang on 16/11/28.
//  Copyright © 2016年 Xunlei. All rights reserved.
//

#import "UserMainViewController.h"
#import "TrainingDetailViewController.h"
#import "AllTrainingViewController.h"
#import "TrainingInfoTableViewCell.h"
#import "TrainingManager+Course.h"
#import "TrainingSearchViewController.h"
#import <MJRefresh/MJRefresh.h>

@interface UserMainViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *sectionHeaderView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) NSMutableArray *dataList;
@property (strong, nonatomic) WLCEmptyView *emptyView;

@property (assign, nonatomic) BOOL isLoadingData;
@property (assign, nonatomic) NSInteger currentPageNum;

@end

@implementation UserMainViewController

WLC_VIEW_CONTROLLER_INIT

- (void)_init
{
    self.title = @"首页";
    self.dataList = [NSMutableArray new];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [TrainingInfoTableViewCell registerForTableView:self.tableView];
    
    // 去掉navigationbar的一像素黑线
    UINavigationBar *bar = self.navigationController.navigationBar;
    for (UIView *subView in bar.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
            for (UIView *childView in subView.subviews) {
                if ([childView isKindOfClass:[UIImageView class]]) {
                    [childView removeFromSuperview];
                }
            }
        }
    }
    
    [self addRefreshHeader];
    
    [self showLoadingViewWithText:@"正在加载..."];
    [self queryDataListWithPageNum:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.searchBar resignFirstResponder];
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

#pragma mark - Private

- (void)queryDataListWithPageNum:(NSInteger)pageNum
{
    if (self.isLoadingData) {
        return;
    }
    self.isLoadingData = YES;
    
    NSInteger weekday = [NSDate currentWeekday];
    NSDate *monday = nil;
    if (weekday == 1) {
        monday = [[NSDate date] dateByAddingDays:-6];
    }
    else if (weekday == 2) {
        monday = [NSDate date];
    }
    else {
        monday = [[NSDate date] dateByAddingDays:-(weekday-2)];
    }
    NSString *startTime = [NSString stringWithFormat:@"%li-%02li-%02li", [monday year],
                           [monday month], [monday day]];
    NSDateFormatter *dateformatter = [NSDateFormatter new];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [dateformatter dateFromString:startTime];
    NSDate *endDate = [startDate dateByAddingDays:6];
    NSString *endTime = [dateformatter stringFromDate:endDate];
    NSLog(@"startTime = %@", startTime);
    NSLog(@"endTime = %@", endTime);
    
    [[TrainingManager sharedInstance] queryCourseListWithMine:-1
                                                    isExpired:-1
                                                    startTime:startTime
                                                      endTime:endTime
                                                 departmentId:-1
                                                        theme:@""
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
            return;
        }
        
        self.currentPageNum = pageNum;
        if (pageNum == 1) {
            [self.dataList removeAllObjects];
        }
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

#pragma mark - Button action

- (IBAction)onAllTrainingBtnClicked:(id)sender
{
    AllTrainingViewController *allTrainingVC = [AllTrainingViewController instance];
    [self.navigationController pushViewController:allTrainingVC animated:YES];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    TrainingSearchViewController *searchVC = [TrainingSearchViewController instance];
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TrainingInfoTableViewCell *infoCell = [tableView dequeueReusableCellWithIdentifier:[TrainingInfoTableViewCell identifer]];
    CourseInfo *info = self.dataList[indexPath.row];
    [infoCell setCourseInfo:info];
    return infoCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [TrainingInfoTableViewCell height];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TrainingDetailViewController *detailVC = [TrainingDetailViewController new];
    CourseInfo *info = self.dataList[indexPath.row];
    detailVC.cid = info.cid;
    [self.navigationController pushViewController:detailVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
