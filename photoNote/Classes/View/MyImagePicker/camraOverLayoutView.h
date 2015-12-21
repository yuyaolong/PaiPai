//
//  camraOverLayoutView.h
//  cameraModel
//
//  Created by yuyaolong on 15/4/14.
//  Copyright (c) 2015年 yuyaolong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyImagePickerController.h"
@interface camraOverLayoutView : UIView

-(void)sendThumbNailToShow:(UIImage *)image;
-(void)initCameraOverLayoutWith:(MyImagePickerController *)superImagePickerC;

@property (nonatomic,strong)NSString *soundSavePath;

@end
