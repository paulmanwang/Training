//
//  DepartmentItem.h
//  Training
//
//  Created by lichunwang on 16/12/26.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>

@interface DepartmentInfo : JSONModel

@property (copy, nonatomic) NSString *departmentName;
@property (assign, nonatomic) NSInteger departmentId;

@end
