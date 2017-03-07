//
//  TrainingManager+RoomArrange.h
//  Training
//
//  Created by lichunwang on 16/12/27.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrainingManager (RoomArrangement)

- (void)addRoomArrangementWithParameters:(NSDictionary *)parameters
                              completion:(void(^)(NSError *error))completion;

- (void)deleteRoomArrangementWithRId:(NSString *)rid
                          completion:(void(^)(NSError *error))completion;

- (void)editRoomArrangementWithParameters:(NSDictionary *)parameters
                               completion:(void(^)(NSError *error))completion;

- (void)queryRoomArrangementListWithDate:(NSString *)date
                                    time:(NSInteger)time
                              completion:(void(^)(NSError *error, NSArray *idleList, NSArray *arrangementList))completion;

@end
