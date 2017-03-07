//
//  DepartmentPickerView.h
//  Training
//
//  Created by lichunwang on 16/12/26.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "WLCPickerView.h"

@interface WLCPickerView (WLCPickerView)

+ (instancetype)showDepartmentPickerViewOnViewController:(UIViewController *)viewController
                                       withSelectedIndex:(NSInteger)selectedIndex
                                               doneBlock:(WLCPickViewDoneBlock)doneBlock
                                             cancelBlock:(void(^)(void))cancelBlock;

+ (void)getDepartmentInfo:(void(^)(NSError *error, DepartmentInfo *info))completion;


@end
