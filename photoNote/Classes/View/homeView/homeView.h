//
//  homeView.h
//  photoNote
//
//  Created by yuyaolong on 15/4/29.
//  Copyright (c) 2015年 yuyaolong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol homeViewDelegate <NSObject>

-(void)hidNavigationBar;

-(void)showNavigationBar;

-(void)tableNeedReload;

@end


@interface homeView : UIView
@property (weak,nonatomic)id<homeViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *homeTable;
@property (weak,nonatomic)UIViewController *superViewController;

@property (strong,nonatomic)NSString *showCourseName;
@property (strong,nonatomic)NSString *searchWord;
@property (nonatomic)NSUInteger searchLevel;

-(void)refreshHomeTable;
@end
