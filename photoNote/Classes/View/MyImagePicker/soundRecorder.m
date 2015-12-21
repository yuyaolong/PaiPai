//
//  soundRecorder.m
//  cameraModel
//
//  Created by yuyaolong on 15/4/18.
//  Copyright (c) 2015年 yuyaolong. All rights reserved.
//

#import "soundRecorder.h"
#import <AVFoundation/AVFoundation.h>

@interface soundRecorder()<AVAudioRecorderDelegate>
@property (nonatomic,strong)AVAudioRecorder *audioRecorder; //录音机
@property (nonatomic,strong)NSTimer *timer;//监控定时器
@property (weak, nonatomic) IBOutlet UIButton *resumeButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *recoderStartOrCancelButton;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *audioPower;
@property (weak, nonatomic) IBOutlet UIImageView *trangleView;
@property (nonatomic, strong)NSURL *URLForRecord;

@end

@implementation soundRecorder

unsigned int timerCount=0;

-(void)initRecorderWithURL:(NSURL *)URLForRecord
{
    self.URLForRecord = URLForRecord;
    [self setAudioSession];
    self.resumeButton.showsTouchWhenHighlighted = YES;
    self.stopButton.showsTouchWhenHighlighted = YES;
    self.recoderStartOrCancelButton.showsTouchWhenHighlighted = YES;
    self.didFinishedRecord = 1;
}

- (IBAction)resumeOrPauseClick:(UIButton *)sender {
    if ([self.audioRecorder isRecording]) {
        [self.audioRecorder pause];
        //停止定时器
        self.timer.fireDate=[NSDate distantFuture];
        [sender setImage:[UIImage imageNamed:@"start"] forState:UIControlStateNormal];
        [self.delegate informLabelShow:@"Pause SoundRecorder"];
        
    }
    else
    {
        [self record];
        self.recoderStartOrCancelButton.enabled = NO;
        [sender setImage:[UIImage imageNamed:@"Pause"] forState:UIControlStateNormal];
        [self.delegate informLabelShow:@"Start SoundRecorder"];
        self.didFinishedRecord = 0;
    }
}


- (IBAction)stopClick:(UIButton *)sender {
    NSLog(@"saved");
    [self.audioRecorder stop];
    self.timer.fireDate=[NSDate distantFuture];
    self.audioPower.progress=0.5;
    timerCount = 0;
    [self.resumeButton setImage:[UIImage imageNamed:@"start"] forState:UIControlStateNormal];
    self.recoderStartOrCancelButton.enabled = YES;
    [self.delegate informLabelShow:@"Sound Saved"];
    self.didFinishedRecord = 1;
    
}

- (void)record
{
    if (![self.audioRecorder isRecording]) {
        [self.audioRecorder recordAtTime:timerCount*1.0/10];//首次使用应用时如果调用record方法会询问用户是否允许使用麦克风
        //开启定时器
        self.timer.fireDate=[NSDate distantPast];
    }
}


//录音的按钮总的状态切换
- (IBAction)recordStartOrCancel:(UIButton *)sender {
    //0是打开扇形，1是关闭
    if (sender.tag == 0) {
        sender.tag = 1;
        [sender setImage:[UIImage imageNamed:@"voice"] forState:UIControlStateNormal];
        [UIView animateWithDuration:1 animations:^{
            self.trangleView.alpha = 0.0;
            self.trangleView.transform = CGAffineTransformMakeScale(0.2,0.2);
            self.resumeButton.alpha = 0.0;
            self.resumeButton.transform = CGAffineTransformMakeScale(0.2,0.2);
            self.stopButton.alpha = 0.0;
            self.stopButton.transform = CGAffineTransformMakeScale(0.2,0.2);
            self.timerLabel.alpha = 0.0;
            self.timerLabel.transform = CGAffineTransformMakeScale(0.2,0.2);
            self.audioPower.alpha = 0.0;
            self.audioPower.transform = CGAffineTransformMakeScale(0.2,0.2);
            
        }completion:^(BOOL finished) {
            self.trangleView.hidden = YES;
            self.resumeButton.hidden = YES;
            self.stopButton.hidden = YES;
            self.timerLabel.hidden = YES;
            self.audioPower.hidden = YES;
        }];
    }
    else if (sender.tag == 1){
        sender.tag = 0;
        [sender setImage:[UIImage imageNamed:@"Cancel"] forState:UIControlStateNormal];
        [UIView animateWithDuration:1.0 animations:^{
            self.trangleView.hidden = NO;
            self.trangleView.transform = CGAffineTransformMakeScale(1,1);
            self.resumeButton.hidden = NO;
            self.resumeButton.transform = CGAffineTransformMakeScale(1,1);
            self.stopButton.hidden = NO;
            self.stopButton.transform = CGAffineTransformMakeScale(1,1);
            self.timerLabel.hidden = NO;
            self.timerLabel.transform = CGAffineTransformMakeScale(1,1);
            self.audioPower.hidden = NO;
            self.audioPower.transform = CGAffineTransformMakeScale(1,1);
            self.trangleView.alpha = 1;
            self.resumeButton.alpha = 1;
            self.stopButton.alpha = 1;
            self.timerLabel.alpha = 1;
            self.audioPower.alpha = 1;
        }];
    }
}

#pragma mark - audioRecordSettings
//更新检测数据以及UIProgressView,定时器调用的函数
-(void)audioPowerIsChanged
{
    [self.audioRecorder updateMeters];//更新检测
    float power = [self.audioRecorder averagePowerForChannel:0];//注音音频的强度范围是－160到0
    CGFloat progress = (1.0/160.0)*(power+160.0);
    [self.audioPower setProgress:progress];
    
    timerCount++;
    unsigned int timer = timerCount/10;
    unsigned int hour = timer/3600;
    unsigned int minute = (timer-hour*3600)/60;
    unsigned int second = timer%60;
    NSString *string = [NSString stringWithFormat:@"%02d:%02d:%02d",hour,minute,second];
    self.timerLabel.text = string;
    
}


//定时器设置
- (NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(audioPowerIsChanged) userInfo:nil repeats:YES];
    }
    return _timer;
}

//实例化录音机
- (AVAudioRecorder *)audioRecorder
{
    if (!_audioRecorder) {
        //设置文件路径
        NSURL *url = self.URLForRecord;
        //设置录音格式
        NSDictionary *settings = [self getAudioSetting];
        NSError *error = nil;
        _audioRecorder = [[AVAudioRecorder alloc]initWithURL:url settings:settings error:&error];
        _audioRecorder.delegate = self;
        _audioRecorder.meteringEnabled = YES;//设置检测为YES
        
        if (error) {
            NSLog(@"创建录音机对象时发生错误，错误信息：%@",error.localizedDescription);
            return nil;
        }
        
    }
    return _audioRecorder;
}



//设置音频会话
-(void)setAudioSession
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    //设置播放和录制声音
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
}



//取得录音文件的设置 （是NSDictionary格式）
- (NSDictionary *)getAudioSetting
{
    NSMutableDictionary *settings= [NSMutableDictionary dictionary];
    //录音格式
    [settings setObject:@(kAudioFormatLinearPCM) forKeyedSubscript:AVFormatIDKey];
    //设置采样率，8K
    [settings setObject:@(8000) forKeyedSubscript:AVSampleRateKey];
    //设置采样通道
    [settings setObject:@(1) forKeyedSubscript:AVNumberOfChannelsKey];
    //设置采样点位数， 分为8、16、24、32
    [settings setObject:@(8) forKeyedSubscript:AVLinearPCMBitDepthKey];
    //是否使用浮点数采样
    [settings setObject:@(YES) forKeyedSubscript:AVLinearPCMIsFloatKey];
    
    return settings;
}

#pragma mark - 录音机代理方法
//录音完成后触发
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    NSLog(@"%@",@"录音完成!");
}

@end
