//
//  UnauditUserListViewController.m
//  Training
//
//  Created by lichunwang on 16/12/26.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "UnauditUserListViewController.h"
#import "AdminInfo.h"
#import "TrainingManager+User.h"
#import "AdminInfoTableViewCell.h"
#import <MJRefresh/MJRefresh.h>

@interface UnauditUserListViewController ()<UITableViewDataSource, UITableViewDelegate, AdminInfoTableViewCellDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) NSMutableArray *dataList;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) AdminInfo *deletedAdminInfo;

@property (assign, nonatomic) NSInteger currentPageNum;
@property (assign, nonatomic) BOOL isLoadingData;

@end

@implementation UnauditUserListViewController

WLC_VIEW_CONTROLLER_INIT

- (void)_init
{
    self.title = @"新用户审核";
    self.hidesBottomBarWhenPushed = YES;
    self.dataList = [NSMutableArray new];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [AdminInfoTableViewCell registerForTableView:self.tableView];
    
    [self addRefreshHeader];
    [self addRefreshFooter];
    
    [self showLoadingViewWithText:@"正在加载..."];
    [self queryDataListWithPageNum:1];
}

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

- (void)queryDataListWithPageNum:(NSInteger)pageNum
{
    if (self.isLoadingData) {
        return;
    }
    self.isLoadingData = YES;
    
    [[TrainingManager sharedInstance] queryUnauditedUsersWithPageNum:pageNum
                                                            pageSize:kPageSize
                                                          completion:^(NSError *error, NSArray *dataList)
     {
        [self dismissLoadingView];
         self.isLoadingData = NO;
         [self.tableView.mj_header endRefreshing];
         [self.tableView.mj_footer endRefreshing];
        if (error) {
            [WLCToastView toastWithMessage:@"加载失败"];
            [WLCEmptyView showOnView:self.view withText:@"暂无未审核用户" icon:@"user_icon"];
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
            [WLCEmptyView showOnView:self.view withText:@"暂无未审核用户" icon:@"user_icon"];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AdminInfoTableViewCell *cell = [AdminInfoTableViewCell dequeueReusableCellForTableView:tableView];
    AdminInfo *info = self.dataList[indexPath.row];
    [cell setAdminInfo:info needApprove:YES];
    cell.delegate = self;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [AdminInfoTableViewCell height];
}

#pragma mark - AdminInfoTableViewCellDelegate

- (void)onApproveAdminInfo:(AdminInfo *)adminInfo
{
    self.deletedAdminInfo = adminInfo;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"确定审核通过该用户？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"通过", @"不通过", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }
    
    BOOL isApprove = NO;
    if (buttonIndex == 1) {
        isApprove = YES;
    }
    
    [self showLoadingViewWithText:@"正在处理..."];
    [[TrainingManager sharedInstance] auditUserWithUserId:self.deletedAdminInfo.userId isApprove:isApprove completion:^(NSError *error) {
        [self dismissLoadingView];
        if (error) {
            [WLCToastView toastWithMessage:@"操作失败" error:error];
        }
        else {
            [WLCToastView toastWithMessage:@"操作成功"];
            [self queryDataListWithPageNum:1];
        }
    }];
}

@end
