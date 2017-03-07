//
//  TrainingManager+Apply.h
//  Training
//
//  Created by lichunwang on 16/12/27.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrainingManager (Apply)

- (void)addApplyWithCId:(NSString *)cid
             completion:(void(^)(NSError *error))completion;

- (void)deleteApplyWithCId:(NSString *)cid
                completion:(void(^)(NSError *error))completion;

- (void)queryApplyStatusWithCId:(NSString *)cid
                     completion:(void(^)(NSError *error, NSInteger status))completion;

- (void)queryApplyListWithExpired:(NSInteger)isExpired
                        startTime:(NSString *)startTime
                          endTime:(NSString *)endTime
                     departmentId:(NSInteger)departmentId
                            theme:(NSString *)theme
                          pageNum:(NSInteger)pageNum
                         pageSize:(NSInteger)pageSize
                       completion:(void(^)(NSError *error, NSArray *applyList))completion;

@end
