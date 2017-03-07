//
//  CommonAboutMeViewController.m
//  Training
//
//  Created by lichunwang on 16/12/17.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "CommonAboutMeViewController.h"
#import "AboutMeTableViewCell.h"
#import "TrainingManager+User.h"
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import "AppDelegate.h"

@interface CommonAboutMeViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) NSArray *dataSource;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@end

@implementation CommonAboutMeViewController

WLC_VIEW_CONTROLLER_INIT

- (void)_init
{
    self.title = @"我的";
}

+ (instancetype)instance
{
    return [[self alloc] initWithNibName:@"CommonAboutMeViewController" bundle:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.edgesForExtendedLayout = UIRectEdgeAll;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.fd_prefersNavigationBarHidden = YES;
    
    self.headerImageView.layer.cornerRadius = 30.0f;
    self.headerImageView.layer.masksToBounds = YES;
    
    [AboutMeTableViewCell registerForTableView:self.tableView];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = [UIView new];
    self.dataSource = [self onConfigDataSource];
    
    [self setUserInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //[self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //[self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)setUserInfo
{
    self.userNameLabel.text = [TrainingManager sharedInstance].userInfo.userName;
    NSInteger type = [TrainingManager sharedInstance].userInfo.userType;
    if (type == 1) {
        self.userTypeLabel.text = @"普通用户";
    }
    else if (type == 2) {
        self.userTypeLabel.text = @"会议室管理员";
    }
    else if (type == 3) {
        self.userTypeLabel.text = @"培训管理员";
    }
    else if (type == 4) {
        self.userTypeLabel.text = @"超级管理员";
    }
    else if (type == 5) {
        self.userTypeLabel.text = @"审核管理员";
    }
}

- (NSArray *)onConfigDataSource
{
    return  nil;
}

- (NSInteger)cellTypeForIndexPath:(NSIndexPath *)indexPath
{
    return [self.dataSource[indexPath.section][indexPath.row] integerValue];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [AboutMeTableViewCell height];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self tableViewDidSelectRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

// 子类覆盖
- (void)tableViewDidSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return;
}

- (IBAction)onLogoutButtonClicked:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"确定要退出登录吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }
    
    [self showLoadingViewWithText:@"正在退出登录..."];
    [[TrainingManager sharedInstance] loginOutWithCompletion:^(NSError *error) {
        if (error) {
            [self dismissLoadingView];
            [WLCToastView toastWithMessage:@"退出登录失败" error:error];
        }
        else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [self dismissLoadingView];
                UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
                NSLog(@"this keyWindow = %@", keyWindow.rootViewController);
                [keyWindow resignKeyWindow];
                keyWindow.hidden = YES;
                keyWindow = nil;
                [WLCToastView toastWithMessage:@"退出登录成功"];
                
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [delegate.loginViewController queryVerifyCode];
             });
        }
    }];
}

@end
