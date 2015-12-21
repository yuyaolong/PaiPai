//
//  collectionPickerViewController.m
//  photoNote
//
//  Created by yuyaolong on 15/5/3.
//  Copyright (c) 2015年 yuyaolong. All rights reserved.
//

#import "collectionPickerViewController.h"
#import "imageCell.h"
#import "myFlowLayout.h"
#import <AssetsLibrary/AssetsLibrary.h>
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height


@interface collectionPickerViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property(strong,nonatomic)UICollectionView *collection;
@property(strong,nonatomic)NSMutableArray *images;
@property(strong,nonatomic)NSMutableArray *imagesURL;
@property(strong,nonatomic)NSMutableArray *selectIndexes;
@end

@implementation collectionPickerViewController
- (NSMutableArray *)imagesURL
{
    if (!_imagesURL) {
        _imagesURL = [NSMutableArray array] ;
    }
    return _imagesURL;
}
- (NSMutableArray *)images
{
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}


- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collection];
    
    [self getPictures];
    [self addToolbar];
}

-(void)addToolbar
{
    UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelChoose)];
    UIBarButtonItem *flexibleButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(selectConfirm)];
    toolbar.items = @[cancelButton,flexibleButton,saveButton];
    [self.view addSubview:toolbar];
}

-(void)cancelChoose
{
    [self dismissViewControllerAnimated:YES completion:nil];
}




-(void)selectConfirm
{
    //NSLog(@"%@",self.images);
    self.selectIndexes = [NSMutableArray arrayWithArray:[self.collection indexPathsForSelectedItems]];
    NSMutableArray *selectedImageURLs = [NSMutableArray array];
    NSMutableArray *selectedThumbImages = [NSMutableArray array];
    for (NSIndexPath *selectIndex in self.selectIndexes){
        NSURL *url=self.imagesURL[selectIndex.item];
        UIImage *image = self.images[selectIndex.item];
        [selectedImageURLs addObject:url];
        [selectedThumbImages addObject:image];
    }
    
    [self.delegate didFinishPickerFromCollectionWithSelcetedThumbImages:[selectedThumbImages copy] imagesURL:[selectedImageURLs copy]];
    
}


#pragma mark -获取图片
-(void)getPictures
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result) {
                    /*
                     NSString *urlstr=[NSString stringWithFormat:@"%@",result.defaultRepresentation.url];//图片的url
                     //ALAssetRepresentation *representation = [result defaultRepresentation];
                     //result.defaultRepresentation.fullScreenImage//图片的大图
                     result.thumbnail                            //图片的缩略图小图
                     */
                    CGImageRef imageRef = result.thumbnail;
                    UIImage *image = [UIImage imageWithCGImage:imageRef];
                    NSURL *URL = result.defaultRepresentation.url;
                    [self.images addObject:image];
                    [self.imagesURL addObject:URL];
                }
            }];
        }
        if(group == nil)
        {
            [self.collection reloadData];
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"相册访问失败 =%@", [error localizedDescription]);
        if ([error.localizedDescription rangeOfString:@"Global denied access"].location!=NSNotFound) {
            NSLog(@"无法访问相册.请在'设置->定位服务'设置为打开状态.");
        }else{
            NSLog(@"相册访问失败.");
        }
    }];
}


#pragma mark -设置collectionView
//static只有这个文件可以访问
static NSString *const ID = @"images";
-(UICollectionView *)collection
{
    if (!_collection) {
        _collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0,64, SCREEN_WIDTH, SCREEN_HEIGHT-64) collectionViewLayout:[[myFlowLayout alloc]init]];
        _collection.delegate =self;
        _collection.dataSource=self;
        //_collection.backgroundColor =[UIColor whiteColor];
        [_collection registerNib:[UINib nibWithNibName:@"imageCell" bundle:nil]forCellWithReuseIdentifier:ID];
        //多选开关
        _collection.allowsMultipleSelection = YES;
        
    }
    return _collection;
}

#pragma mark - <UICollectionViewDataSource>

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return  1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.images.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    imageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.image = self.images[indexPath.item];
    return  cell;
}


#pragma  mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"select Confirm");
    imageCell *tempCell = (imageCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [tempCell changBorderColor];
    
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Deselect Confirm");
    
    imageCell *tempCell = (imageCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [tempCell resumeBorderColor];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
