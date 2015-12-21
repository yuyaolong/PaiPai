//
//  LineLayout.m
//  02-自定义UICollectionView
//
//  Created by yuyaolong on 15/3/27.
//  Copyright (c) 2015年 yuyaolong. All rights reserved.
//

#import "LineLayout.h"

static const CGFloat ItemWH = 100;

@implementation LineLayout

-(instancetype)init
{
    if (self = [super init]) {
            }
    return self;
}



//准备布局，一些初始化工作最好在这里实现
- (void)prepareLayout
{
    [super prepareLayout];
    //初始化
    //每个cell的尺寸
    self.itemSize = CGSizeMake(ItemWH, ItemWH);
    //设置左右缩进
    CGFloat inset = (self.collectionView.frame.size.width - ItemWH)*0.5;
    self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
    //设置水平滚动
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //设置cell之间的间距
    self.minimumLineSpacing = ItemWH;
    
    //每个cell都有自己的UICollectionViewLayoutAttributes
    //每一个indexPath都有自己的UICollectionViewLayoutAttributes

}

//只要显示边界改变就重新布局:内部会重新调用layoutAttributesForElementsInRect方法获得所有cell的布局属性以及prepareLayout
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

//这个函数重要重新布局就会调用,这里的rect默认就是contentSize
-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    //NSLog(@"layoutAttributesForElementsInRect");
    //0.计算可见的矩形框
    CGRect visiableRect;
    visiableRect.size = self.collectionView.frame.size;
    visiableRect.origin = self.collectionView.contentOffset;
    
    
    //1.取出默认的cell的UICollectionViewLayoutAttributes
    NSArray *arry =  [super layoutAttributesForElementsInRect:rect];
    
    //计算屏幕最中间的x值
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width*0.5;
    
    //2.遍历所有的布局属性 进行放大缩小
    for (UICollectionViewLayoutAttributes *attrs in arry) {
        //判读哪些cell是可见的，只改变那些的大小
        if (!CGRectIntersectsRect(visiableRect, attrs.frame)) {
            continue;
        }
        CGFloat itemCenterX = attrs.center.x;
        //滚动过程中每个item到中点的距离ABS(itemCenterX - centerX);
        //差距越大缩放比例越小
        
            CGFloat scale =1 + (1-ABS(itemCenterX - centerX)/(self.collectionView.frame.size.width*0.5));
            
            //attrs.transform3D = CATransform3DMakeScale(scale, scale, 1.0);
            attrs.transform = CGAffineTransformMakeScale(scale, scale);
        
    }
    return arry;
    //UICollectionViewLayoutAttributes
}


//用来设置collectionView停止滚动那一刻的可以设置位置 proposedContentOffset是传进来的当前offset，返回调整后的offset
-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    //计算屏幕contentoffset最中间的x值
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width*0.5;
    //1.计算出scrollView最后停留在contentSize内的范围，可视的范围
    CGRect lastRect;
    lastRect.origin = proposedContentOffset;
    lastRect.size = self.collectionView.frame.size;
    
    //2.取出这个范围内的所有属性
    NSArray *array = [self layoutAttributesForElementsInRect:lastRect];
    
    //3.遍历取出cell的属性
    CGFloat adjustOffset = MAXFLOAT;
    for ( UICollectionViewLayoutAttributes *attrs in array) {
        if(ABS(attrs.center.x - centerX)<ABS(adjustOffset))
        {
            adjustOffset = attrs.center.x - centerX;
        }
    }
    
    return CGPointMake(proposedContentOffset.x+adjustOffset, proposedContentOffset.y);
}



@end
