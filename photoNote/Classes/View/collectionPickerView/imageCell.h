//
//  imageCell.h
//  cameraDemo
//
//  Created by yuyaolong on 15/3/29.
//  Copyright (c) 2015年 yuyaolong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface imageCell : UICollectionViewCell

@property (nonatomic,strong)UIImage *image;
-(void)changBorderColor;
-(void)resumeBorderColor;

@end
