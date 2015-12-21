//
//  ViewController.m
//  photoNote
//
//  Created by yuyaolong on 15/4/28.
//  Copyright (c) 2015年 yuyaolong. All rights reserved.
//

#import "ViewController.h"
#import "PNItem.h"
#import "PNImages.h"
#import "PNItemService.h"
#import "PNImagesService.h"
#import "PNImageFileService.h"
#import "PNTools.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //PNTools *tools = [PNTools sharedPNTools];
    //[itemService addItemWithItemKey:[tools getUUID] courseName:@"math" memo:@"hello" tag:@"1" dateCreated:[NSDate date] dateReminder:nil];
    //[itemService addItemWithItemKey:[tools getUUID] courseName:@"music" memo:@"hello" tag:@"2" dateCreated:[NSDate date] dateReminder:nil];
    /*
    NSArray *array = [itemService getAllItemsSorted];
     NSLog(@"%@", [(PNItem *)array[0] tag]);
    
    UIImage *image = [UIImage imageNamed:@"test"];
    [imageFileService saveImageToFileByPath:@"test" withImage:image];
    
    UIImage *image2 = [imageFileService readImageFromFileByPath:@"test"];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, 300)];
    imageView.image = image;
    
    UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 300, 300, 300)];
    imageView2.image = image2;
    
    [self.view addSubview:imageView];
    [self.view addSubview:imageView2];
    
    //[imageFileService removeImageFileByPath:@"test"];
    
    NSLog(@"%@",[[PNTools sharedPNTools] getUUID]);
    */
    
    
    UIImage *image = [UIImage imageNamed:@"test"];
    NSString *uuid = [PNTools getUUID];
    [PNTools creatWholeIteamNowWithUUID:(NSString *)uuid CourseName:@"Math" memo:@"3张图片" tag:@"3张照片" dateReminder:nil WithImages:@[image,image,image] iamgesMemos:@[@"第一张",@"第二张",@"第三张"]];
    
    
    /*
    PNItemService *itemService = [PNItemService sharedPNItemService];
    NSArray *array = [itemService getAllItemsSortedByCourseName];
    for (PNItem *item in array) {
        NSLog(@"%@",item.courseName);
        if ([item.courseName isEqualToString:@"Apple"]) {
            
            [PNTools deleteWhoItem:item];
        }
    }
    */
    
}








@end
