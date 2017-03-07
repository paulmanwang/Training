//
//  SABaseViewController.m
//  Training
//
//  Created by lichunwang on 16/12/17.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "SAAdminBaseViewController.h"
#import "AdminInfoTableViewCell.h"
#import "AddAdminViewController.h"
#import "TrainingManager+User.h"
#import <MJRefresh/MJRefresh.h>
#import "AdminSearchViewController.h"

@interface SAAdminBaseViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet WLCSearchBar *searchBar;

@property (assign, nonatomic) NSInteger currentPageNum;
@property (assign, nonatomic) BOOL isLoadingData;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

@end

@implementation SAAdminBaseViewController

+ (instancetype)instance
{
    return [[self alloc] initWithNibName:@"SAAdminBaseViewController" bundle:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [AdminInfoTableViewCell registerForTableView:self.tableView];
    
    UIImage *image = [UIImage imageNamed:@"add_icon"];
    UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(onAddButtonClicked)];
    self.navigationItem.rightBarButtonItem = addButtonItem;
    
    [self addRefreshHeader];
    [self addRefreshFooter];
    
    [self showLoadingViewWithText:@"正在加载..."];
    [self queryDataListWithPageNum:1];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.dataList.count > 0) {
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    AdminSearchViewController *searchVC = [AdminSearchViewController instance];
    searchVC.adminType = self.adminType;
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark - Private

- (void)queryDataListWithPageNum:(NSInteger)pageNum
{
    if (self.isLoadingData) {
        return;
    }
    self.isLoadingData = YES;
    
    [[TrainingManager sharedInstance] queryAdminsWithType:self.adminType
                                                 userName:@""
                                                     name:@""
                                             departmentId:-1
                                                   mobile:@""
                                                  pageNum:pageNum
                                                 pageSize:kPageSize
                                               completion:^(NSError *error, NSArray *adminList)
     {
         [self dismissLoadingView];
         self.isLoadingData = NO;
         [self.tableView.mj_header endRefreshing];
         [self.tableView.mj_footer endRefreshing];
         if (error) {
             [WLCToastView toastWithMessage:@"加载失败" error:error];
             [WLCEmptyView showOnView:self.view withText:@"暂无管理员" icon:@"manager_icon"];
             return;
         }
         
         self.currentPageNum = pageNum;
         if (pageNum == 1) {
             [self.dataList removeAllObjects];
             if (adminList.count < kPageSize) {
                 self.tableView.mj_footer.hidden = YES;
             }
             else {
                 self.tableView.mj_footer.hidden = NO;
             }
         }
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

#pragma mark - Button actions

- (void)onAddButtonClicked
{
    AddAdminViewController *addVC = [AddAdminViewController new];
    addVC.adminType = self.adminType;
    [self.navigationController pushViewController:addVC animated:YES];
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
    [cell setAdminInfo:info needApprove:NO];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [AdminInfoTableViewCell height];
}



- (void)deleteDataWithIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"确定要删除该管理员吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }
    
    AdminInfo *adminInfo = self.dataList[self.selectedIndexPath.row];
    [self showLoadingViewWithText:@"正在处理..."];
    [[TrainingManager sharedInstance] deleteAdminWithUserId:adminInfo.userId completion:^(NSError *error) {
        [self dismissLoadingView];
        if (error) {
            [WLCToastView toastWithMessage:@"删除失败" error:error];
        }
        else {
            [WLCToastView toastWithMessage:@"删除成功"];
            [self queryDataListWithPageNum:1];
        }
    }];
}

DeleteDataCodeBlock

@end
