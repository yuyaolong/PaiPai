//
//  PNItemService.h
//  photoNote
//
//  Created by yuyaolong on 15/4/28.
//  Copyright (c) 2015年 yuyaolong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PNSingleton.h"
#import "PNItem.h"

@interface PNItemService : NSObject
singleton_interface(PNItemService)

//上下文声明
@property (nonatomic,strong) NSManagedObjectContext *context;

/**
 *  按照笔记产生时间由近及远获取笔记获取全部的笔记
 *
 *  @return 全部PNItem的数组
 */
-(NSArray *)getAllItemsSortedByCreatedTime;

/**
 *  按照科目的名字字母排训获取笔记获取全部的笔记,大写首字母在前，小写首字母在后
 *
 *  @return  全部PNItem的数组
 */
-(NSArray *)getAllItemsSortedByCourseName;

/**
 *  按照学科的名字获得items，同时是按照创建的时间排序的
 *
 *
 *  @param courseName 课程的名字
 *
 *  @return 返回对应课程名字的items
 */
-(NSArray *)getItemsByCousrseName:(NSString *)courseName;


/**
 *  根据关键词查找items，关键词会搜索memo，courseName，tag，根据不同的搜索级别
 level 1: memo
 level 2: courseName
 level 3: tag
 *  @return 返回搜索结果的items
 */
-(NSArray *)getItemsBySearchWords:(NSString *)searchWords WithSearchLevel:(NSUInteger)searchLevel;

/**
 *  根据itemKey来找到所需要的item
 *
 *  @return 找到的item
 */
-(PNItem *)getItemByitemKey:(NSString *)itemKey;

/**
 *  添加完整的笔记
 *
 *  @param item PNitem 对象
 */
-(void)addItem:(PNItem *)item;


/**
 *  按照参数添加笔记
 *
 *  @param itemKey      每条笔记的UUID
 *  @param courseName   笔记的课程名字
 *  @param memo         笔记的文字内容
 *  @param tag          笔记的标签
 *  @param dateCreated  笔记的创建日期
 *  @param dateReminder 笔记设置的提醒的时间
 */
-(PNItem *)addItemWithItemKey:(NSString *)itemKey courseName:(NSString *)courseName memo:(NSString *)memo tag:(NSString *)tag dateCreated:(NSDate *)dateCreated dateReminder:(NSDate *)dateReminder;

/**
 *  删除笔记
 *
 *  @param item PNitem 对象
 */
-(void)removeItem:(PNItem *)item;

/**
 *  根据key删除笔记
 *
 *  @param itemKey string
 */
-(void)removeItemWithKey:(NSString *)itemKey;

/**
 *  修改笔记
 *
 *  @param item PNitem 对象
 */
-(void)modifyItem:(PNItem *)item;

/**
 *  按照参数修改笔记,根据itemKey来取出笔记
 *
 *  @param itemKey      每条笔记的UUID
 *  @param courseName   笔记的课程名字
 *  @param memo         笔记的文字内容
 *  @param tag          笔记的标签
 *  @param dateCreated  笔记的创建日期
 *  @param dateReminder 笔记设置的提醒的时间
 */
-(void)modifyItemByItemKey:(NSString *)itemKey WithCourseName:(NSString *)courseName memo:(NSString *)memo tag:(NSString *)tag dateCreated:(NSDate *)dateCreated dateReminder:(NSDate *)dateReminder;



@end
