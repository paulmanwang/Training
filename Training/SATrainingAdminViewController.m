//
//  SATrainingAdminViewController.m
//  Training
//
//  Created by lichunwang on 16/12/17.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "SATrainingAdminViewController.h"

@interface SATrainingAdminViewController ()

@end

@implementation SATrainingAdminViewController

WLC_VIEW_CONTROLLER_INIT

- (void)_init
{
    self.title = @"培训管理员";
    self.dataList = [NSMutableArray new];
    self.adminType = 3;
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
