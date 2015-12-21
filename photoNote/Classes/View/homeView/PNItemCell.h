//
//  PNItemCell.h
//  photoNote
//
//  Created by yuyaolong on 15/5/1.
//  Copyright (c) 2015年 yuyaolong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PNItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *courseLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backImage;


+(instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
@end
