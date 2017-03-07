//
//  SAAdminViewController.m
//  Training
//
//  Created by lichunwang on 16/12/29.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "SAAdminViewController.h"
#import "SATrainingAdminViewController.h"
#import "SARoomAdminViewController.h"
#import "SAVerifyAdminViewController.h"

@interface SAAdminViewController ()

@end

@implementation SAAdminViewController

- (void)_init
{
    [super _init];
    self.title = @"管理员";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollEnabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSArray *)onConfigViewControllers
{
    SATrainingAdminViewController *trainingAdminVC = [SATrainingAdminViewController instance];
    SAVerifyAdminViewController *verifyAdminVC = [SAVerifyAdminViewController instance];
    SARoomAdminViewController *roomAdminVC = [SARoomAdminViewController instance];

    return @[trainingAdminVC, verifyAdminVC, roomAdminVC];
}

@end
