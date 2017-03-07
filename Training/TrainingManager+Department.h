//
//  TrainingManager+Department.h
//  Training
//
//  Created by lichunwang on 16/12/26.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrainingManager.h"

@interface TrainingManager (Department)

- (void)queryDepartmentsWithCompletion:(void(^)(NSError *error, NSArray *departments))completion;

@end
