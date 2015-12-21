//
//  ThumbNailImage.m
//  cameraModel
//
//  Created by yuyaolong on 15/4/14.
//  Copyright (c) 2015年 yuyaolong. All rights reserved.
//

#import "ThumbNailImage.h"

@implementation ThumbNailImage

+(ThumbNailImage *)instanceWith:(UIImage *)image
{
    CGSize origImageSize = image.size;
    
    // Set thumbnail's size
    CGRect newRect = CGRectMake(0, 0, 200, 200);
    
    float ratio = MAX(newRect.size.width / origImageSize.width,
                      newRect.size.height / origImageSize.height);
    
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect
                                                    cornerRadius:4.0];
    [path addClip];
    
    CGRect projectRect;
    projectRect.size.width = ratio * origImageSize.width;
    projectRect.size.height = ratio * origImageSize.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;
    
    [image drawInRect:projectRect];
    
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
   
    return (ThumbNailImage *)smallImage;
}

@end
