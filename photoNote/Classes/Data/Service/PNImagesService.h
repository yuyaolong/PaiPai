//
//  PNImagesService.h
//  photoNote
//
//  Created by yuyaolong on 15/4/29.
//  Copyright (c) 2015年 yuyaolong. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "PNSingleton.h"
#import "PNItem.h"
#import "PNImages.h"

@interface PNImagesService : NSObject
singleton_interface(PNImagesService)

//上下文声明
@property (nonatomic,strong) NSManagedObjectContext *context;

/**
 *  获取数据库中所有照片的路径
 *
 *  @return 所有照片路径的数组
 */
-(NSArray *)getAllImages;

/**
 *  根据PNItem得到PNImages
 *
 *  @param item PNItem
 *
 *  @return 
 */
-(NSArray *)getImagesByItem:(PNItem *)item;

/**
 *  根据PNImage存储的路径来找到唯一的照片
 *
 *  @param imagePath 照片的唯一路径
 *
 *  @return PNImages
 */
-(PNImages *)getImageByImagePath:(NSString *)imagePath;

/**
 *  增加一条笔记的照片
 *  不允许没有笔记的照片存在数据库（item不能为nil）
 *  @param item      照片对应的笔记
 *  @param imagePath 照片的路径 是照片拍摄时间和所属item的UUID合成的
 *  @param imageMemo 照片的备注
 */
-(void)addImagesWithItem:(PNItem *)item imagePath:(NSString *)imagePath imageMemo:(NSString *)imageMemo;

/**
 *  在得到一条信息完整照片时添加到数据库
 *  不允许没有笔记的照片存在数据库（item不能为nil）
 *  @param image 信息完整（知道属于哪条笔记的item）
 */
-(void)addImages:(PNImages *)image;

/**
 *  删除一条信息完整的image
 *
 *  @param image 信息完整的image
 */
-(void)removeImages:(PNImages *)image;

/**
 *  根据照片的路径去删除照片
 *
 *  @param imagePath 照片的路径
 */
-(void)removeImagesByImagePath:(NSString *)imagePath;

/**
 *  根据imagePath去修改image的属性
 *
 *  @param imagePath 照片的存储路径
 *  @param imageMemo 照片的备忘录
 *  @param item      照片所属的item
 */
-(void)modifyImageByImagePath:(NSString *)imagePath WithImageMemo:(NSString *)imageMemo imageItem:(PNItem *)item;

@end
