//
//  SAManageViewController.m
//  Training
//
//  Created by lichunwang on 16/12/29.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "SAManageViewController.h"
#import "TAMainViewController.h"
#import "TASummaryViewController.h"
#import "MRAMainViewController.h"
#import "MaterialViewController.h"

@interface SAManageViewController ()

@end

@implementation SAManageViewController

- (void)_init
{
    [super _init];
    
    self.title = @"管理";
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
    TAMainViewController *vc1 = [TAMainViewController instance];
    vc1.title = @"培训课程";
    TASummaryViewController *vc2 = [TASummaryViewController instance];
    vc2.title = @"随手拍";
    MaterialViewController *vc3 = [MaterialViewController instance];
    vc3.title = @"培训资料";
    MRAMainViewController *vc4 = [MRAMainViewController new];
    vc4.title = @"会议室";
    
    return @[vc1, vc2, vc3, vc4];
}

@end
