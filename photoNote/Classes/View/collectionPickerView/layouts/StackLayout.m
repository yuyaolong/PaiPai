//
//  StackLayout.m
//  02-自定义UICollectionView
//
//  Created by yuyaolong on 15/3/27.
//  Copyright (c) 2015年 yuyaolong. All rights reserved.
//

#import "StackLayout.h"
#define Random0_1 (arc4random_uniform(100)/100.0)
@implementation StackLayout

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

/*
//滑动必须设置contentsize
-(CGSize)collectionViewContentSize
{
    return CGSizeMake(500, 500);
}*/


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
    NSArray *angles = @[@(0),@(-0.3),@(-0.1),@(0.25),@(0.15)];
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attrs.size = CGSizeMake(100, 100);
    attrs.center = CGPointMake((indexPath.item/5+1)*150, self.collectionView.frame.size.height*0.5);
    //zIndex越大越在上面
    attrs.zIndex = [self.collectionView numberOfItemsInSection:indexPath.section] - indexPath.item;

    attrs.transform = CGAffineTransformMakeRotation([angles[indexPath.item%5] floatValue]);
        
        //随机生成角度
        //int direction = (i%2 == 0)?-1:1;
        //attrs.transform = CGAffineTransformMakeRotation(Random0_1*M_PI_4*0.3*direction);
    
    return attrs;

}


@end
