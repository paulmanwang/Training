//
//  ExportViewController.m
//  Training
//
//  Created by lichunwang on 16/12/29.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "SAExportViewController.h"
#import "ExportViewController.h"

@interface SAExportViewController ()

@end

@implementation SAExportViewController

- (void)_init
{
    [super _init];
    
    self.title = @"导出";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSArray *)onConfigViewControllers
{
    ExportViewController *exportVC1 = [ExportViewController new];
    exportVC1.exportType = ExportType_Training;
    exportVC1.title = @"培训课程";
    ExportViewController *exportVC2 = [ExportViewController new];
    exportVC2.exportType = ExportType_Summary;
    exportVC2.title = @"随手拍";
    ExportViewController *exportVC3 = [ExportViewController new];
    exportVC3.exportType = ExportType_RoomArrangement;
    exportVC3.title = @"会议室";
    
    return @[exportVC1, exportVC2, exportVC3];
}


@end
