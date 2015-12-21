//
//  PNFootView.h
//  photoNote
//
//  Created by yuyaolong on 15/5/1.
//  Copyright (c) 2015年 yuyaolong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PNFootView;
@protocol PNFootViewDelegat <NSObject>
@required
-(void)PNFootViewLoadMoreItemsButtonClicked:(PNFootView *)footView;
@end

@interface PNFootView : UIView

@property(nonatomic,weak)id<PNFootViewDelegat>delegate;

+(instancetype)footView;

//加载更多结束后更新footView
-(void)endLordMore;
@end

