//
//  PNSectionHeaderView.m
//  photoNote
//
//  Created by yuyaolong on 15/5/1.
//  Copyright (c) 2015年 yuyaolong. All rights reserved.
//

#import "PNSectionHeaderView.h"

@implementation PNSectionHeaderView

+(instancetype)headViewWithTableView:(UITableView *)tableView indexPath:(NSInteger) section
{
     PNSectionHeaderView *hView = [[[NSBundle mainBundle]loadNibNamed:@"PNSectionHeaderView" owner:nil options:nil] lastObject];
    NSArray *array = @[@"今天", @"昨天", @"过去的"];
    [hView.titleLabel setText:array[section]];
    return hView;
}

@end
