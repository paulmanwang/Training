//
//  PublishTrainingViewController.m
//  Training
//
//  Created by lichunwang on 16/12/19.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "ModifyPwdViewController.h"
#import "TrainingManager+User.h"

@interface ModifyPwdViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *orgPwdCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *nPasswordCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *conformNewPwdCell;

@property (weak, nonatomic) IBOutlet UITextField *orgPwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTexField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwdTextField;

@end

@implementation ModifyPwdViewController

WLC_VIEW_CONTROLLER_INIT

- (void)_init
{
    self.hidesBottomBarWhenPushed = YES;
    self.title = @"修改密码";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    
    self.orgPwdTextField.textColor = kGlobalTextColor;
    self.pwdTexField.textColor = kGlobalTextColor;
    self.confirmPwdTextField.textColor = kGlobalTextColor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return self.orgPwdCell;
    }
    else if (indexPath.row == 1) {
        return self.nPasswordCell;
    }
    else {
        return self.conformNewPwdCell;
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

- (IBAction)onModifyButtonClicked:(id)sender
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"oldpwd"] = self.orgPwdTextField.text;
    parameters[@"password"] = self.pwdTexField.text;
    parameters[@"confirmpwd"] = self.confirmPwdTextField.text;
    
    [self showLoadingViewWithText:@"正在处理..."];
    [[TrainingManager sharedInstance] modifyPasswordWithParameters:parameters completion:^(NSError *error) {
        [self dismissLoadingView];
        if (error) {
            [WLCToastView toastWithMessage:@"修改失败" error:error];
        }
        else {
            [WLCToastView toastWithMessage:@"修改成功"];
        }
    }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self hideKeyBoard];
}

@end
