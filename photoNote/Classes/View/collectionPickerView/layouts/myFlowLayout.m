//
//  myFlowLayout.m
//  cameraDemo
//
//  Created by yuyaolong on 15/3/29.
//  Copyright (c) 2015年 yuyaolong. All rights reserved.
//

#import "myFlowLayout.h"
static const CGFloat ItemWH = 100;

@implementation myFlowLayout

//只要显示边界改变就重新布局:内部会重新调用layoutAttributesForElementsInRect方法获得所有cell的布局属性以及prepareLayout
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}


//准备布局，一些初始化工作最好在这里实现
- (void)prepareLayout
{
    [super prepareLayout];
    //初始化
    //每个cell的尺寸
    self.itemSize = CGSizeMake(ItemWH, ItemWH);
    //设置左右缩进
    //CGFloat inset = (self.collectionView.frame.size.width - ItemWH)*0.5;
    //self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
    //设置水平滚动
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置cell之间的间距
    self.minimumLineSpacing = ItemWH*0.5;
    self.minimumInteritemSpacing = ItemWH*0.3;
    
    //每个cell都有自己的UICollectionViewLayoutAttributes
    //每一个indexPath都有自己的UICollectionViewLayoutAttributes
    
}

/*
//这里包括了item,head,foot的设置
-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    //1.取出默认的cell的UICollectionViewLayoutAttributes
    NSArray *arry =  [super layoutAttributesForElementsInRect:rect];
    //2.遍历所有的布局属性 进行放大缩小
    for (UICollectionViewLayoutAttributes *attrs in arry) {
        attrs.transform = CGAffineTransformMakeScale(2, 2);

    }
    return arry;
}*/

@end
