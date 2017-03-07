//
//  SABaseViewController.h
//  Training
//
//  Created by lichunwang on 16/12/17.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SAAdminBaseViewController : UIViewController

+ (instancetype)instance;

@property (assign, nonatomic) NSInteger adminType; //2表示培训管理员，3表示会议室管理员，5表示审核管理员

@property (strong, nonatomic) NSMutableArray *dataList;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (void)onAddButtonClicked;

@end
