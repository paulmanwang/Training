//
//  MovieBarManager+Upload.m
//  TimeCloud
//
//  Created by lichunwang on 16/10/25.
//  Copyright © 2016年 Xunlei. All rights reserved.
//

#import "TrainingManager+Upload.h"

@implementation TrainingManager (Upload)

- (void)uploadFileWithType:(NSInteger)type
                  fileData:(NSData *)fileData
               contentType:(NSString *)contentType
                completion:(void(^)(NSError *error, NSString *url))completion
{
    NSString *uploadPath = nil;
    if (type == 0) {
        uploadPath = kUploadSummaryFilePath;
    }
    else {
        uploadPath = kUploadMaterialFilePath;
    }
    NSString *url = [NSString stringWithFormat:@"%@%@", kServerBaseUrl, uploadPath];
    
    [WLCFileUploader uploadFileWithPath:url
                                   name:@"file"
                               fileName:@"test.png"
                               fileData:fileData
                            contentType:contentType
                        timeoutInterval:30.0f
                               progress:nil
                             completion:^(NSError *error, NSDictionary *responseObject)
     {
         if (error) {
             NSLog(@"上传失败 error = %@", error);
             if (completion) {
                 completion(error, nil);
             }
             return;
         }
         
         NSLog(@"jsonData = %@", responseObject);
         NSInteger code = ((NSNumber *)responseObject[@"code"]).integerValue;
         if (code == 0) {
             NSDictionary *dic = responseObject[@"data"];
             if (completion) {
                 completion(nil, dic[@"url"]);
             }
         }
         else {
             if (completion) {
                 NSError *error = [NSError errorWithDomain:@"TrainingManagerErrorDomain" code:-1 userInfo:nil];
                 completion(error, nil);
             }
         }
    }];
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer.timeoutInterval = 30; // 5M限制为30秒
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    
//    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        [formData appendPartWithFileData:fileData name:@"file" fileName:@"test.png" mimeType:contentType];
//    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary *jsonData = (NSDictionary *)responseObject;
//        NSLog(@"jsonData = %@", jsonData);
//        NSInteger code = ((NSNumber *)jsonData[@"code"]).integerValue;
//        if (code == 0) {
//            NSDictionary *dic = jsonData[@"data"];
//            if (completion) {
//                completion(nil, dic[@"url"]);
//            }
//        }
//        else {
//            if (completion) {
//                NSError *error = [NSError errorWithDomain:@"TrainingManagerErrorDomain" code:-1 userInfo:nil];
//                completion(error, nil);
//            }
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"上传失败 error = %@", error);
//        if (completion) {
//            completion(error, nil);
//        }
//    }];
}

@end
