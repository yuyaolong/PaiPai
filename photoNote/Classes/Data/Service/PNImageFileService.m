//
//  PNImageFileService.m
//  photoNote
//
//  Created by yuyaolong on 15/4/29.
//  Copyright (c) 2015年 yuyaolong. All rights reserved.
//

#import "PNImageFileService.h"
#import "PNSingleton.h"
#define imageQualit 0.5
@interface PNImageFileService()

@property(nonatomic,strong)NSString* doc;

@end


@implementation PNImageFileService
singleton_implementation(PNImageFileService)

- (NSString *)doc
{
    if (!_doc) {
        _doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject];
        NSString *foldPath = [_doc stringByAppendingString:@"/noteImages"];
        [[NSFileManager defaultManager] createDirectoryAtPath:foldPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return _doc;
}

-(NSString *)getFilePathByimagePath:(NSString *)imagePath
{
    NSString *path = [self.doc stringByAppendingPathComponent:[NSString stringWithFormat:@"/noteImages/%@",imagePath]];
    return path;
}


-(void)saveImageToFileByPath:(NSString *)imagePath withImage:(UIImage *)image
{
    if (image != nil) {
        NSString *filePath = [self getFilePathByimagePath:imagePath];
        NSData *imageData = UIImageJPEGRepresentation(image, imageQualit);
        [imageData writeToFile:filePath atomically:YES];
        NSLog(@"成功存入一张照片到文件");
    }
    else
    {
        NSLog(@"存入照片文件失败");
    }
    
    
}

-(UIImage *)readImageFromFileByPath:(NSString *)imagePath
{
    NSString *filePath = [self getFilePathByimagePath:imagePath];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    UIImage *image = [UIImage imageWithData:imageData];
    if (image != nil) {
        NSLog(@"成功读取一张照片从文件");
    }
    else
    {
        NSLog(@"读取照片文件失败");
    }
    return image;
}

-(void)removeImageFileByPath:(NSString *)imagePath
{
    if (imagePath != nil) {
        if ([self readImageFromFileByPath:imagePath]!=nil) {
             NSString *filePath = [self getFilePathByimagePath:imagePath];
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
            NSLog(@"成功删除一个照片文件");
        }
        else
        {
            NSLog(@"文件夹中不存在需要删除的照片");
        }
        
    }
}

@end
