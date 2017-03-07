//
//  PublishTrainingViewController.m
//  Training
//
//  Created by lichunwang on 16/12/19.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "ForgotPwdViewController.h"

@interface ForgotPwdViewController ()<UITableViewDataSource, UITabBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *departmentCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *realNameCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *contactCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *userNameCell;

@end

@implementation ForgotPwdViewController

WLC_VIEW_CONTROLLER_INIT

- (void)_init
{
    self.title = @"忘记密码";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.tableFooterView = [UIView new];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
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
    else {
        return self.userNameCell;
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

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self hideKeyBoard];
}



@end
