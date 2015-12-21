//
//  filtedImage.h
//  cameraModel
//
//  Created by yuyaolong on 15/4/15.
//  Copyright (c) 2015年 yuyaolong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface filtedImage : UIImage

// gammaValue default 0.75   >1(improve light detail)  <1(improve dark detail)
+ (UIImage *)gammaAdjustWith:(UIImage *)image andParameters:(NSNumber *)gammaValue setDefault:(BOOL)setDefalt;

//reduce noise inputNoiseLevel(0.02) inputSharpness(0.4)
+ (UIImage *)CINoiseReductionWith:(UIImage *)image andParametersinputNoiseLevel:(NSNumber *)a  inputSharpness:(NSNumber *)b setDefault:(BOOL)setDefalt;
//noir
+ (UIImage *)CIPhotoEffectNoirWith:(UIImage *)image setDefault:(BOOL)setDefalt;

//sharp (2.5 0.5)
+ (UIImage *)CIUnsharpMaskWith:(UIImage *)image andParametersInputRadius:(NSNumber *)a inputIntensity:(NSNumber *)b setDefault:(BOOL)setDefalt;
@end
