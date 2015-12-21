//
//  PNItemCell.m
//  photoNote
//
//  Created by yuyaolong on 15/5/1.
//  Copyright (c) 2015年 yuyaolong. All rights reserved.
//

#import "PNItemCell.h"



@implementation PNItemCell

+(instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    //1.定义可重用标识符 在xib的属性面板下设置重用标识符
    static NSString *itemCellID = @"itemID";
    //2.查询可重用cell
    PNItemCell *iCell = [tableView dequeueReusableCellWithIdentifier:itemCellID];
    //3.如果没有可重用的cell
    if (iCell == nil) {
        iCell = [[[NSBundle mainBundle]loadNibNamed:@"PNItemCell" owner:nil options:nil] lastObject];
        NSLog(@"creat cell");
    }
    return iCell;
}

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
