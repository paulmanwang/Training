//
//  TrainingManager+Message.h
//  Training
//
//  Created by lichunwang on 17/1/14.
//  Copyright © 2017年 springcome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrainingManager (Message)

- (void)queryMessageListWithPageNum:(NSInteger)pageNum
                           pageSize:(NSInteger)pageSize
                         completion:(void(^)(NSError *error, NSArray *dataList))completion;

- (void)deleteMessageWithMId:(NSString *)mid
                  completion:(void(^)(NSError *error))completion;

@end
