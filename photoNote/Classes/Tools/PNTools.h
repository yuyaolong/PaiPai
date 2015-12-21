//
//  PNTools.h
//  photoNote
//
//  Created by yuyaolong on 15/4/29.
//  Copyright (c) 2015年 yuyaolong. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "PNSingleton.h"
#import "PNItemService.h"
#import "PNImageFileService.h"
#import "PNImagesService.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface PNTools : NSObject

singleton_interface(PNTools);

//通过URL反取原始照片
+(NSArray *)getImagesThroughURLs:(NSArray *)imagesURLs;

+(NSString *)getUUID;

/**
 *  根据items实时获得item的第一张图片
 *
 *  @param item
 *
 *  @return 一条item的第一张图片
 */
+(UIImage *)getFirstImageByItem:(PNItem *)item;

/**
 *  根据item实时获得item的所有图片
 *
 *  @param item
 *
 *  @return 一条item的所有图片
 */
+(NSArray *)getAllImagesForOneItem:(PNItem *)item;

/**
 *  一次存入多张照片和照片的备注
 *  images和imageMemos要保持数组同大小
 *  imagePath格式是itemKey_dateStr_count
 *  @return
 */
+(void)creatWholeIteamNowWithUUID:(NSString *)uuid CourseName:(NSString *)courseName memo:(NSString *)memo tag:(NSString *)tag dateReminder:(NSDate *)dateReminder WithImages:(NSArray *)images iamgesMemos:(NSArray *)imageMemos;



/**
 *  删除整条笔记以及关联的所有文件记录
 *
 *  @param item 
 */
+(void)deleteWhoItem:(PNItem *)item WithSoundFileOrNot:(BOOL)isDeleteSoundFile;


/**
 *  通过item的UUID来获取声音文件应该存取的位置
 *
 *  @param uuid item 的key
 *
 *  @return 声音文件的实际存储地址
 */
+(NSString *)getItemSoundFilePathByUUID:(NSString *)uuid;

/**
 *  检查沙箱内是不是有指定路径的声音文件
 *
 *  @param soundFilePath 声音文件的路径
 *
 *  @return YES or NO
 */
+(BOOL)checkSoundFileIsExist:(NSString *)soundFilePath;



/**
 *  函数内部通过先检查文件是否存在然后删除文件
 *
 *  @param soundFilePath 声音文件的路径
 */
+(void)deleteSoundFileByPath:(NSString *)soundFilePath;


/**
 *  获取所有Items根据courseName分类的二维数组，第一个下标代表那个种类的课程， 第二个下标代表每一个种类的课里的笔记 （用于侧边栏显示已有的课程分类）
 *
 *
 *
 *  @return 所有笔记的二维数组
 */
+(NSArray *)getAllItemsSplitedByCourseNameToMultiArray;






//下面是单例对象实现的方法，因为要相互调用本类中的方法

/**
 *  NSString转换成NSDate
 *
 *  @param string
 *  @param formStr
 *
 *  @return NSDate类型
 */
-(NSDate *)stringTodate:(NSString *)string withFormString: (NSString *)formStr;


/**
 *  NSDate转换成NSString
 *
 *  @param date    需要转换的NSDate
 *  @param formStr 指定输出时间字符串的格式
 *
 *  @return 时间的字符串
 */
-(NSString *)dateTostring:(NSDate *)date withFormString: (NSString *)formStr;

/**
 *  获取所有Items并按照时间顺序存入三个数组，三个数组再合成一个数组allSortedItems,二维数组的每个成员是一个PNItem
 */
-(NSArray *)getAllItemsDataInThreeArraysSortedByCreatedTime;

/**
 *  根据courseName获取所有Items并按照时间顺序存入三个数组，三个数组再合成一个数组allSortedItems,二维数组的每个成员是一个PNItem
 *
 *  @param courseName 课程的名字
 *
 *  @return 二维数组
 */
-(NSArray *)getOneCourseItemsDataInThreeArraysSortedByCreatedTimeWithCourse:(NSString *)courseName;



/**
 *   根据searchWords取所有Items并按照时间顺序存入三个数组，三个数组再合成一个数组allSortedItems,二维数组的每个成员是一个PNItem
 *
 *  @param searchWords 搜索的词语
 *  @param searchLevel 三个搜索等级1，2，3
 level 1: memo
 level 2: courseName
 level 3: tag
 *
 *  @return 二维数组
 */
-(NSArray *)getSearchItemsDataInThreeArraysSortedByCreatedTimeWithSearchWord:(NSString *)searchWords SearchLevel:(NSUInteger)searchLevel;

/**
 *  通过AllPNItems获得第一张图片作为封面二维数组
 *
 *  @param allItems
 *
 *  @return 封面图片的二维数组
 */
-(NSArray *)getFisrtImageByAllPNItem:(NSArray *)allItems;
//

@end
