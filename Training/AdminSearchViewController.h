//
//  AdminSearchViewController.h
//  Training
//
//  Created by lichunwang on 17/1/17.
//  Copyright © 2017年 springcome. All rights reserved.
//

#import "SearchViewController.h"

@interface AdminSearchViewController : SearchViewController

@property (assign, nonatomic) NSInteger adminType; //2表示培训管理员，3表示会议室管理员，5表示审核管理员

@end
