//
//  homeView.m
//  photoNote
//
//  Created by yuyaolong on 15/4/29.
//  Copyright (c) 2015年 yuyaolong. All rights reserved.
//

#import "homeView.h"
#import "PNFootView.h"
#import "PNItemCell.h"
#import "PNSectionHeaderView.h"
#import "PNTools.h"
#import "PNItemViewController.h"
#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height
#define showCellsNumberFirst 2
#define timeLineSecetionNumer 3

#define reloadTime 1
#define refreshTime 1


@interface homeView()<UITableViewDataSource,UITableViewDelegate,PNFootViewDelegat,PNItemViewControllerDelegate>

@property(nonatomic,strong)NSArray *allShowItems;//下标0是今天，1是昨天，2是以前
@property(nonatomic,strong)NSArray *allShowItemsFirstImages;//笔记的第一张图片下标0是今天，1是昨天，2是以前
@property(nonatomic,strong)UIWebView *tableHeadView;

@property BOOL isLoadMoreItems;

@end


@implementation homeView



-(void)awakeFromNib
{
    self.showCourseName = @"TimeLine";
    self.searchWord = nil;
    self.searchLevel = 1;
    self.frame = [UIScreen mainScreen].bounds;
    self.homeTable.delegate = self;
    self.homeTable.dataSource = self;
    
    self.homeTable.tableHeaderView = self.tableHeadView;
    
    PNFootView *footView = [PNFootView footView];
    footView.delegate = self;
    self.homeTable.tableFooterView = footView;
    self.isLoadMoreItems = NO;
   
    [self refreshHomeTable];
    
    
    //集成下拉刷新
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(reloadHomeTableWithDrag:) forControlEvents:UIControlEventValueChanged];
    [self.homeTable addSubview:refreshControl];
}

- (UIWebView *)tableHeadView
{
    if (!_tableHeadView) {
        _tableHeadView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 200)];
         NSData *gif = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"tableHead2" ofType:@"gif"]];
        _tableHeadView.userInteractionEnabled = NO;
        [_tableHeadView loadData:gif MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];

        
    }
    return _tableHeadView;
}

//详情页面删除数据后需要刷新
-(void)homeTableNeedReload
{
    [self.delegate tableNeedReload];
}

//下拉刷新视图
-(void)reloadHomeTableWithDrag:(UIRefreshControl *)refreshControl
{
    [self.delegate hidNavigationBar];
    [refreshControl beginRefreshing];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(refreshTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self refreshHomeTable];
        [refreshControl endRefreshing];
        [self.delegate showNavigationBar];
    });
}

/**
 *  刷新整个数据和视图
 */
-(void)refreshHomeTable
{
    if (self.searchWord != nil) {
        self.allShowItems = [[PNTools sharedPNTools] getSearchItemsDataInThreeArraysSortedByCreatedTimeWithSearchWord:self.searchWord SearchLevel:self.searchLevel];
    }
    else if ([self.showCourseName isEqualToString:@"TimeLine"]) {
        self.allShowItems = [[PNTools sharedPNTools] getAllItemsDataInThreeArraysSortedByCreatedTime];
        }
        else{
            self.allShowItems = [[PNTools sharedPNTools] getOneCourseItemsDataInThreeArraysSortedByCreatedTimeWithCourse:self.showCourseName];
        }
    self.allShowItemsFirstImages = [[PNTools sharedPNTools] getFisrtImageByAllPNItem:self.allShowItems];
    [self.homeTable reloadData];
    
}

/**
 *  实现PNFootVIew的加载更多items的方法
 *
 *  @param footView
 */
-(void)PNFootViewLoadMoreItemsButtonClicked:(PNFootView *)footView
{
    //多线程延迟执行，GCD
    //关于延时的代码统一使用这个方法,模拟网络取数据延时
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(reloadTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isLoadMoreItems = YES;
        [self.homeTable reloadData];
        for (int i=0; i<timeLineSecetionNumer; i++) {
            NSInteger number = [self.allShowItems[i] count];
            if (  number > showCellsNumberFirst) {
                NSMutableArray *indexAddArray =[NSMutableArray array];
                for (int j = showCellsNumberFirst; j<number; j++) {
                    NSIndexPath *addpath = [NSIndexPath indexPathForRow:j inSection:i];
                    [indexAddArray addObject:addpath];
                }
                
                [self.homeTable reloadRowsAtIndexPaths:[indexAddArray copy] withRowAnimation:UITableViewRowAnimationBottom];
            }
        }
        self.isLoadMoreItems = NO;
        
        //通知加载完成
        [footView endLordMore];
    });
    
    
}


#pragma mark - 数据元方法
//required
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(self.isLoadMoreItems == NO)
    {
        if ([self.allShowItems[section] count]<showCellsNumberFirst+1) {
            return [self.allShowItems[section] count];
        }
        else
        {
            return showCellsNumberFirst;
        }
    }
    else
    {
        return [self.allShowItems[section] count];
    }
    
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PNItemCell *iCell = [PNItemCell cellWithTableView:tableView indexPath:indexPath];
    PNItem *item = self.allShowItems[indexPath.section][indexPath.row];
    iCell.courseLabel.text =  item.courseName;
    iCell.detailLabel.text = item.memo;
    iCell.countLabel.text =  [NSString stringWithFormat:@"%ld",[item.images count]];
    //iCell.backImage.image = [PNTools getFirstImageByItem:item];
    iCell.backImage.image = self.allShowItemsFirstImages[indexPath.section][indexPath.row];
    return iCell;
   
}

//optional
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return timeLineSecetionNumer;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 400;
}


#pragma mark - homeTable的delegate方法
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [PNSectionHeaderView headViewWithTableView:tableView indexPath:section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80;
}


#pragma mark - 选中某一行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"select one row");
    PNItemViewController *itemVC = [[PNItemViewController alloc]init];
    itemVC.delegate = self;
    PNItem *item = self.allShowItems[indexPath.section][indexPath.row];
    NSArray *images = [PNTools getAllImagesForOneItem:item];
    [self.superViewController.navigationController pushViewController:itemVC animated:YES];
    itemVC.showImages =images;
    itemVC.showItem = item;
    
    [self.homeTable deselectRowAtIndexPath:indexPath animated:YES];
    
}





@end
