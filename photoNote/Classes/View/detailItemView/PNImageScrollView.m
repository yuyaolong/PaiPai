//
//  PNImageScrollView.m
//  photoNote
//
//  Created by yuyaolong on 15/5/4.
//  Copyright (c) 2015年 yuyaolong. All rights reserved.
//

#import "PNImageScrollView.h"
#import "cellScrollView.h"
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT 700
#define SCREEN_WIDTH_HALF [UIScreen mainScreen].bounds.size.width/2
#define IMAGEVIEW_COUNT 3

@interface PNImageScrollView()<UIScrollViewDelegate>
@property (strong,nonatomic)cellScrollView *centralScrollView;
@property (strong,nonatomic)cellScrollView *leftScrollView;
@property (strong,nonatomic)cellScrollView *rightScrollView;

@property (strong,nonatomic)UIScrollView *scrollImage;

@property (strong,nonatomic)UIPageControl *pageControl;
@property (strong,nonatomic)UILabel *label;

@property (strong,nonatomic)NSData *imageData;
@property int centralImageIndex;
@property int allImagesCount;

@end


@implementation PNImageScrollView

- (cellScrollView *)leftScrollView
{
    
    
    if (!_leftScrollView) {
        _leftScrollView = [[cellScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    //_leftScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, SCREEN_HEIGHT*2);
    return _leftScrollView;
}

- (cellScrollView *)centralScrollView
{
    if (!_centralScrollView) {
        _centralScrollView = [[cellScrollView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    //_centralScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, SCREEN_HEIGHT*2);
    return _centralScrollView;
}

- (cellScrollView *)rightScrollView
{
    if (!_rightScrollView) {
        _rightScrollView = [[cellScrollView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    //_rightScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, SCREEN_HEIGHT*2);
    return _rightScrollView;
}

#pragma mark scrollView Setting
-(UIScrollView *)scrollImage
{
    if (!_scrollImage) {
        _scrollImage=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _scrollImage.contentSize = CGSizeMake(SCREEN_WIDTH*IMAGEVIEW_COUNT, SCREEN_HEIGHT);
        //CGSize contentSize = _scrollImage.contentSize;
        //NSLog(@"width=%f,height=%f",contentSize.width,contentSize.height);
        //去除弹簧效果
        _scrollImage.bounces = NO;
        //设置偏移到中间的图片
        [_scrollImage setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
        //设置分页
        _scrollImage.pagingEnabled = YES;
        //去掉滚动条
        _scrollImage.showsHorizontalScrollIndicator = NO;
        _scrollImage.delegate = self;
        _scrollImage.zoomScale = 1;
    }
    
    return _scrollImage;
}

-(void)checkNumberOfImages
{
    self.allImagesCount = (int)self.showImages.count;
    NSLog(@"number of stored images: %d",_allImagesCount);
}

//添加分页控件
-(UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]init];
    }
    CGSize size = [_pageControl sizeForNumberOfPages:self.allImagesCount];
    _pageControl.bounds = CGRectMake(0, 0, size.width, size.height);
    _pageControl.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-10);
    //设置颜色
    _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:193/255.0 green:219/255.0 blue:219/255.0 alpha:1];
    //设置当前页的颜色
    _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0 green:150/255.0 blue:1 alpha:1];
    //设置总页数
    _pageControl.numberOfPages = self.allImagesCount;
    //设置点击
    [_pageControl addTarget:self action:@selector(tapPageControl:) forControlEvents:UIControlEventValueChanged];
    return _pageControl;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    //重新加载图片
    [self reloadImages];
    //设置分页
    self.pageControl.currentPage = self.centralImageIndex;
    //移到中间位置
    [self.scrollImage setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
    //设置表述
    NSString *imageName = [NSString stringWithFormat:@"Image_%d",_centralImageIndex+1];
    self.label.text = imageName;
}

-(void)tapPageControl:(UIPageControl *)page
{
    NSLog(@"%f",self.scrollImage.contentOffset.x);
    if (self.centralImageIndex < page.currentPage) {
        [self.scrollImage setContentOffset:CGPointMake(SCREEN_WIDTH*2, 0) animated:YES];
    }
    if (self.centralImageIndex > page.currentPage) {
        [self.scrollImage setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}


//设置表述table
-(UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    }
    _label.textAlignment = NSTextAlignmentCenter;
    _label.textColor = [UIColor whiteColor];
    return _label;
}

- (UIImage *)readImage:(int)imageIndex
{
    if ((_allImagesCount<2) && (imageIndex == 1)) {
        return nil;
    }
   else
   {
       UIImage *image = self.showImages[imageIndex];
       return image;

   }
}



- (void)setDefaultImages
{
    self.leftScrollView.imageView.image = [self readImage:_allImagesCount-1];
    self.centralScrollView.imageView.image = [self readImage:0];
    self.rightScrollView.imageView.image = [self readImage:1];
    
    self.centralImageIndex = 0;
    self.pageControl.currentPage = _centralImageIndex;
    NSString *imageName = [NSString stringWithFormat:@"Image_%d",_centralImageIndex+1];
    self.label.text = imageName;
}



//滚动停止事件
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //重新加载图片
    [self reloadImages];
    //移到中间位置
    [self.scrollImage setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
    //设置分页
    self.pageControl.currentPage = self.centralImageIndex;
    //设置表述
    NSString *imageName = [NSString stringWithFormat:@"Image_%d",_centralImageIndex+1];
    self.label.text = imageName;
    
    
}

//重新加载图片
-(void)reloadImages
{
    int leftImageIndex,rightImageIndex;
    CGPoint offset = [_scrollImage contentOffset];
    //向右滑动
    if (offset.x>=SCREEN_WIDTH+SCREEN_WIDTH_HALF) {
        self.centralImageIndex = (_centralImageIndex+1)%_allImagesCount;
    }
    else   //向左滑动
        if (offset.x<=SCREEN_WIDTH-SCREEN_WIDTH_HALF) {
            self.centralImageIndex = (_centralImageIndex + _allImagesCount-1)%_allImagesCount;
        }
    
    if ((offset.x>SCREEN_WIDTH+SCREEN_WIDTH_HALF) ||(offset.x<SCREEN_WIDTH-SCREEN_WIDTH_HALF)) {
        leftImageIndex = (_centralImageIndex + _allImagesCount-1)%_allImagesCount;
        rightImageIndex = (_centralImageIndex+1)%_allImagesCount;
        self.leftScrollView.imageView.image = [self readImage:leftImageIndex];
        self.centralScrollView.imageView.image = [self readImage:_centralImageIndex];
        self.rightScrollView.imageView.image = [self readImage:rightImageIndex];
        
        
        [self.centralScrollView setZoomScale:1.0 animated:YES];
    }
    //重置左右imageView中的图片
}


-(void)initImageScrollView
{
    [self checkNumberOfImages];
    [self addSubview:self.scrollImage];
    [self addSubview:self.pageControl];
    [self addSubview:self.label];
    [self.scrollImage addSubview:self.leftScrollView];
    [self.scrollImage addSubview:self.centralScrollView];
    [self.scrollImage addSubview:self.rightScrollView];
    [self setDefaultImages];
    
    self.scrollImage.backgroundColor = [UIColor grayColor];
}

@end
