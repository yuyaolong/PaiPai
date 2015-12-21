//
//  soundPlayer.m
//  cameraModel
//
//  Created by yuyaolong on 15/4/15.
//  Copyright (c) 2015年 yuyaolong. All rights reserved.
//

#import "soundPlayer.h"
#import <AVFoundation/AVFoundation.h>
@interface soundPlayer()<AVAudioPlayerDelegate>
@property (nonatomic,strong)AVAudioPlayer *audioPlayer; //播放器
@property (weak ,nonatomic) NSTimer *timer;//进度更新定时器
@property (weak, nonatomic) IBOutlet UISlider *playSlider;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@end


@implementation soundPlayer

- (IBAction)playOrPause:(UIButton *)sender {
    //tag＝1是播放
    if (sender.tag == 0) {
        sender.tag = 1;
        if (![self.audioPlayer isPlaying]) {
            [self playerResume];
        }
    }else
    if (sender.tag == 1) {
        sender.tag = 0;
        if ([self.audioPlayer isPlaying]) {
            [self playerPause];
        }
    }
    [self.totalTimeLabel setText:[NSString stringWithFormat:@"%4.2f",self.audioPlayer.duration]];
            
}

-(void)playerResume
{
    [self.audioPlayer play];
    self.timer.fireDate=[NSDate distantPast];//恢复定时器
    [self.playButton setImage:[UIImage imageNamed:@"Pause"] forState:UIControlStateNormal];
    self.playButton.tag = 1;
}

-(void)playerPause
{
    [self.audioPlayer pause];
    self.timer.fireDate=[NSDate distantFuture];//暂停定时器，注意不能调用invalidate方法，此方法会取消，之后无法恢复
    [self.playButton setImage:[UIImage imageNamed:@"start"] forState:UIControlStateNormal];
    self.playButton.tag = 0;

}

- (IBAction)stopPlayerTime:(UISlider *)sender {
    [self playerPause];
}
- (IBAction)resumPlayerTime:(UISlider *)sender {
    NSTimeInterval currentTime = self.playSlider.value*self.audioPlayer.duration;
    //NSLog(@"%f",currentTime);
    self.audioPlayer.currentTime = currentTime;
    [self playerResume];
}


- (IBAction)updataCurrent:(UISlider *)sender {
    [self.currentTimeLabel setText:[NSString stringWithFormat:@"%4.2f",self.audioPlayer.currentTime]];
}

//创建播放器
-(AVAudioPlayer *)audioPlayer
{
    if (!_audioPlayer) {
        NSURL *url = self.URLForPlay;
        NSError *error = nil;
        _audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
        _audioPlayer.numberOfLoops =0;
        _audioPlayer.delegate = self;
        [_audioPlayer prepareToPlay];
        if (error) {
            NSLog(@"创建播放器过程中发生错误，错误信息：%@", error.localizedDescription);
            return nil;
        }
    }
    return _audioPlayer;
}
//设置定时器
-(NSTimer *)timer{
    if (!_timer)
    { _timer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateProgress) userInfo:nil repeats:true];
    }
    return _timer;
}

/** * 更新播放进度 */
-(void)updateProgress{
    float progress= self.audioPlayer.currentTime /self.audioPlayer.duration;
    [self.playSlider setValue:progress animated:true];
    [self.currentTimeLabel setText:[NSString stringWithFormat:@"%4.2f",self.audioPlayer.currentTime]];
    
}

#pragma mark - 播放器代理方法 
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"音乐播放完成...");
    [self resetPlayer];
}

- (void)resetPlayer
{
    [self playerPause];
    [self.timer invalidate];
    [self.playSlider setValue:0 animated:YES];
    [self.currentTimeLabel setText:@"00.00"];
    [self.totalTimeLabel setText:@"00.00"];
    
}

-(void)setSoundPlayerUI
{
    [self.totalTimeLabel setText:[NSString stringWithFormat:@"%4.2f",self.audioPlayer.duration]];
}

+(soundPlayer *)instanceSelf
{
    soundPlayer *sPlayer = [[[NSBundle mainBundle]loadNibNamed:@"soundPlayer" owner:nil options:nil] firstObject];
    return sPlayer;
}




@end
