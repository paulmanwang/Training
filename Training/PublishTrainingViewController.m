//
//  PublishTrainingViewController.m
//  Training
//
//  Created by lichunwang on 16/12/19.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "PublishTrainingViewController.h"
#import "WLCPickerView.h"
#import "WLCDatePicker.h"
#import "TrainingManager+Department.h"
#import "TrainingManager+Course.h"
#import "TrainingManager+User.h"

@interface PublishTrainingViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *subjectCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *startTimeCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *endTimeCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *objectCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *addressCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *companyCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *contactCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *mobileCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *contentCell;

@property (weak, nonatomic) IBOutlet UITextField *departmentTextField;
@property (weak, nonatomic) IBOutlet UITextField *contactTextField;
@property (weak, nonatomic) IBOutlet UITextField *subjectTextField;
@property (weak, nonatomic) IBOutlet UITextField *objectTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet WLCTextField *startTimeTextField;
@property (weak, nonatomic) IBOutlet WLCTextField *endTimeTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@property (assign, nonatomic) NSInteger selectedDepartmentIndex;

@end

@implementation PublishTrainingViewController

WLC_VIEW_CONTROLLER_INIT

- (void)_init
{
    self.hidesBottomBarWhenPushed = YES;
    AddKeyboardObserverCodeBlock
}

onKeyBoardWillShowCodeBlock

onKeyBoardWillHideCodeBlock

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.tableFooterView = [UIView new];
    
    self.departmentTextField.textColor = kGlobalTextColor;
    self.contactTextField.textColor = kGlobalTextColor;
    self.subjectTextField.textColor = kGlobalTextColor;
    self.objectTextField.textColor = kGlobalTextColor;
    self.addressTextField.textColor = kGlobalTextColor;
    self.startTimeTextField.textColor = kGlobalTextColor;
    self.endTimeTextField.textColor = kGlobalTextColor;
    self.mobileTextField.textColor = kGlobalTextColor;
    self.contentTextView.textColor = kGlobalTextColor;
    
    if (self.courseInfo) {
        self.title = @"修改培训";
        
        self.subjectTextField.text = self.courseInfo.theme;
        self.objectTextField.text = self.courseInfo.audience;
        self.addressTextField.text = self.courseInfo.place;
        self.startTimeTextField.text = [self.courseInfo.startTime substringToIndex:16];
        self.endTimeTextField.text = [self.courseInfo.endTime substringToIndex:16];
        self.contactTextField.text = self.courseInfo.contacts;
        self.mobileTextField.text = self.courseInfo.mobile;
        self.contentTextView.text = self.courseInfo.content;
    }
    else {
        self.title = @"发布培训";
    }
    
    [WLCPickerView getDepartmentInfo:^(NSError *error, DepartmentInfo *info) {
        if (info) {
            self.selectedDepartmentIndex = 0;
            [self updateDepartmentInfo];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)updateDepartmentInfo
{
    DepartmentInfo *info = [TrainingManager sharedInstance].departmentList[self.selectedDepartmentIndex];
    self.departmentTextField.text = info.departmentName;
}

- (UIView *)firstResponder
{
    if ([self.departmentTextField isFirstResponder]) {
        return self.departmentTextField;
    }
    
    if ([self.contactTextField isFirstResponder]) {
        return self.contactTextField;
    }
    
    if ([self.mobileTextField isFirstResponder]) {
        return self.mobileTextField;
    }
    
    if ([self.contentTextView isFirstResponder]) {
        return self.contentTextView;
    }
    
    return nil;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.departmentTextField) {
        [self hideKeyBoard];
        [WLCPickerView showDepartmentPickerViewOnViewController:self
                                              withSelectedIndex:self.selectedDepartmentIndex
                                                      doneBlock:^(NSInteger selectedIndex)
        {
            self.selectedDepartmentIndex = selectedIndex;
            [self updateDepartmentInfo];
        } cancelBlock:nil];
        return NO;
    }
    
    if (textField == self.startTimeTextField || textField == self.endTimeTextField) {
        [self hideKeyBoard];
        [WLCDatePicker showDatePickerOnViewContoller:self withMode:UIDatePickerModeDateAndTime doneBlock:^(NSString *timeString) {
            textField.text = timeString;
        } cancelBlock:nil];
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    
    return YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return self.subjectCell;
    }
    else if (indexPath.row == 1) {
        return self.startTimeCell;
    }
    else if (indexPath.row == 2) {
        return self.endTimeCell;
    }
    else if (indexPath.row == 3) {
        return self.objectCell;
    }
    else if (indexPath.row == 4) {
        return self.addressCell;
    }
    else if (indexPath.row == 5) {
        return self.companyCell;
    }
    else if (indexPath.row == 6) {
        return self.contactCell;
    }
    else if (indexPath.row == 7) {
        return self.mobileCell;
    }
    else {
        return self.contentCell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 8) {
        return 150;
    }
    
    if (![TrainingManager isSuperAdmin] && indexPath.row == 5) {
        return 0;
    }
    
    return 75;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
//    if ([self.contentTextView isFirstResponder]) {
//        return;
//    }
    
    [self hideKeyBoard];
}

#pragma mark - Button ation

- (BOOL)checkEmpty
{
    if (self.subjectTextField.text.length == 0) {
        [WLCToastView toastWithMessage:@"培训主题不能为空"];
        return NO;
    }
    if (self.objectTextField.text.length == 0) {
        [WLCToastView toastWithMessage:@"培训对象不能为空"];
        return NO;
    }
    if (self.startTimeTextField.text.length == 0) {
        [WLCToastView toastWithMessage:@"开始时间不能为空"];
        return NO;
    }
    if (self.endTimeTextField.text.length == 0) {
        [WLCToastView toastWithMessage:@"结束时间不能为空"];
        return NO;
    }
    
    if (self.addressTextField.text.length == 0) {
        [WLCToastView toastWithMessage:@"培训地点不能为空"];
        return NO;
    }
    if (self.contactTextField.text.length == 0) {
        [WLCToastView toastWithMessage:@"联系人不能为空"];
        return NO;
    }
    if (self.mobileTextField.text.length == 0) {
        [WLCToastView toastWithMessage:@"手机号码不能为空"];
        return NO;
    }
    if (self.contentTextView.text.length == 0) {
        [WLCToastView toastWithMessage:@"培训内容不能为空"];
        return NO;
    }
    
    if ([self.startTimeTextField.text isEqualToString:self.endTimeTextField.text]) {
        [WLCToastView toastWithMessage:@"开始时间与结束时间不能相同"];
        return NO;
    }
    
    if ([NSDate oneDate:self.startTimeTextField.text isGreaterThanAnotherDate:self.endTimeTextField.text]) {
        [WLCToastView toastWithMessage:@"开始时间不能早于结束时间"];
        return NO;
    }
    
    return YES;
}

- (IBAction)onSubmitButtonClicked:(id)sender
{
    if (![self checkEmpty]) {
        return;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"theme"] = self.subjectTextField.text;
    parameters[@"audience"] = self.objectTextField.text;
    parameters[@"start_time"] = self.startTimeTextField.text;
    parameters[@"end_time"] = self.endTimeTextField.text;
    parameters[@"place"] = self.addressTextField.text;
    parameters[@"contacts"] = self.contactTextField.text;
    parameters[@"mobile"] = self.mobileTextField.text;
    parameters[@"content"] = self.contentTextView.text;
    if ([TrainingManager isSuperAdmin]) {
        DepartmentInfo *info = [TrainingManager sharedInstance].departmentList[self.selectedDepartmentIndex];
        parameters[@"department_id"] = @(info.departmentId);
    }
    
    if (self.courseInfo) {
        parameters[@"cid"] = self.courseInfo.cid;
        [self showLoadingViewWithText:@"正在处理..."];
        [[TrainingManager sharedInstance] editCourseWithParameters:parameters completion:^(NSError *error) {
            [self dismissLoadingView];
            if (error) {
                [WLCToastView toastWithMessage:@"修改失败" error:error];
            }
            else {
                [WLCToastView toastWithMessage:@"修改成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
    else {
        [self showLoadingViewWithText:@"正在处理..."];
        [[TrainingManager sharedInstance] addCourseWithParameters:parameters completion:^(NSError *error) {
            [self dismissLoadingView];
            if (error) {
                [WLCToastView toastWithMessage:@"发布失败" error:error];
            }
            else {
                [WLCToastView toastWithMessage:@"发布成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}


@end
