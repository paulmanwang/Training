//
//  MovieBarManager+Upload.h
//  TimeCloud
//
//  Created by lichunwang on 16/10/25.
//  Copyright © 2016年 Xunlei. All rights reserved.
//

#import "TrainingManager.h"

@interface TrainingManager (Upload)

// 上传文件
- (void)uploadFileWithType:(NSInteger)type
                  fileData:(NSData *)fileData
               contentType:(NSString *)contentType
                completion:(void(^)(NSError *error, NSString *url))completion;

@end

