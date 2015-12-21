//
//  PNFootView.m
//  photoNote
//
//  Created by yuyaolong on 15/5/1.
//  Copyright (c) 2015年 yuyaolong. All rights reserved.
//

#import "PNFootView.h"
@interface PNFootView()
@property (weak, nonatomic) IBOutlet UIButton *loadButton;

@property (weak, nonatomic) IBOutlet UIView *loadView;

@end

@implementation PNFootView

+(instancetype)footView
{
    return [[[NSBundle mainBundle]loadNibNamed:@"PNFootView" owner:nil options:nil] lastObject];
}

-(void)awakeFromNib
{
    self.loadButton.hidden = NO;
    self.loadView.hidden = YES;

}

- (IBAction)loadMore:(UIButton *)sender {
    //1.设置UI
    self.loadButton.hidden = YES;
    self.loadView.hidden = NO;
    
    //2.加载数据，通过代理来加载数据，让homeVIew来实现
    if([self.delegate respondsToSelector:@selector(PNFootViewLoadMoreItemsButtonClicked:)])
    {
        [self.delegate PNFootViewLoadMoreItemsButtonClicked:self];
    }
    
    
}

-(void)endLordMore
{
    //3.加载完成
    self.loadButton.hidden = NO;
    self.loadView.hidden = YES;
}


@end
