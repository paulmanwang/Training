//
//  TrainingSearchViewController.h
//  Training
//
//  Created by lichunwang on 17/1/5.
//  Copyright © 2017年 springcome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray *dataList;

+ (instancetype)instance;
- (void)queryDataList;

@end
