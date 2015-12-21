//
//  filtedImage.m
//  cameraModel
//
//  Created by yuyaolong on 15/4/15.
//  Copyright (c) 2015年 yuyaolong. All rights reserved.
//

#import "filtedImage.h"

@interface filtedImage()

@end

@implementation filtedImage


//gammaAdjust
+ (UIImage *)gammaAdjustWith:(UIImage *)image andParameters:(NSNumber *)gammaValue setDefault:(BOOL)setDefalt
{
    //UIImage转化CIImage
    CIImage *ciImage = [[CIImage alloc]initWithImage:image];
    //创建滤波
    CIFilter *filter = [CIFilter filterWithName:@"CIGammaAdjust"
                                  keysAndValues:kCIInputImageKey, ciImage, @"inputPower", gammaValue, nil];
    if (setDefalt == YES) {
        [filter setDefaults];
    }
    
    // 获取绘制上下文
    CIContext *context = [CIContext contextWithOptions:nil];
    // 渲染并输出CIImage
    CIImage *outputImage = [filter outputImage];
    // 创建CGImage句柄
    CGImageRef cgImage = [context createCGImage:outputImage
                                       fromRect:[outputImage extent]];
    UIImage *outimage = [UIImage imageWithCGImage:cgImage scale:1 orientation:UIImageOrientationRight];
    // 释放CGImage句柄
    CGImageRelease(cgImage);
    return  outimage;
}


+ (UIImage *)CINoiseReductionWith:(UIImage *)image andParametersinputNoiseLevel:(NSNumber *)a  inputSharpness:(NSNumber *)b setDefault:(BOOL)setDefalt
{
    //UIImage转化CIImage
    CIImage *ciImage = [[CIImage alloc]initWithImage:image];
    //创建滤波
    CIFilter *filter = [CIFilter filterWithName:@"CINoiseReduction"
                                  keysAndValues:kCIInputImageKey, ciImage, @"inputNoiseLevel",a, @"inputSharpness", b, nil];
    if (setDefalt == YES) {
        [filter setDefaults];
    }
    // 获取绘制上下文
    CIContext *context = [CIContext contextWithOptions:nil];
    // 渲染并输出CIImage
    CIImage *outputImage = [filter outputImage];
    // 创建CGImage句柄
    CGImageRef cgImage = [context createCGImage:outputImage
                                       fromRect:[outputImage extent]];
    UIImage *outimage = [UIImage imageWithCGImage:cgImage scale:1 orientation:UIImageOrientationRight];
    
    // 释放CGImage句柄
    CGImageRelease(cgImage);
    return  outimage;
}
+ (UIImage *)CIPhotoEffectNoirWith:(UIImage *)image setDefault:(BOOL)setDefalt
{
    //UIImage转化CIImage
    CIImage *ciImage = [[CIImage alloc]initWithImage:image];
    //创建滤波
    CIFilter *filter = [CIFilter filterWithName:@"CIPhotoEffectNoir"
                                  keysAndValues:kCIInputImageKey, ciImage, nil];
    if (setDefalt == YES) {
        [filter setDefaults];
    }
    // 获取绘制上下文
    CIContext *context = [CIContext contextWithOptions:nil];
    // 渲染并输出CIImage
    CIImage *outputImage = [filter outputImage];
    // 创建CGImage句柄
    CGImageRef cgImage = [context createCGImage:outputImage
                                       fromRect:[outputImage extent]];
    UIImage *outimage = [UIImage imageWithCGImage:cgImage scale:1 orientation:UIImageOrientationRight];
    // 释放CGImage句柄
    CGImageRelease(cgImage);
    return  outimage;
}

+ (UIImage *)CIUnsharpMaskWith:(UIImage *)image andParametersInputRadius:(NSNumber *)a inputIntensity:(NSNumber *)b setDefault:(BOOL)setDefalt
{
    //UIImage转化CIImage
    CIImage *ciImage = [[CIImage alloc]initWithImage:image];
    //创建滤波
    CIFilter *filter = [CIFilter filterWithName:@"CIUnsharpMask"
                                  keysAndValues:kCIInputImageKey, ciImage, @"InputRadius", a, @"inputIntensity", b, nil];
    if (setDefalt == YES) {
        [filter setDefaults];
    }
    // 获取绘制上下文
    CIContext *context = [CIContext contextWithOptions:nil];
    // 渲染并输出CIImage
    CIImage *outputImage = [filter outputImage];
    // 创建CGImage句柄
    CGImageRef cgImage = [context createCGImage:outputImage
                                       fromRect:[outputImage extent]];
    UIImage *outimage = [UIImage imageWithCGImage:cgImage scale:1 orientation:UIImageOrientationRight];
    // 释放CGImage句柄
    CGImageRelease(cgImage);
    return  outimage;
}


@end
