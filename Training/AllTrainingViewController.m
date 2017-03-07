//
//  AllTrainingViewController.m
//  Training
//
//  Created by lichunwang on 16/12/28.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "AllTrainingViewController.h"
#import "TrainingManager+Course.h"
#import "TrainingSearchViewController.h"

@interface AllTrainingViewController ()

@end

@implementation AllTrainingViewController

WLC_VIEW_CONTROLLER_INIT

- (void)_init
{
    self.title = @"全部培训";
    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

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
    if ([TrainingManager sharedInstance].userInfo.userType == 1) {
        DepartmentInfo *info = self.departmentList[self.selectedDepartmentIndex];
        departmentId = info.departmentId;
    }
    
    [[TrainingManager sharedInstance] queryCourseListWithMine:0
                                                    isExpired:-1
                                                    startTime:startDate
                                                      endTime:endDate
                                                 departmentId:departmentId
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
        else {
            [self dismissEmptyView];
        }
    }];
}

- (void)onSearchBarClicked
{
    TrainingSearchViewController *searchVC = [TrainingSearchViewController instance];
    [self.navigationController pushViewController:searchVC animated:YES];
}

@end
