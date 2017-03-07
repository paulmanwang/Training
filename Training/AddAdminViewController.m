//
//  PublishTrainingViewController.m
//  Training
//
//  Created by lichunwang on 16/12/19.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "AddAdminViewController.h"
#import "TrainingManager.h"
#import "TrainingManager+User.h"
#import "TrainingManager+Department.h"
#import "TrainingManager+User.h"


@interface AddAdminViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UITableViewCell *departmentCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *realNameCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *mobileCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *userNameCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *pwdCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *confirmPwdCell;

@property (weak, nonatomic) IBOutlet WLCTextField *departmentTextField;
@property (weak, nonatomic) IBOutlet UITextField *realNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwdTextField;

@property (assign, nonatomic) NSInteger selectedDepartmentIndex;

@end

@implementation AddAdminViewController

WLC_VIEW_CONTROLLER_INIT

onKeyBoardWillShowCodeBlock

onKeyBoardWillHideCodeBlock

- (void)_init
{
    self.hidesBottomBarWhenPushed = YES;
    AddKeyboardObserverCodeBlock
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.tableFooterView = [UIView new];
    if (self.adminType == 2) {
        self.title = @"添加会议室管理员";
    }
    else if (self.adminType == 3) {
        self.title = @"添加培训管理员";
    }
    else if (self.adminType == 5) {
        self.title = @"添加审核管理员";
    }

    self.departmentTextField.textColor = kGlobalTextColor;
    self.realNameTextField.textColor = kGlobalTextColor;
    self.mobileTextField.textColor = kGlobalTextColor;
    self.userNameTextField.textColor = kGlobalTextColor;
    self.pwdTextField.textColor = kGlobalTextColor;
    self.confirmPwdTextField.textColor = kGlobalTextColor;
    
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

- (UIView *)firstResponder
{
    if ([self.userNameTextField isFirstResponder]) {
        return self.userNameTextField;
    }
    
    if ([self.pwdTextField isFirstResponder]) {
        return self.pwdTextField;
    }
    
    if ([self.confirmPwdTextField isFirstResponder]) {
        return self.confirmPwdTextField;
    }
    
    return nil;
}

- (void)updateDepartmentInfo
{
    DepartmentInfo *info = [TrainingManager sharedInstance].departmentList[self.selectedDepartmentIndex];
    self.departmentTextField.text = info.departmentName;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.departmentTextField) {
        [WLCPickerView showDepartmentPickerViewOnViewController:self
                                              withSelectedIndex:self.selectedDepartmentIndex
                                                      doneBlock:^(NSInteger selectedIndex)
         {
             self.selectedDepartmentIndex = selectedIndex;
             [self updateDepartmentInfo];
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
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return self.departmentCell;
    }
    else if (indexPath.row == 1) {
        return self.realNameCell;
    }
    else if (indexPath.row == 2) {
        return self.mobileCell;
    }
    else if (indexPath.row == 3) {
        return self.userNameCell;
    }
    else if (indexPath.row == 4) {
        return self.pwdCell;
    }
    else {
        return self.confirmPwdCell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (IBAction)onAddButtonClicked:(id)sender
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    DepartmentInfo *info = [TrainingManager sharedInstance].departmentList[self.selectedDepartmentIndex];
    parameters[@"department_id"] = @(info.departmentId);
    parameters[@"name"] = self.realNameTextField.text;
    parameters[@"mobile"] = self.mobileTextField.text;
    parameters[@"username"] = self.userNameTextField.text;
    parameters[@"password"] = self.pwdTextField.text;
    parameters[@"confirmpwd"] = self.confirmPwdTextField.text;
    
    void(^completion)(NSError *error) = ^(NSError *error) {
        [self dismissLoadingView];
        if (error) {
            [WLCToastView toastWithMessage:@"添加失败" error:error];
        }
        else {
            [WLCToastView toastWithMessage:@"添加成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    };
    
    [self showLoadingViewWithText:@"正在处理..."];
    if (self.adminType == 2) {
        [[TrainingManager sharedInstance] registerMeetingAdminWithParameters:parameters completion:completion];
    }
    else if (self.adminType == 3) {
        [[TrainingManager sharedInstance] registerTrainingAdminWithParameters:parameters completion:completion];
    }
    else if (self.adminType == 5) {
        [[TrainingManager sharedInstance] registerVerifyAdminWithParameters:parameters completion:completion];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self hideKeyBoard];
}


@end
