//
//  MyImagePickerController.h
//  cameraDemo
//
//  Created by yuyaolong on 15/3/23.
//  Copyright (c) 2015年 yuyaolong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyImagePickerController;

@protocol myImagePickerControllerDelegate <NSObject>

@required
-(void)dismissCamre:(MyImagePickerController *)sender;
@end

@interface MyImagePickerController : UIImagePickerController
@property (nonatomic,weak)id<myImagePickerControllerDelegate> mydelegate;

-(void)sendThumbNail:(UIImage *)image;

@property (nonatomic,strong)NSString *soundSavePath;
@end
