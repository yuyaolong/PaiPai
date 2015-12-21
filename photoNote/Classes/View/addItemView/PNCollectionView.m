//
//  PNCollectionView.m
//  02-自定义UICollectionView
//
//  Created by yuyaolong on 15/4/18.
//  Copyright (c) 2015年 yuyaolong. All rights reserved.
//

#import "PNCollectionView.h"
#import "imageCell.h"
#import "StackLayout.h"
#import "CircleLayout.h"
#import "LineLayout.h"

@interface PNCollectionView()<UICollectionViewDataSource,UICollectionViewDelegate>


@property(nonatomic, weak)UICollectionView *collectionView;
@property(nonatomic, strong)NSMutableArray *images;
@property BOOL isAnimation;
@end


@implementation PNCollectionView
//static只有这个文件可以访问
static NSString *const ID = @"images";

-(void)initPNCollectionViewWithImages:(NSMutableArray *)images
{
    CGRect rect = self.bounds;
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:rect collectionViewLayout:[[UICollectionViewFlowLayout alloc]init]];
    collectionView.delegate =self;
    collectionView.dataSource=self;
    [collectionView registerNib:[UINib nibWithNibName:@"imageCell" bundle:nil] forCellWithReuseIdentifier:ID];
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    self.images =images;
    self.isAnimation = NO;
}





//更换布局
-(void)changeLayout:(UICollectionViewLayout *)collectionLayout
{
    
    if (self.isAnimation == NO) {
        self.isAnimation = YES;
        [self.collectionView setCollectionViewLayout:collectionLayout animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.isAnimation = NO;
        });
        
    }
    
 
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //删除模型数据
    [self.images removeObjectAtIndex:indexPath.item];
    //刷新UI
    [collectionView deleteItemsAtIndexPaths:@[indexPath]];
    
    //通过协议通知其它控制器删除笔记
    [self.delegate removeSelectImageAtIndex:indexPath];
    
    
    
}

#pragma mark - <UICollectionViewDataSource>
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return  1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.images.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    imageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.image = self.images[indexPath.item];
    return  cell;
}



@end
