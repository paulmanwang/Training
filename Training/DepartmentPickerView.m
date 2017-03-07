//
//  DepartmentPickerView.m
//  Training
//
//  Created by lichunwang on 16/12/26.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "DepartmentPickerView.h"
#import "TrainingManager+Department.h"
#import "DepartmentInfo.h"

@implementation WLCPickerView (WLCPickerView)

+ (instancetype)showDepartmentPickerViewOnViewController:(UIViewController *)viewController
                                       withSelectedIndex:(NSInteger)selectedIndex
                                               doneBlock:(WLCPickViewDoneBlock)doneBlock
                                             cancelBlock:(void(^)(void))cancelBlock
{
    NSArray *dataList = [TrainingManager sharedInstance].departmentList;
    if (dataList.count == 0) {
        [WLCToastView toastWithMessage:@"获取单位列表失败"];
        return nil;
    }
    
    return [self showPickerViewOnViewController:viewController withDataList:dataList selectedIndex:selectedIndex doneBlock:doneBlock cancelBlock:cancelBlock];
}

+ (void)getDepartmentInfo:(void(^)(NSError *error, DepartmentInfo *info))completion
{
    NSArray *departmentList = [TrainingManager sharedInstance].departmentList;
    if (departmentList.count == 0) {
        [[TrainingManager sharedInstance] queryDepartmentsWithCompletion:^(NSError *error, NSArray *departments) {
            if (departments.count == 0) {
                if (completion) {
                    completion(error, nil);
                }
                return;
            }
            
            DepartmentInfo *info = [departments firstObject];
            if (completion) {
                completion(nil, info);
            }
        }];
    }
    else {
        DepartmentInfo *info = [departmentList firstObject];
        if (completion) {
            completion(nil, info);
        }
    }
}

@end
