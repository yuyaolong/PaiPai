//
//  camraOverLayoutView.m
//  cameraModel
//
//  Created by yuyaolong on 15/4/14.
//  Copyright (c) 2015年 yuyaolong. All rights reserved.
//

#import "camraOverLayoutView.h"
#import "soundRecorder.h"

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define recorderX 618
#define recorderY 781
#define recorderW 150
#define recorderH 152

@interface camraOverLayoutView()<UIImagePickerControllerDelegate,UINavigationBarDelegate,soundRecorderDelegate>

@property (nonatomic, weak)MyImagePickerController *superImagePickerC;

@property (weak, nonatomic) IBOutlet UIButton *takePictureButton;
@property (weak, nonatomic) IBOutlet UIButton *cameraCancel;
@property (weak, nonatomic) IBOutlet UILabel *photoNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *albumButton;
@property (weak, nonatomic) IBOutlet UIButton *flashButton;
@property (weak, nonatomic) IBOutlet UIButton *cameraSwitchButton;

@property (weak, nonatomic) IBOutlet UIImageView *focusCursor;//光标
@property (weak, nonatomic) IBOutlet UILabel *informLabel;//按钮的事件的通知提示


@property (strong, nonatomic)soundRecorder* record;


@end


@implementation camraOverLayoutView

-(void)awakeFromNib
{
     NSLog(@"%@",self.soundSavePath);
}


//从Path取得保存录音文件的URL
- (NSURL *)getSaveURL
{
    
    NSLog(@"%@",self.soundSavePath);
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"/soundFiles/%@.caf", self.soundSavePath]];
    NSLog(@"file path:%@",path);
    NSURL *url = [NSURL fileURLWithPath:path];
    return url;
     
}


-(void)informLabelShow:(NSString *)string
{
    self.informLabel.hidden = NO;
    self.informLabel.font = [UIFont systemFontOfSize:20];
    [self.informLabel setText:string];
    
    [UIView animateWithDuration:1 animations:^{
        self.informLabel.alpha = 0;
    }completion:^(BOOL finished) {
        self.informLabel.alpha = 1;
        self.informLabel.hidden = YES;
    }];
}

//将缩略图传回来进行显示
- (void)sendThumbNailToShow:(UIImage *)image
{
    [self.albumButton setBackgroundImage:image forState:UIControlStateNormal];
    NSInteger number =  [self.photoNumberLabel.text integerValue];
    [self.photoNumberLabel setText:[NSString stringWithFormat:@"%ld",(long)++number]];
}

#pragma mark - buttonAction
//点击拍照按钮后进行拍照
- (IBAction)takePicture:(UIButton *)sender {
    [self.superImagePickerC takePicture];
}


//转换flash的状态
- (IBAction)changeFlash:(UIButton *)sender {
    sender.tag++;
    if (isPad) {
        self.flashButton.enabled = NO;
        [self informLabelShow:@"can't open flash on IPad"];
    }else{
        
        if (sender.tag%3 == 0) {
            self.superImagePickerC.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
            [self.flashButton setImage:[UIImage imageNamed:@"aflash"] forState:UIControlStateNormal];
            [self informLabelShow:@"Flash Auto"];
        }else if (sender.tag%3 == 1)
        {
            self.superImagePickerC.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
            [self.flashButton setImage:[UIImage imageNamed:@"flash"] forState:UIControlStateNormal];
            [self informLabelShow:@"Flash On"];
        }else if (sender.tag%3 == 2)
        {
            self.superImagePickerC.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
            [self.flashButton setImage:[UIImage imageNamed:@"noflash"] forState:UIControlStateNormal];
            [self informLabelShow:@"Flash Off"];
        }
    }
    
}
//切换前后摄像头
- (IBAction)camraSwitch:(UIButton *)sender {
    if (self.superImagePickerC.cameraDevice == UIImagePickerControllerCameraDeviceRear) {
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            self.superImagePickerC.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            [self informLabelShow:@"Front Camera On"];
        }
    }
    else {
        self.superImagePickerC.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        [self informLabelShow:@"Rear Camera Off"];
    }
    
}
//cancel照相机
- (IBAction)dismissCamera:(UIButton *)sender {
    [self.superImagePickerC.mydelegate dismissCamre:self.superImagePickerC];
    [self.record stopClick:nil];
}








#pragma mark - 设置光标
/**
 *  设置聚焦光标位置
 *
 *  @param point 光标位置
 */
-(void)setFocusCursorWithPoint:(CGPoint)point{
    self.focusCursor.center=point;
    self.focusCursor.transform=CGAffineTransformMakeScale(1.5, 1.5);
    self.focusCursor.alpha=1.0;
    [UIView animateWithDuration:0.6 animations:^{
        self.focusCursor.transform=CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.focusCursor.alpha=0;
        
    }];
}
/**
 *  添加点按手势，点按时聚焦
 */
-(void)addGenstureRecognizer{
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScreen:)];
    [self addGestureRecognizer:tapGesture];
}

-(void)tapScreen:(UITapGestureRecognizer *)tapGesture{
    NSLog(@"tapConfirm");
    CGPoint point= [tapGesture locationInView:self];
    NSLog(@"%f,%f",point.x,point.y);
    [self setFocusCursorWithPoint:point];
}

-(void)initCameraOverLayoutWith:superImagePickerC
{
    self.superImagePickerC = superImagePickerC;
    //soundRecorder *record = [[soundRecorder alloc] ini];
    soundRecorder *record = [[[NSBundle mainBundle]loadNibNamed:@"soundRecorder" owner:nil options:nil] firstObject];
    record.delegate = self;
    record.frame = CGRectMake(recorderX, recorderY, recorderW, recorderH);
    [self addSubview:record];
    [record initRecorderWithURL:[self getSaveURL]];
    self.record = record;
    
    
    [self addGenstureRecognizer];
    self.cameraCancel.layer.cornerRadius = 4;
    [self.cameraCancel clipsToBounds];
    self.albumButton.layer.cornerRadius = 4;
    [self.albumButton clipsToBounds];
    self.informLabel.hidden = YES;
    

    self.flashButton.showsTouchWhenHighlighted = YES;
    self.cameraSwitchButton.showsTouchWhenHighlighted = YES;
    self.cameraCancel.showsTouchWhenHighlighted =YES;
    self.albumButton.showsTouchWhenHighlighted = YES;
}

@end
