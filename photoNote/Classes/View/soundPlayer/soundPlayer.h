//
//  soundPlayer.h
//  cameraModel
//
//  Created by yuyaolong on 15/4/15.
//  Copyright (c) 2015年 yuyaolong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface soundPlayer : UIView
//需要播放文件的URL
@property (nonatomic, strong)NSURL *URLForPlay;

//在添加的视图控制器的viewWillDisappear调用此方法
- (void)resetPlayer;

//初始化
+(soundPlayer *)instanceSelf;
-(void)setSoundPlayerUI;
@end
