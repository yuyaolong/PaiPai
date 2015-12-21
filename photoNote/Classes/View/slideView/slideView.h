//
//  slideView.h
//  photoNote
//
//  Created by yuyaolong on 15/5/13.
//  Copyright (c) 2015年 yuyaolong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol slideViewDelegate <NSObject>
//选择了侧边栏的一个course后要在homeView显示新的items
-(void)showSelectedItemsInHomeTableByCourseName:(NSString *)courseName;
-(void)showSelectedItemsInHomeTableBySearchWords:(NSString *)searchWords withSearchLevel:(NSUInteger)searchLevel;

@end



@interface slideView : UIView
@property(weak,nonatomic)id<slideViewDelegate> delegate;

//刷新侧边栏的视图
-(void)refreshSlideTable;

@end
