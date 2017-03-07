//
//  PublishTrainingViewController.m
//  Training
//
//  Created by lichunwang on 16/12/19.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "AllocateRoomViewController.h"
#import "WLCPickerView.h"
#import "TrainingManager+RoomArrangement.h"
#import "TrainingManager+Department.h"

@interface AllocateRoomViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *departmentCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *nameCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *contactCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *useTypeCell;

@property (weak, nonatomic) IBOutlet WLCTextField *departmentTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet WLCTextField *useTypeTextField;

@property (assign, nonatomic) NSInteger selectedDepartmentIndex;
@property (assign, nonatomic) NSInteger selectedUseTypeIndex;
@property (copy, nonatomic) NSArray *useTypeList;
@property (weak, nonatomic) IBOutlet WLCButton *deleteButton;

@end

@implementation AllocateRoomViewController

WLC_VIEW_CONTROLLER_INIT

- (void)_init
{
    self.hidesBottomBarWhenPushed = YES;
    self.useTypeList = @[@"培训", @"其他"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.tableFooterView = [UIView new];
    
    self.nameTextField.textColor = kGlobalTextColor;
    self.departmentTextField.textColor = kGlobalTextColor;
    self.mobileTextField.textColor = kGlobalTextColor;
    
    if (self.arrangementInfo) {
        self.deleteButton.hidden = NO;
        NSString *departmentName = self.arrangementInfo.departmentInfo.departmentName;
        self.departmentTextField.text = departmentName;
        NSArray *departmentList = [TrainingManager sharedInstance].departmentList;
        for (NSInteger i = 0; i < departmentList.count; i++) {
            DepartmentInfo *info = departmentList[i];
            if ([departmentName isEqualToString:info.departmentName]) {
                self.selectedDepartmentIndex = i;
                break;
            }
        }
        [WLCPickerView getDepartmentInfo:nil];
        self.nameTextField.text = self.arrangementInfo.name;
        self.mobileTextField.text = self.arrangementInfo.mobile;
        
        self.selectedUseTypeIndex = self.arrangementInfo.useType-1;
        self.useTypeTextField.text = self.useTypeList[self.selectedUseTypeIndex];
    }
    else {
        self.selectedUseTypeIndex = 0;
        self.useTypeTextField.text = self.useTypeList[0];
        [WLCPickerView getDepartmentInfo:^(NSError *error, DepartmentInfo *info) {
            self.selectedDepartmentIndex = 0;
            [self updateDepartmentInfo];
        }];
    }
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


#pragma mar- UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.departmentTextField) {
        [WLCPickerView showDepartmentPickerViewOnViewController:self.tabBarController
                                              withSelectedIndex:self.selectedDepartmentIndex
                                                      doneBlock:^(NSInteger selectedIndex)
        {
            self.selectedDepartmentIndex = selectedIndex;
            [self updateDepartmentInfo];
        } cancelBlock:nil];
        
        return NO;
    }
    
    if (textField == self.useTypeTextField) {
        [WLCPickerView showPickerViewOnViewController:self withDataList:self.useTypeList selectedIndex:self.selectedUseTypeIndex doneBlock:^(NSInteger selectedIndex) {
            self.useTypeTextField.text = self.useTypeList[selectedIndex];
            self.selectedUseTypeIndex = selectedIndex;
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return self.useTypeCell;
    }
    else if (indexPath.row == 1) {
        return self.departmentCell;
    }
    else if (indexPath.row == 2) {
        return self.nameCell;
    }
    else {
        return self.contactCell;
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

#pragma mark - Button action

- (IBAction)onSubmitButtonClicked:(id)sender
{
    if (self.arrangementInfo) {
        [self modifyArrangement];
    }
    else {
        [self addArrangement];
    }
}

- (void)modifyArrangement
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"rid"] = self.arrangementInfo.rid;
    DepartmentInfo *info = [TrainingManager sharedInstance].departmentList[self.selectedDepartmentIndex];
    parameters[@"department_id"] = @(info.departmentId);
    parameters[@"name"] = self.nameTextField.text;
    parameters[@"mobile"] = self.mobileTextField.text;
    parameters[@"use_type"] = @(self.selectedUseTypeIndex+1);
    
    [self showLoadingViewWithText:@"正在处理..."];
    [[TrainingManager sharedInstance] editRoomArrangementWithParameters:parameters completion:^(NSError *error) {
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

- (void)addArrangement
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"room_id"] = @(self.roomId);
    parameters[@"arrangement_date"] = self.arrangementDate;
    parameters[@"arrangement_time"] = @(self.arrangementTime);
    DepartmentInfo *info = [TrainingManager sharedInstance].departmentList[self.selectedDepartmentIndex];
    parameters[@"department_id"] = @(info.departmentId);
    parameters[@"name"] = self.nameTextField.text;
    parameters[@"mobile"] = self.mobileTextField.text;
    parameters[@"use_type"] = @(self.selectedUseTypeIndex+1);
    
    [self showLoadingViewWithText:@"正在处理..."];
    [[TrainingManager sharedInstance] addRoomArrangementWithParameters:parameters completion:^(NSError *error) {
        [self dismissLoadingView];
        if (error) {
            [WLCToastView toastWithMessage:@"分配会议室失败" error:error];
        }
        else {
            [WLCToastView toastWithMessage:@"分配会议室成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (IBAction)onDeleteButtonClicked:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"确定要删除该会议室安排？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self hideKeyBoard];
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }
    [self showLoadingViewWithText:@"正在处理..."];
    [[TrainingManager sharedInstance] deleteRoomArrangementWithRId:self.arrangementInfo.rid completion:^(NSError *error) {
        if (error) {
            [WLCToastView toastWithMessage:@"删除失败" error:error];
        }
        else {
            [WLCToastView toastWithMessage:@"删除成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

@end
