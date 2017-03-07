//
//  SARoomAdminViewController.m
//  Training
//
//  Created by lichunwang on 16/12/17.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "SAVerifyAdminViewController.h"

@interface SAVerifyAdminViewController ()

@end

@implementation SAVerifyAdminViewController

WLC_VIEW_CONTROLLER_INIT

- (void)_init
{
    self.title = @"审核管理员";
    self.dataList = [NSMutableArray new];
    self.adminType = 5;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
