//
//  TAMainViewController.m
//  Training
//
//  Created by lichunwang on 16/12/17.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "TAMainViewController.h"
#import "PublishTrainingViewController.h"
#import "TrainingManager+Course.h"
#import "TrainingSearchViewController.h"
#import "PublishTrainingViewController.h"

@interface TAMainViewController ()<UIAlertViewDelegate>

@property (strong, nonatomic) WLCEmptyView *emptyView;
@property (copy, nonatomic) NSString *deleteCid;

@end

@implementation TAMainViewController

WLC_VIEW_CONTROLLER_INIT

- (void)_init
{
    self.title = @"首页";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)onAddBtnClicked
{
    PublishTrainingViewController *pushlishVC = [PublishTrainingViewController new];
    [self.navigationController pushViewController:pushlishVC animated:YES];
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
             NSLog(@"datalist count = %li", dataList.count);
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

- (void)deleteCourse:(CourseInfo *)info
{
    self.deleteCid = info.cid;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"确定要删除该培训吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)editCourse:(CourseInfo *)info
{
    PublishTrainingViewController *publishVC = [PublishTrainingViewController new];
    publishVC.courseInfo = info;
    [self.navigationController pushViewController:publishVC animated:YES];
}

- (void)onSearchBarClicked
{
    TrainingSearchViewController *searchVC = [TrainingSearchViewController instance];
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }
    
    [self showLoadingViewWithText:@"正在处理..."];
    [[TrainingManager sharedInstance] deleteCourseWithCId:self.deleteCid completion:^(NSError *error) {
        [self dismissLoadingView];
        if (error) {
            [WLCToastView toastWithMessage:@"删除失败" error:error];
        }
        else {
            [WLCToastView toastWithMessage:@"删除成功"];
            [self queryDataListWithPageNum:1];
            
            for (NSInteger i = 0; i < self.dataList.count; i++) {
                CourseInfo *tmpInfo = self.dataList[i];
                if ([self.deleteCid isEqualToString:tmpInfo.cid]) {
                    [self.dataList removeObject:tmpInfo];
                    break;
                }
            }
            
            [self.tableView reloadData];
        }
    }];
}

@end
