//
//  collectionPickerViewController.h
//  photoNote
//
//  Created by yuyaolong on 15/5/3.
//  Copyright (c) 2015年 yuyaolong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol collectionPickerDelegate <NSObject>

-(void)didFinishPickerFromCollectionWithSelcetedThumbImages:(NSArray *)selcetedThumbImages imagesURL:(NSArray *)imagesURL;

@end



@interface collectionPickerViewController : UIViewController

@property(nonatomic,weak)id<collectionPickerDelegate> delegate;

@end
