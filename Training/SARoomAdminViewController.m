//
//  SARoomAdminViewController.m
//  Training
//
//  Created by lichunwang on 16/12/17.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "SARoomAdminViewController.h"

@interface SARoomAdminViewController ()

@end

@implementation SARoomAdminViewController

WLC_VIEW_CONTROLLER_INIT

- (void)_init
{
    self.title = @"会议室管理员";
    self.dataList = [NSMutableArray new];
    self.adminType = 2;
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
