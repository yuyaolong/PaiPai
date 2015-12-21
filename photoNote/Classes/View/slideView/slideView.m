//
//  slideView.m
//  photoNote
//
//  Created by yuyaolong on 15/5/13.
//  Copyright (c) 2015年 yuyaolong. All rights reserved.
//

#import "slideView.h"
#import "PNTools.h"

@interface slideView()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *slideTable;
@property(nonatomic,strong)NSArray *allItemsSplitedBycoursName;
@property (weak, nonatomic) IBOutlet UIButton *AllNotesBtn;
@property (weak, nonatomic) IBOutlet UISearchBar *slideSearchBar;


@property (nonatomic)NSUInteger searchLevel;
@end


@implementation slideView

-(void)awakeFromNib
{
    self.searchLevel = 1;
    self.slideTable.dataSource = self;
    self.slideTable.delegate = self;
    self.slideSearchBar.delegate = self;
    [self refreshSlideTable];
    for (NSArray *itemsArray in self.allItemsSplitedBycoursName) {
        NSLog(@"%ld\n", itemsArray.count);
    }
}

- (IBAction)backToTimeLine:(UIButton *)sender {
    [self.delegate showSelectedItemsInHomeTableByCourseName:@"TimeLine"];
}
- (IBAction)changeSearchLevel:(UISegmentedControl *)sender {
    self.searchLevel = sender.selectedSegmentIndex+1;
}

#pragma mark - UISearchBarDelegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"%@",self.slideSearchBar.text);
    [self.slideSearchBar resignFirstResponder];
    [self.delegate showSelectedItemsInHomeTableBySearchWords:self.slideSearchBar.text withSearchLevel:self.searchLevel];
}

/**
 *  刷新整个数据和视图
 */
-(void)refreshSlideTable
{
    self.allItemsSplitedBycoursName = [PNTools getAllItemsSplitedByCourseNameToMultiArray];
    [self.slideTable reloadData];
}



#pragma mark - UITableViewDataSource
//required
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allItemsSplitedBycoursName.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //0.可重用标识符字符串
    //static静态变量，能够保证系统为变量的内存中只分配一次的内存空间，因为这个方法频繁调用
    static NSString *ID = @"Cell";
    
    //1.缓存池去查找可以重用的单元格
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    //2.如果没有找到
    if (cell == nil) {
        //实例化新的单元格
        NSLog(@"slideTabel实例化cell");
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        //右侧提示剪头
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = [[self.allItemsSplitedBycoursName[indexPath.row] firstObject] courseName];
    NSArray *itemsArray = self.allItemsSplitedBycoursName[indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Total Items: %ld", itemsArray.count];
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *courseName = [[self.allItemsSplitedBycoursName[indexPath.row] firstObject] courseName];
    [self.delegate showSelectedItemsInHomeTableByCourseName:courseName];
    if ([self.slideSearchBar isFirstResponder]) {
        [self.slideSearchBar resignFirstResponder];
    }
}

@end
