//
//  PNItemViewController.h
//  photoNote
//
//  Created by yuyaolong on 15/5/3.
//  Copyright (c) 2015年 yuyaolong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNItem.h"

@protocol PNItemViewControllerDelegate <NSObject>

-(void)homeTableNeedReload;

@end


@interface PNItemViewController : UIViewController

@property(nonatomic,strong)NSArray *showImages;
@property(nonatomic,strong)PNItem *showItem;

@property(nonatomic,weak)id<PNItemViewControllerDelegate> delegate;

@end
