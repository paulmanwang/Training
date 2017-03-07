//
//  TrainingManager+Material.h
//  Training
//
//  Created by lichunwang on 17/1/5.
//  Copyright © 2017年 springcome. All rights reserved.
//

#import "TrainingManager.h"

@interface TrainingManager (Material)

- (void)queryMaterialListWithStartTime:(NSString *)startTime
                               endTime:(NSString *)endTime
                          departmentId:(NSInteger)departmentId
                                  theme:(NSString *)theme
                                pageNum:(NSInteger)pageNum
                               pageSize:(NSInteger)pageSize
                             compeltion:(void(^)(NSError *error, NSArray *materialList))completion;

- (void)addMaterialWithParameters:(NSDictionary *)parameters
                     completion:(void(^)(NSError *error))completion;

- (void)deleteMaterialWithMId:(NSString *)mid
                   completion:(void(^)(NSError *error))completion;

- (void)verifyMaterailWithMId:(NSString *)mid
                    isApprove:(BOOL)isApprove
                   completion:(void(^)(NSError *error))completion;


@end
