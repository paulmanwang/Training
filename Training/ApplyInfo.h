//
//  ApplyInfo.h
//  Training
//
//  Created by lichunwang on 16/12/27.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "CourseInfo.h"

@interface ApplyInfo : JSONModel

@property (copy, nonatomic) NSString *aid;
@property (copy, nonatomic) NSString *applyTime;
@property (copy, nonatomic) NSString *cid;
@property (strong, nonatomic) CourseInfo *courseInfo;
@property (assign, nonatomic) NSInteger deleted;
@property (copy, nonatomic) NSString *modifyTime;

@end
