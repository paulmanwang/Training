//
//  RefreshBaseViewController.h
//  Training
//
//  Created by lichunwang on 17/1/17.
//  Copyright © 2017年 springcome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataListViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *dataList;
@property (assign, nonatomic) BOOL isLoadingData;
@property (assign, nonatomic) NSInteger currentPageNum;

- (void)queryDataListWithPageNum:(NSInteger)pageNum;

@end
