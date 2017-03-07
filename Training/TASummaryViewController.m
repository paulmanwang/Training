//
//  TAPaiViewController.m
//  Training
//
//  Created by lichunwang on 16/12/17.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "TASummaryViewController.h"
#import "PublishSummaryViewController.h"
#import "TrainingManager+Summary.h"
#import "SummarySearchViewController.h"

@interface TASummaryViewController ()

@property (copy, nonatomic) NSString *deleteSid;

@end

@implementation TASummaryViewController

WLC_VIEW_CONTROLLER_INIT

- (void)_init
{
    self.title = @"随手拍";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
    NSString *startDate = [NSString stringWithFormat:@"%li-%02li-01", year, strMonth.integerValue];
    NSString *endDate = [NSString stringWithFormat:@"%li-%02li-%li", year, strMonth.integerValue, daysofMonth];
    
    NSInteger departmentId = -1;
    TrainingUserType userType = [TrainingManager sharedInstance].userInfo.userType;
    if (userType == TrainingUserType_Normal || userType == TrainingUserType_Super) {
        DepartmentInfo *info = self.departmentList[self.selectedDepartmentIndex];
        departmentId = info.departmentId;
    }
    
    [[TrainingManager sharedInstance] querySummaryListWithMine:-1
                                                     isExpired:NO
                                                     startTime:startDate
                                                       endTime:endDate
                                                  departmentId:-1
                                                         theme:@""
                                                       pageNum:pageNum
                                                      pageSize:kPageSize
                                                    completion:^(NSError *error, NSArray *courseList)
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
            if (courseList.count < kPageSize) {
                self.tableView.mj_footer.hidden = YES;
            }
            else {
                self.tableView.mj_footer.hidden = NO;
            }
        }
        [self.dataList addObjectsFromArray:courseList];
        [self.tableView reloadData];
        
        if (self.dataList.count == 0) {
            [WLCEmptyView showOnView:self.view withText:@"暂无随手拍" icon:@"summary_icon"];
        }
        else {
            [self dismissEmptyView];
        }
    }];
}

- (void)onAddBtnClicked
{
    PublishSummaryViewController *pushlishVC = [PublishSummaryViewController new];
    [self.navigationController pushViewController:pushlishVC animated:YES];
}

- (void)deleteCourse:(CourseInfo *)info
{
    self.deleteSid = info.sid;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"确定要删除该随手拍吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)editCourse:(CourseInfo *)info
{
    PublishSummaryViewController *publishVC = [PublishSummaryViewController new];
    publishVC.courseInfo = info;
    [self.navigationController pushViewController:publishVC animated:YES];
}

- (void)onSearchBarClicked
{
    SummarySearchViewController *searchVC = [SummarySearchViewController instance];
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }
    
    [self showLoadingViewWithText:@"正在处理..."];
    [[TrainingManager sharedInstance] deleteSummaryWithSId:self.deleteSid completion:^(NSError *error) {
        [self dismissLoadingView];
        if (error) {
            [WLCToastView toastWithMessage:@"删除失败" error:error];
        }
        else {
            [WLCToastView toastWithMessage:@"删除成功"];
            [self queryDataListWithPageNum:1];
            
            for (NSInteger i = 0; i < self.dataList.count; i++) {
                CourseInfo *tmpInfo = self.dataList[i];
                if ([self.deleteSid isEqualToString:tmpInfo.cid]) {
                    [self.dataList removeObject:tmpInfo];
                    break;
                }
            }
            
            [self.tableView reloadData];
        }
    }];
}

@end
