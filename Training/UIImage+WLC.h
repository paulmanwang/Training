//
//  UIImage+WLC.h
//  Training
//
//  Created by lichunwang on 16/12/28.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (WLC)

- (BOOL)hasAlphaChannel;

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

- (UIImage *)imageByResizeToSize:(CGSize)size;

+ (NSInteger)imageTypeWithImageData:(NSData *)data;

+ (UIImage *)decompressImage:(UIImage *)image;

@end
