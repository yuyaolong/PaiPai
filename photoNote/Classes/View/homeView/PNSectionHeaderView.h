//
//  PNSectionHeaderView.h
//  photoNote
//
//  Created by yuyaolong on 15/5/1.
//  Copyright (c) 2015年 yuyaolong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PNSectionHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


+(instancetype)headViewWithTableView:(UITableView *)tableView indexPath:(NSInteger )section;
@end
