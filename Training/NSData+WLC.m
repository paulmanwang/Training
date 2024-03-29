//
//  NSData+WLC.m
//  Training
//
//  Created by lichunwang on 17/2/6.
//  Copyright © 2017年 springcome. All rights reserved.
//

#import "NSData+WLC.h"
#import <zlib.h>

#define CHUNK_SIZE 16384

@implementation NSData (WLC)

- (NSString *)hexString
{
    NSUInteger length = [self length];
    if (length == 0) {
        return nil;
    }
    
    const Byte *p = [self bytes];
    NSMutableString *hexString = [NSMutableString new];
    for (NSInteger i = 0; i < length; i++) {
        [hexString appendFormat:@"%02x", *p++];
    }
    
    return [hexString uppercaseString];
}

+ (NSData *)dataWithBase64EncodedString:(NSString *)string
{
    const char lookup[] =
    {
        99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
        99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
        99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 62, 99, 99, 99, 63,
        52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 99, 99, 99, 99, 99, 99,
        99, 0,  1,  2,  3,  4,  5,  6,  7,  8,  9,  10, 11, 12, 13, 14,
        15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 99, 99, 99, 99, 99,
        99, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
        41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 99, 99, 99, 99, 99
    };
    
    NSData              *inputData = [string dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    long long            inputLength = [inputData length];
    const unsigned char *inputBytes = [inputData bytes];
    
    long long      maxOutputLength = (inputLength / 4 + 1) * 3;
    NSMutableData *outputData = [NSMutableData dataWithLength:(NSUInteger)maxOutputLength];
    unsigned char *outputBytes = (unsigned char *)[outputData mutableBytes];
    
    int           accumulator = 0;
    long long     outputLength = 0;
    unsigned char accumulated[] = {0, 0, 0, 0};
    
    for (long long i = 0; i < inputLength; i++)
    {
        unsigned char decoded = lookup[inputBytes[i] & 0x7F];
        
        if (decoded != 99)
        {
            accumulated[accumulator] = decoded;
            
            if (accumulator == 3)
            {
                outputBytes[outputLength++] = (accumulated[0] << 2) | (accumulated[1] >> 4);
                outputBytes[outputLength++] = (accumulated[1] << 4) | (accumulated[2] >> 2);
                outputBytes[outputLength++] = (accumulated[2] << 6) | accumulated[3];
            }
            
            accumulator = (accumulator + 1) % 4;
        }
    }
    
    // handle left-over data
    if (accumulator > 0)
    {
        outputBytes[outputLength] = (accumulated[0] << 2) | (accumulated[1] >> 4);
    }
    
    if (accumulator > 1)
    {
        outputBytes[++outputLength] = (accumulated[1] << 4) | (accumulated[2] >> 2);
    }
    
    if (accumulator > 2)
    {
        outputLength++;
    }
    
    // truncate data to match actual output length
    outputData.length = (NSUInteger)outputLength;
    return outputLength ? outputData : nil;
}

- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth
{
    // ensure wrapWidth is a multiple of 4
    wrapWidth = (wrapWidth / 4) * 4;
    
    const char lookup[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    
    long long            inputLength = [self length];
    const unsigned char *inputBytes = [self bytes];
    
    long long maxOutputLength = (inputLength / 3 + 1) * 4;
    maxOutputLength += wrapWidth ? (maxOutputLength / wrapWidth) * 2 : 0;
    unsigned char *outputBytes = (unsigned char *)malloc((size_t)maxOutputLength);
    
    long long i;
    long long outputLength = 0;
    
    for (i = 0; i < inputLength - 2; i += 3)
    {
        outputBytes[outputLength++] = lookup[(inputBytes[i] & 0xFC) >> 2];
        outputBytes[outputLength++] = lookup[((inputBytes[i] & 0x03) << 4) | ((inputBytes[i + 1] & 0xF0) >> 4)];
        outputBytes[outputLength++] = lookup[((inputBytes[i + 1] & 0x0F) << 2) | ((inputBytes[i + 2] & 0xC0) >> 6)];
        outputBytes[outputLength++] = lookup[inputBytes[i + 2] & 0x3F];
        
        // add line break
        if (wrapWidth && ((outputLength + 2) % (wrapWidth + 2) == 0))
        {
            outputBytes[outputLength++] = '\r';
            outputBytes[outputLength++] = '\n';
        }
    }
    
    // handle left-over data
    if (i == inputLength - 2)
    {
        // = terminator
        outputBytes[outputLength++] = lookup[(inputBytes[i] & 0xFC) >> 2];
        outputBytes[outputLength++] = lookup[((inputBytes[i] & 0x03) << 4) | ((inputBytes[i + 1] & 0xF0) >> 4)];
        outputBytes[outputLength++] = lookup[(inputBytes[i + 1] & 0x0F) << 2];
        outputBytes[outputLength++] = '=';
    }
    else if (i == inputLength - 1)
    {
        // == terminator
        outputBytes[outputLength++] = lookup[(inputBytes[i] & 0xFC) >> 2];
        outputBytes[outputLength++] = lookup[(inputBytes[i] & 0x03) << 4];
        outputBytes[outputLength++] = '=';
        outputBytes[outputLength++] = '=';
    }
    
    // truncate data to match actual output length
    outputBytes = realloc(outputBytes, (size_t)outputLength);
    NSString *result = [[NSString alloc] initWithBytesNoCopy:outputBytes length:(NSUInteger)outputLength encoding:NSASCIIStringEncoding freeWhenDone:YES];
    
#if !__has_feature(objc_arc)
    [result autorelease];
#endif
    
    return (outputLength >= 4) ? result : nil;
}

- (NSString *)base64EncodedString
{
    return [self base64EncodedStringWithWrapWidth:0];
}

/*!
 * @abstract
 * 使用gzip格式进行数据压缩
 *
 * @param level
 * 压缩比，默认为Z_DEFAULT_COMPRESSION
 *
 * @result
 * 压缩后的数据
 */
- (NSData *)gzippedDataWithCompressionLevel:(float)level
{
    if ([self length])
    {
        z_stream stream;
        stream.zalloc = Z_NULL;
        stream.zfree = Z_NULL;
        stream.opaque = Z_NULL;
        stream.avail_in = (uint)[self length];
        stream.next_in = (Bytef *)[self bytes];
        stream.total_out = 0;
        stream.avail_out = 0;
        
        int compression = (level < 0.0f) ? Z_DEFAULT_COMPRESSION : (int)roundf(level * 9);
        
        if (deflateInit2(&stream, compression, Z_DEFLATED, 31, 8, Z_DEFAULT_STRATEGY) == Z_OK)
        {
            NSMutableData *data = [NSMutableData dataWithLength:CHUNK_SIZE];
            
            while (stream.avail_out == 0)
            {
                if (stream.total_out >= [data length])
                {
                    data.length += CHUNK_SIZE;
                }
                
                stream.next_out = [data mutableBytes] + stream.total_out;
                stream.avail_out = (uint)([data length] - stream.total_out);
                deflate(&stream, Z_FINISH);
            }
            
            deflateEnd(&stream);
            data.length = stream.total_out;
            return data;
        }
    }
    
    return nil;
}

/*!
 * @abstract
 * 使用gzip格式进行数据压缩
 *
 * @discussion
 * 压缩比，默认为Z_DEFAULT_COMPRESSION
 *
 * @result
 * 压缩后的数据
 */
- (NSData *)gzippedData
{
    return [self gzippedDataWithCompressionLevel:-1.0f];
}

/*!
 * @abstract
 * 使用gzip格式进行数据解压缩
 *
 * @result
 * 解压缩后的数据
 */
- (NSData *)gunzippedData
{
    if ([self length])
    {
        z_stream stream;
        stream.zalloc = Z_NULL;
        stream.zfree = Z_NULL;
        stream.avail_in = (uint)[self length];
        stream.next_in = (Bytef *)[self bytes];
        stream.total_out = 0;
        stream.avail_out = 0;
        
        NSMutableData *data = [NSMutableData dataWithLength:[self length] * 1.5];
        
        if (inflateInit2(&stream, 47) == Z_OK)
        {
            int status = Z_OK;
            
            while (status == Z_OK)
            {
                if (stream.total_out >= [data length])
                {
                    data.length += [self length] * 0.5;
                }
                
                stream.next_out = [data mutableBytes] + stream.total_out;
                stream.avail_out = (uint)([data length] - stream.total_out);
                status = inflate(&stream, Z_SYNC_FLUSH);
            }
            
            if (inflateEnd(&stream) == Z_OK)
            {
                if (status == Z_STREAM_END)
                {
                    data.length = stream.total_out;
                    return data;
                }
            }
        }
    }
    
    return nil;
}

@end
