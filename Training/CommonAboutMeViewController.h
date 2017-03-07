//
//  CommonAboutMeViewController.h
//  Training
//
//  Created by lichunwang on 16/12/17.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonAboutMeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userTypeLabel;

+ (instancetype)instance;

- (NSArray *)onConfigDataSource;

- (NSInteger)cellTypeForIndexPath:(NSIndexPath *)indexPath;

- (void)tableViewDidSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
