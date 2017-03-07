//
//  PublishTrainingViewController.m
//  Training
//
//  Created by lichunwang on 16/12/19.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "ExportViewController.h"
#import "WLCTextField.h"
#import "WLCPickerView.h"
#import "WLCDatePicker.h"
#import "TrainingManager+Export.h"

@interface ExportViewController ()<UITableViewDataSource, UITabBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *selectRoomCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *startDateCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *endDateCell;

@property (weak, nonatomic) IBOutlet WLCTextField *departmentTextField;
@property (weak, nonatomic) IBOutlet WLCTextField *startTextField;
@property (weak, nonatomic) IBOutlet WLCTextField *endTextField;
@property (weak, nonatomic) IBOutlet UILabel *resultUrlTextField;
@property (weak, nonatomic) IBOutlet UIButton *urlCopyButton;

@property (assign, nonatomic) NSInteger selectedDepartmentIndex;
@property (copy, nonatomic) NSString *resultUrl;

@property (strong, nonatomic) NSMutableArray *departmentList;

@end

@implementation ExportViewController

WLC_VIEW_CONTROLLER_INIT

- (void)_init
{
    self.hidesBottomBarWhenPushed = YES;
    self.departmentList = [NSMutableArray new];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.tableFooterView = [UIView new];
    
    self.urlCopyButton.hidden = YES;
    
    NSString *dateString = [NSString stringWithFormat:@"%li-%02li-%02li",
                            [NSDate currentYear], [NSDate currentMonth], [NSDate currentDay]];
    self.startTextField.text = dateString;
    self.endTextField.text =  dateString;
    [WLCPickerView getDepartmentInfo:^(NSError *error, DepartmentInfo *info) {
        if (info) {
            DepartmentInfo *newInfo = [DepartmentInfo new];
            newInfo.departmentName = @"全部";
            newInfo.departmentId = -1;
            [self.departmentList addObject:newInfo];
            [self.departmentList addObjectsFromArray:[TrainingManager sharedInstance].departmentList];
            self.selectedDepartmentIndex = 0;
            [self updateDepartmentInfo];
        }
    }];
}

- (void)updateDepartmentInfo
{
    DepartmentInfo *info = self.departmentList[self.selectedDepartmentIndex];
    self.departmentTextField.text = info.departmentName;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mar- UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.departmentTextField) {
        [WLCPickerView showPickerViewOnViewController:self.tabBarController withDataList:self.departmentList selectedIndex:self.selectedDepartmentIndex doneBlock:^(NSInteger selectedIndex) {
            self.selectedDepartmentIndex = selectedIndex;
            [self updateDepartmentInfo];
        } cancelBlock:nil];
    }
    else {
        [WLCDatePicker showDatePickerOnViewContoller:self.tabBarController withMode:UIDatePickerModeDate doneBlock:^(NSString *timeString) {
            textField.text = timeString;
        } cancelBlock:nil];
    }
    
    return NO;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([TrainingManager sharedInstance].userInfo.userType == TrainingUserType_Training) {
        return 2;
    }
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([TrainingManager sharedInstance].userInfo.userType == TrainingUserType_Training) {
        if (indexPath.row == 0) {
            return self.startDateCell;
        }
        else {
            return self.endDateCell;
        }
    }
    else {
        if (indexPath.row == 0) {
            return self.selectRoomCell;
        }
        else if (indexPath.row == 1) {
            return self.startDateCell;
        }
        else {
            return self.endDateCell;
        }
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (IBAction)onExportButtonClicked:(id)sender
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date1 = [dateFormatter dateFromString:self.startTextField.text];
    NSDate *date2 = [dateFormatter dateFromString:self.endTextField.text];
    NSComparisonResult result = [date1 compare:date2];
    if (result == NSOrderedDescending) { // The left operand is greater than the right operand.
        [WLCToastView toastWithMessage:@"开始时间不能早于结束时间"];
        return;
    }
    
    void(^completion)(NSError *error, NSString *url) = ^(NSError *error, NSString *url) {
        [self dismissLoadingView];
        if (error) {
            [WLCToastView toastWithMessage:@"导出失败" error:error];
            self.urlCopyButton.hidden = YES;
            self.resultUrlTextField.hidden = YES;
        }
        else {
            [WLCToastView toastWithMessage:@"导出成功"];
            self.urlCopyButton.hidden = NO;
            self.resultUrlTextField.hidden = NO;
            
            self.resultUrl = url;
            NSString *text = [NSString stringWithFormat:@"资源链接：%@%@", kServerBaseUrl, url];
            self.resultUrlTextField.text = text;
        }
    };
    
    DepartmentInfo *info = self.departmentList[self.selectedDepartmentIndex];
    NSString *startDate = self.startTextField.text;
    NSString *endDate = self.endTextField.text;
    [self showLoadingViewWithText:@"正在导出..."];
    if (self.exportType == ExportType_Training) {
        [[TrainingManager sharedInstance] exportCourseWithDepartmentId:info.departmentId startDate:startDate endDate:endDate completion:completion];
    }
    else if (self.exportType == ExportType_Summary) {
        [[TrainingManager sharedInstance] exportSummaryWithDepartmentId:info.departmentId startDate:startDate endDate:endDate completion:completion];
    }
    else {
        [[TrainingManager sharedInstance] exportRoomArrangementWithDepartmentId:info.departmentId startDate:startDate endDate:endDate completion:completion];
    }
}

- (IBAction)onCopyButtonClicked:(id)sender
{
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    pasteBoard.string = [NSString stringWithFormat:@"%@%@", kServerBaseUrl, self.resultUrl];
    
    [WLCToastView toastWithMessage:@"链接已复制到剪切板"];
}

@end
