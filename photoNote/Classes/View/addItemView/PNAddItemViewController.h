//
//  PNAddItemViewController.h
//  photoNote
//
//  Created by yuyaolong on 15/5/3.
//  Copyright (c) 2015年 yuyaolong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PNItem;
@protocol PNAddItemViewControllerDelegate <NSObject>

-(void)tableNeedReload;

@end


@interface PNAddItemViewController : UIViewController

@property(weak,nonatomic)id<PNAddItemViewControllerDelegate> delegate;
@property(strong,nonatomic)PNItem *showItem;

-(void)prepareForEditItemDataWithItem:(PNItem *)item;

@end
