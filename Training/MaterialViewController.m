//
//  TrainingResViewController.m
//  Training
//
//  Created by lichunwang on 16/12/17.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "MaterialViewController.h"
#import "MaterialInfoTableViewCell.h"
#import "TrainingManager+Material.h"
#import "PublishMaterialViewController.h"
#import "TrainingManager+User.h"
#import "WLCSearchBar.h"
#import "MaterialSearchViewController.h"
#import "MaterialDetailViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "WLCTextField30.h"

@interface MaterialViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataList;
@property (weak, nonatomic) IBOutlet WLCTextField30 *monthTextField;
@property (weak, nonatomic) IBOutlet WLCTextField30 *departmentTextField;

@property (assign, nonatomic) NSInteger selectedMonth;
@property (assign, nonatomic) BOOL isLoadingData;
@property (assign, nonatomic) NSInteger currentPageNum;

@property (copy, nonatomic) NSString *deletedMid;
@property (assign, nonatomic) BOOL selectedDepartmentIndex;
@property (strong, nonatomic) NSMutableArray *departmentList;

@end

@implementation MaterialViewController

WLC_VIEW_CONTROLLER_INIT

- (void)_init
{
    self.title = @"培训资料";
    self.dataList = [NSMutableArray new];
    self.departmentList = [NSMutableArray new];
}

+ (instancetype)instance
{
    NSString *nibName = nil;
//    if ([TrainingManager isCommonUser] ) {
//        nibName = @"MaterialViewController";
//    }
//    else {
        nibName = @"MaterialViewController2";
    //}
    
    return [[self alloc] initWithNibName:nibName bundle:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.tableFooterView = [UIView new];
    
    [self configUI];
    
    NSInteger currentMonth = [NSDate currentMonth];
    self.selectedMonth = currentMonth - 1;
    self.monthTextField.text = [NSString stringWithFormat:@"%li月", currentMonth];
    
    TrainingUserType userType = [TrainingManager sharedInstance].userInfo.userType;
    if (userType == TrainingUserType_Normal ||
        userType == TrainingUserType_Super) {
        [WLCPickerView getDepartmentInfo:^(NSError *error, DepartmentInfo *info) {
            if (info) {
                DepartmentInfo *newInfo = [DepartmentInfo new];
                newInfo.departmentName = @"全部";
                newInfo.departmentId = -1;
                [self.departmentList addObject:newInfo];
                [self.departmentList addObjectsFromArray:[TrainingManager sharedInstance].departmentList];
                self.selectedDepartmentIndex = 0;
                self.departmentTextField.text = @"全部";
                
                [self showLoadingViewWithText:@"正在加载..."];
                [self queryDataListWithPageNum:1];
            }
        }];
    }
    else {
        [self showLoadingViewWithText:@"正在加载..."];
        [self queryDataListWithPageNum:1];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    TrainingUserType userType = [TrainingManager sharedInstance].userInfo.userType;
    if (userType == TrainingUserType_Training ||
        userType == TrainingUserType_Verify) {
        [self queryDataListWithPageNum:1];
    }
    else {
        if (self.departmentList.count > 0) {
            [self queryDataListWithPageNum:1];
        }
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

#pragma mark - Private

- (void)configUI
{
    if (![TrainingManager isCommonUser] && ![TrainingManager isVerifyAdmin]) {
        UIImage *image = [UIImage imageNamed:@"add_icon"];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(onAddBtnClicked)];
    }
    
    TrainingUserType userType = [TrainingManager sharedInstance].userInfo.userType;
    if (userType == TrainingUserType_Training ||
        userType == TrainingUserType_Verify) {
        self.departmentTextField.hidden = YES;
        self.monthTextField.top -= 40;
        self.tableView.top -= 40;
        self.tableView.height += 40;
    }
    
    [MaterialInfoTableViewCell registerForTableView:self.tableView];
    [self addRefreshHeader];
    [self addRefreshFooter];
}

- (void)deleteDataWithIndexPath:(NSIndexPath *)indexPath
{
    MaterialInfo *info = self.dataList[indexPath.row];
    self.deletedMid = info.mid;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"确定要删除该培训资料吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)queryDataListWithPageNum:(NSInteger)pageNum
{
    if (self.isLoadingData) {
        return;
    }
    self.isLoadingData = YES;
    
    NSInteger year = [NSDate currentYear];
    NSInteger len = self.monthTextField.text.length;
    NSString *strMonth = [self.monthTextField.text substringToIndex:len-1];
    NSInteger daysofMonth = [NSDate daysOfMonth:[strMonth integerValue] inYear:year];
    NSString *startTime = [NSString stringWithFormat:@"%li-%02li-01", year, strMonth.integerValue];
    NSString *endTime = [NSString stringWithFormat:@"%li-%02li-%li", year, strMonth.integerValue, daysofMonth];
    
    NSInteger departmentId = -1;
    TrainingUserType userType = [TrainingManager sharedInstance].userInfo.userType;
    if (userType == TrainingUserType_Normal || userType == TrainingUserType_Super) {
        DepartmentInfo *info = self.departmentList[self.selectedDepartmentIndex];
        departmentId = info.departmentId;
    }
    
    [[TrainingManager sharedInstance] queryMaterialListWithStartTime:startTime
                                                             endTime:endTime
                                                        departmentId:departmentId
                                                               theme:@""
                                                             pageNum:pageNum
                                                            pageSize:kPageSize
                                                          compeltion:^(NSError *error, NSArray *materialList)
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
             if (materialList.count < kPageSize) {
                 self.tableView.mj_footer.hidden = YES;
             }
             else {
                 self.tableView.mj_footer.hidden = NO;
             }
         }
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

#pragma mar- UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.departmentTextField) {
        [WLCPickerView showPickerViewOnViewController:self.tabBarController withDataList:self.departmentList selectedIndex:self.selectedDepartmentIndex doneBlock:^(NSInteger selectedIndex) {
            self.selectedDepartmentIndex = selectedIndex;
            DepartmentInfo *info = self.departmentList[self.selectedDepartmentIndex];
            self.departmentTextField.text = info.departmentName;
            [self showLoadingViewWithText:@"正在加载..."];
            [self queryDataListWithPageNum:1];
        } cancelBlock:nil];
    }
    else {
        NSArray *dataList = @[@"1月", @"2月", @"3月", @"4月", @"5月", @"6月", @"7月", @"8月", @"9月", @"10月", @"11月", @"12月"];
        [WLCPickerView showPickerViewOnViewController:self.tabBarController
                                         withDataList:dataList
                                        selectedIndex:self.selectedMonth
                                            doneBlock:^(NSInteger selectedIndex)
         {
             self.monthTextField.text = dataList[selectedIndex];
             self.selectedMonth = selectedIndex;
             [self showLoadingViewWithText:@"正在加载..."];
             [self queryDataListWithPageNum:1];
         } cancelBlock:nil];
    }

    return NO;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    MaterialSearchViewController *searchVC = [MaterialSearchViewController instance];
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark - Button actions

- (void)onAddBtnClicked
{
    PublishMaterialViewController *pushlishVC = [PublishMaterialViewController new];
    [self.navigationController pushViewController:pushlishVC animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MaterialInfoTableViewCell *infoCell = [MaterialInfoTableViewCell dequeueReusableCellForTableView:tableView];
    MaterialInfo *info = self.dataList[indexPath.row];
    [infoCell setMaterialInfo:info];
    return infoCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MaterialInfoTableViewCell height];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MaterialInfo *info = self.dataList[indexPath.row];
    MaterialDetailViewController *detailVC = [MaterialDetailViewController new];
    detailVC.materialInfo = info;
    [self.navigationController pushViewController:detailVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

DeleteDataCodeBlock

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }
    
    [[TrainingManager sharedInstance] deleteMaterialWithMId:self.deletedMid completion:^(NSError *error) {
        if (error) {
            [WLCToastView toastWithMessage:@"删除失败" error:error];
        }
        else {
            [WLCToastView toastWithMessage:@"删除成功"];
            for (NSInteger i = 0; i < self.dataList.count; i++) {
                MaterialInfo *tmpInfo = self.dataList[i];
                if ([self.deletedMid isEqualToString:tmpInfo.mid]) {
                    [self.dataList removeObject:tmpInfo];
                    break;
                }
            }
            
            if (self.dataList.count == 0) {
                [WLCEmptyView showOnView:self.view withText:@"暂无培训资料" icon:@"material_icon"];
            }
            
            [self.tableView reloadData];
        }
    }];
}

@end
