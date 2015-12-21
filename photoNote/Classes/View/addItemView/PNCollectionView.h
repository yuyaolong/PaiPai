//
//  PNCollectionView.h
//  02-自定义UICollectionView
//
//  Created by yuyaolong on 15/4/18.
//  Copyright (c) 2015年 yuyaolong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PNCollectionDelegate <NSObject>

-(void)removeSelectImageAtIndex:(NSIndexPath *)index;

@end


@interface PNCollectionView : UIView

@property(weak,nonatomic)id<PNCollectionDelegate> delegate;

-(void)initPNCollectionViewWithImages:(NSMutableArray *)images;
-(void)changeLayout:(UICollectionViewLayout *)collectionLayout;



@end
