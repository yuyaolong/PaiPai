//
//  MyImagePickerController.m
//  cameraDemo
//
//  Created by yuyaolong on 15/3/23.
//  Copyright (c) 2015年 yuyaolong. All rights reserved.
//


#import "MyImagePickerController.h"
#import "camraOverLayoutView.h"
#import <AVFoundation/AVFoundation.h>
@interface MyImagePickerController ()<AVAudioRecorderDelegate>

@property (strong, nonatomic)  UIButton *takePictureButton;
@property (nonatomic, strong)UIButton *cancleButton;

@end

@implementation MyImagePickerController



-(void)sendThumbNail:(UIImage *)image
{
    [(camraOverLayoutView *)self.cameraOverlayView sendThumbNailToShow:image];
}

#pragma mark -objectsLazyinit

-(instancetype)init
{
    self = [super init];
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",self.soundSavePath);
    NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"camraOverLayout" owner:nil options:nil];
    camraOverLayoutView *overView = [array firstObject];
    NSLog(@"%@",self.soundSavePath);
    overView.soundSavePath = self.soundSavePath;
    __weak MyImagePickerController *imagePickerC = self;
    [overView initCameraOverLayoutWith:imagePickerC];
    
   
    self.cameraOverlayView = overView;
   
}

@end
