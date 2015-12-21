//
//  CircleLayout.m
//  02-自定义UICollectionView
//
//  Created by yuyaolong on 15/3/27.
//  Copyright (c) 2015年 yuyaolong. All rights reserved.
//

#import "CircleLayout.h"




@implementation CircleLayout


//只要显示边界改变就重新布局:内部会重新调用layoutAttributesForElementsInRect方法获得所有cell的布局属性以及prepareLayout
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

//这里包括了item,head,foot的设置
-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    //super不会不是flow是不会帮你算attributes
    //NSArray *arry = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *array = [NSMutableArray array];
    //获得总共有多少个Item数
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    
    for (int i = 0; i<count; i++) {
        [array addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]]];
        
    }
    return array;
}
//设置Item（cell）的属性,与layoutAttributesForElementsInRect必须都要实现
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger count = [self.collectionView numberOfItemsInSection:indexPath.section];
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attrs.size  = CGSizeMake(40, 40);
    CGFloat radius =  70;
    CGFloat centerX = self.collectionView.frame.size.width*0.5;
    CGFloat centerY = self.collectionView.frame.size.height*0.5;
    CGFloat itemX = centerX - radius*cos(indexPath.item*M_PI*2/count);
    CGFloat itemY = centerY - radius*sin(indexPath.item*M_PI*2/count);
    attrs.center = CGPointMake(itemX,itemY);
    //attrs.zIndex = count - indexPath.item;

    
    return attrs;
    
}


@end
