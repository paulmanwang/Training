//
//  TAMainViewController.m
//  Training
//
//  Created by lichunwang on 16/12/17.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "TrainingViewController.h"
#import "PublishTrainingViewController.h"
#import "TrainingInfoTableViewCell.h"
#import "WLCTextField.h"
#import "WLCPickerView.h"
#import "TrainingManager+Course.h"
#import "TrainingManager+User.h"
#import "TrainingManager+Department.h"
#import "TrainingDetailViewController.h"
#import "SummaryDetailViewController.h"


@interface TrainingViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (assign, nonatomic) NSInteger selectedMonth;

@end

@implementation TrainingViewController

+ (instancetype)instance
{
    return [[self alloc] initWithNibName:@"TrainingViewController" bundle:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.departmentList = [NSMutableArray new];
    self.dataList = [NSMutableArray new];
    
    [self configUI];
    
    NSInteger currentMonth = [NSDate currentMonth];
    self.selectedMonth = currentMonth - 1;
    self.monthTextField.text = [NSString stringWithFormat:@"%li月", currentMonth];
    
    TrainingUserType userType = [TrainingManager sharedInstance].userInfo.userType;
    if (userType == TrainingUserType_Normal || userType == TrainingUserType_Super) {
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
    
    [TrainingInfoTableViewCell registerForTableView:self.tableView];
    [self addRefreshHeader];
    [self addRefreshFooter];
}

- (void)updateDepartmentInfo
{
    DepartmentInfo *info = self.departmentList[self.selectedDepartmentIndex];
    self.departmentTextField.text = info.departmentName;
}

- (void)queryDataListWithPageNum:(NSInteger)pageNum
{
    // for subclassing
}

- (void)onAddBtnClicked
{
    // for subclassing
}

- (void)deleteCourse:(CourseInfo *)info
{
    // for subclassing
}

- (void)editCourse:(CourseInfo *)info
{
    // for subclassing
}

- (void)deleteDataWithIndexPath:(NSIndexPath *)indexPath
{
    CourseInfo *info = self.dataList[indexPath.row];
    [self deleteCourse:info];
}

- (void)editDataWithIndexPath:(NSIndexPath *)indexPath
{
    CourseInfo *info = self.dataList[indexPath.row];
    [self editCourse:info];
}

#pragma mar- UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.departmentTextField) {
        [WLCPickerView showPickerViewOnViewController:self.tabBarController withDataList:self.departmentList selectedIndex:self.selectedDepartmentIndex doneBlock:^(NSInteger selectedIndex) {
            self.selectedDepartmentIndex = selectedIndex;
            [self updateDepartmentInfo];
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

- (void)onSearchBarClicked
{
    // for subclassing
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self onSearchBarClicked];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TrainingInfoTableViewCell *cell = [TrainingInfoTableViewCell dequeueReusableCellForTableView:tableView];
    CourseInfo *info = self.dataList[indexPath.row];
    [cell setCourseInfo:info];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [TrainingInfoTableViewCell height];
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, self.tableView.height)];
//    view.backgroundColor = [UIColor color255WithRed:210 green:221 blue:228];
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 200, 20)];
//    
//    NSInteger year = [NSDate currentYear];
//    NSInteger len = self.monthTextField.text.length;
//    NSInteger month = [[self.monthTextField.text substringToIndex:len-1] integerValue];
//    NSInteger daysofMonth = [NSDate daysOfMonth:month inYear:year];
//    
//    label.text = [NSString stringWithFormat:@"  %li月01日-%li月%li日", month, month, daysofMonth];
//    label.font = [UIFont systemFontOfSize:15];
//    [view addSubview:label];
//    return view;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 30;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CourseInfo *info = self.dataList[indexPath.row];
    if (info.sid.length > 0) {
        SummaryDetailViewController *detailVC = [SummaryDetailViewController new];
        detailVC.sid = info.sid;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    else {
        TrainingDetailViewController *detailVC = [TrainingDetailViewController new];
        detailVC.cid = info.cid;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

DeleteAndEditDataCodeBlock

@end
