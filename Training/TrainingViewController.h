//
//  TAMainViewController.h
//  Training
//
//  Created by lichunwang on 16/12/17.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLCSearchBar.h"
#import <MJRefresh/MJRefresh.h>

@class CourseInfo;

@interface TrainingViewController : UIViewController

+ (instancetype)instance;

- (void)onAddBtnClicked;

- (void)queryDataListWithPageNum:(NSInteger)pageNum;

- (void)deleteCourse:(CourseInfo *)info;
- (void)editCourse:(CourseInfo *)info;
- (void)onSearchBarClicked;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *sectionHeaderView;
@property (weak, nonatomic) IBOutlet WLCTextField *departmentTextField;
@property (weak, nonatomic) IBOutlet WLCTextField *monthTextField;
@property (weak, nonatomic) IBOutlet WLCSearchBar *searchBar;

@property (assign, nonatomic) NSInteger selectedDepartmentIndex;
@property (strong, nonatomic) NSMutableArray *dataList;
@property (strong, nonatomic) NSMutableArray *departmentList;

@property (assign, nonatomic) NSInteger currentPageNum;
@property (assign, nonatomic) BOOL isLoadingData;

@end
