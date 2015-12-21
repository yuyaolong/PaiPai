//
//  PNImageFileService.h
//  photoNote
//
//  Created by yuyaolong on 15/4/29.
//  Copyright (c) 2015年 yuyaolong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PNSingleton.h"

@interface PNImageFileService : NSObject
singleton_interface(PNImageFileService)

/**
 *  根据照片的imagePath压缩照片为JPEG存入Document
 *
 *  @param imagePath
 */
-(void)saveImageToFileByPath:(NSString *)imagePath withImage:(UIImage *)image;

/**
 *  根据照片的路径imagePath读取图片
 *
 *  @param imagePath
 *
 *  @return 压缩后照片
 */
-(UIImage *)readImageFromFileByPath:(NSString *)imagePath;


/**
 *  根据照片的路径imagePath删除图片
 *
 *  @param imagePath 
 */
-(void)removeImageFileByPath:(NSString *)imagePath;

@end
