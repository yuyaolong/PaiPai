//
//  cellScrollView.m
//  cameraDemo
//
//  Created by yuyaolong on 15/3/25.
//  Copyright (c) 2015年 yuyaolong. All rights reserved.
//

#import "cellScrollView.h"
@interface cellScrollView()<UIGestureRecognizerDelegate>

@end

@implementation cellScrollView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.maximumZoomScale = 3;
        self.minimumZoomScale = 0.2;
        //self.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.imageView.contentMode=UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
        self.delegate = self;
        [self gestureSettings];
    }
    return self;
}

-(void)gestureSettings
{
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeScale)];
    doubleTapGesture.numberOfTouchesRequired = 1;
    doubleTapGesture.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleTapGesture];
    doubleTapGesture.delegate = self;
}

-(void)changeScale
{
    NSLog(@"%f",self.zoomScale);
    if (self.zoomScale<1) {
        [self setZoomScale:1.0 animated:YES];
    }else if (self.zoomScale<self.maximumZoomScale) {
        [self setZoomScale:self.zoomScale*1.5 animated:YES];
    }else if (self.zoomScale == self.maximumZoomScale) {
        [self setZoomScale:1.0 animated:YES];
    }
    
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGSize originalSize=self.bounds.size;
    CGSize contentSize=self.contentSize;
    CGFloat offsetX=originalSize.width>contentSize.width?(originalSize.width-contentSize.width)/2:0;
    CGFloat offsetY=originalSize.height>contentSize.height?(originalSize.height-contentSize.height)/2:0;
    
    self.imageView.center=CGPointMake(contentSize.width/2+offsetX, contentSize.height/2+offsetY);
    
    
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

@end
