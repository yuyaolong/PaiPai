//
//  soundRecorder.h
//  cameraModel
//
//  Created by yuyaolong on 15/4/18.
//  Copyright (c) 2015年 yuyaolong. All rights reserved.

// use initWithFram to instance
//
//录音的时候只能都先保存在一个临时URL，完成录音后要将文件保存

#import <UIKit/UIKit.h>

@protocol soundRecorderDelegate <NSObject>

@required
//按钮按下时显示通知的方法由调用的父视图去实现
-(void)informLabelShow:(NSString *)string;
@end

@interface soundRecorder : UIView
//1录音完成，0真正录音
@property NSInteger didFinishedRecord; //外部可知是否录音完成来取文件里的录音
@property (nonatomic,weak)id<soundRecorderDelegate>delegate;
-(IBAction)stopClick:(UIButton *)sender;
-(void)initRecorderWithURL:(NSURL *)URLForRecord;



@property(nonatomic,strong)NSString *soundSavePath;
@end
