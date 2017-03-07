//
//  PublishTrainingViewController.m
//  Training
//
//  Created by lichunwang on 16/12/19.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "RegisterViewController.h"
#import "TrainingManager.h"
#import "DepartmentInfo.h"
#import "TrainingManager+Department.h"
#import "TrainingManager+User.h"

@interface RegisterViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *realNameCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *departmentCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *contactCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *userNameCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *conformPwdCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *pwdCell;

@property (weak, nonatomic) IBOutlet UITextField *realNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *departmentTextField;
@property (weak, nonatomic) IBOutlet UITextField *contactTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwdTextField;

@end

@implementation RegisterViewController

WLC_VIEW_CONTROLLER_INIT

- (void)_init
{
    self.title = @"注册";
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
    self.realNameTextField.textColor = kGlobalTextColor;
    self.contactTextField.textColor = kGlobalTextColor;
    self.pwdTextField.textColor = kGlobalTextColor;
    self.userNameTextFiled.textColor = kGlobalTextColor;
    self.confirmPwdTextField.textColor = kGlobalTextColor;
    
    [WLCPickerView getDepartmentInfo:^(NSError *error, DepartmentInfo *info) {
        if (info) {
            self.departmentTextField.text = info.departmentName;
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
    if ([self.userNameTextFiled isFirstResponder]) {
        return self.userNameTextFiled;
    }
    
    if ([self.pwdTextField isFirstResponder]) {
        return self.pwdTextField;
    }
    
    if ([self.confirmPwdTextField isFirstResponder]) {
        return self.confirmPwdTextField;
    }
    
    return nil;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.departmentTextField) {
        [WLCPickerView showDepartmentPickerViewOnViewController:self
                                              withSelectedIndex:0
                                                      doneBlock:nil
                                                    cancelBlock:nil];
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.pwdTextField) {
        [self.confirmPwdTextField becomeFirstResponder];
        return YES;
    }
    
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
        return self.contactCell;
    }
    else if (indexPath.row == 3) {
        return self.userNameCell;
    }
    else if (indexPath.row == 4) {
        return self.pwdCell;
    }
    else {
        return self.conformPwdCell;
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

- (IBAction)onRegisterButtonClicked:(id)sender
{
    DepartmentInfo *item = [TrainingManager sharedInstance].departmentList[0];
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"department_id"] = @(item.departmentId);
    parameters[@"name"] = self.realNameTextField.text;
    parameters[@"mobile"] = self.contactTextField.text;
    parameters[@"username"] = self.userNameTextFiled.text;
    parameters[@"password"] = self.pwdTextField.text;
    parameters[@"confirmpwd"] = self.confirmPwdTextField.text;
    
    [self showLoadingViewWithText:@"正在注册..."];
    [[TrainingManager sharedInstance] registerUserWithParameters:parameters completion:^(NSError *error) {
        [self dismissLoadingView];
        if (error) {
            [WLCToastView toastWithMessage:@"注册失败" error:error];
        }
        else {
            [WLCToastView toastWithMessage:@"注册信息已提交，等待管理员审核"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self hideKeyBoard];
}

@end
