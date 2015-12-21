//
//  imageCell.m
//  cameraDemo
//
//  Created by yuyaolong on 15/3/29.
//  Copyright (c) 2015年 yuyaolong. All rights reserved.
//

#import "imageCell.h"
@interface imageCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation imageCell

- (void)setImage:(UIImage *)image
{
    self.imageView.image  = image;
}

- (void)awakeFromNib {
    // Initialization code
    self.imageView.layer.borderWidth = 3;
    self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.imageView.layer.cornerRadius = 3;
    self.imageView.clipsToBounds = YES;
}

-(void)changBorderColor
{
    self.imageView.layer.borderColor = [UIColor greenColor].CGColor;
}
-(void)resumeBorderColor
{
    self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
}

@end
