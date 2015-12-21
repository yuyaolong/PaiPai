//
//  PNImageScrollView.h
//  photoNote
//
//  Created by yuyaolong on 15/5/4.
//  Copyright (c) 2015年 yuyaolong. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface PNImageScrollView : UIView
@property (nonatomic,strong)NSArray *showImages;
//初始化view的元素
-(void)initImageScrollView;
@end
