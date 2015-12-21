//
//  PNTools.m
//  photoNote
//
//  Created by yuyaolong on 15/4/29.
//  Copyright (c) 2015年 yuyaolong. All rights reserved.
//

#import "PNTools.h"
#define timeLineSecetionNumer 3
@implementation PNTools
singleton_implementation(PNTools)

//通过URL反取原始照片
+(NSArray *)getImagesThroughURLs:(NSArray *)imagesURLs
{
    
    NSMutableArray *array = [NSMutableArray array];
    ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    dispatch_queue_t queue = dispatch_queue_create("getImagesThroughURLs", DISPATCH_QUEUE_SERIAL);
    //利用GCD实现
    for (NSURL *url in imagesURLs) {
            dispatch_async(queue, ^{
                [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset)  {
                    UIImage *image=[UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage];
                    [array addObject:image];
                    dispatch_semaphore_signal(sema);
                    
                    }
                    failureBlock:^(NSError *error) {
                    dispatch_semaphore_signal(sema);
                    NSLog(@"error=%@",error);
                    }
                ];
            });
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    
    return [array copy];
}


+(NSString *)getUUID
{
    // Create an NSUUID object - and get its string representation
    NSUUID *uuid = [[NSUUID alloc] init];
    NSString *str = [uuid UUIDString];
    return str;
}


+(UIImage *)getFirstImageByItem:(PNItem *)item
{
    PNImageFileService *imageFileService = [PNImageFileService sharedPNImageFileService];
    PNImagesService *imageService = [PNImagesService sharedPNImagesService];
    NSString *imagePath = [[[imageService getImagesByItem:item] firstObject] imagePath];
    NSLog(@"%@",imagePath);
    UIImage *image = [imageFileService readImageFromFileByPath:imagePath];
    return image;
}

+(NSArray *)getAllImagesForOneItem:(PNItem *)item
{
    PNImageFileService *imageFileService = [PNImageFileService sharedPNImageFileService];
    PNImagesService *imageService = [PNImagesService sharedPNImagesService];
    NSArray *pnimages = [imageService getImagesByItem:item];
    NSMutableArray *images = [NSMutableArray array];
    for (PNImages *pnimage in pnimages) {
        NSString *imagePath = pnimage.imagePath;
        [images addObject:[imageFileService readImageFromFileByPath:imagePath]];
    }
    return [images copy];
}

+(void)creatWholeIteamNowWithUUID:(NSString *)uuid CourseName:(NSString *)courseName memo:(NSString *)memo tag:(NSString *)tag dateReminder:(NSDate *)dateReminder WithImages:(NSArray *)images iamgesMemos:(NSArray *)imageMemos
{
    PNItemService *itemService = [PNItemService sharedPNItemService];
    PNImagesService *imagesService = [PNImagesService sharedPNImagesService];
    PNImageFileService *imageFileService = [PNImageFileService sharedPNImageFileService];
    PNItem *item = [itemService addItemWithItemKey:uuid courseName:courseName memo:memo tag:tag dateCreated:[NSDate date] dateReminder:dateReminder];
    NSLog(@"reminder%@",dateReminder);
    if (dateReminder != nil) {
        [PNTools creatLocalNotificationWithFireDate: item];//设置闹钟
    }
    
    
    for (int i=0; i<images.count; i++) {
        NSDateFormatter *form = [[NSDateFormatter alloc] init];
        form.dateFormat = @"yy-MM-dd";
        NSString *dateStr = [form stringFromDate:[NSDate date]];
        NSString *imagePath = [NSString stringWithFormat:@"%@_%@_%d",item.itemKey,dateStr,i];
        NSLog(@"%@",imagePath);
        
        [imagesService addImagesWithItem:item imagePath:imagePath imageMemo:imageMemos[i]];
        [imageFileService saveImageToFileByPath:imagePath withImage:images[i]];
    }
}

+(void)creatLocalNotificationWithFireDate:(PNItem *)item
{
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    if (notification != nil) {
        notification.fireDate = item.dateReminder;
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.soundName = @"default";
        notification.alertBody = [NSString stringWithFormat:@"快去👀你的%@笔记吧",item.courseName];
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}


+(void)deleteWhoItem:(PNItem *)item WithSoundFileOrNot:(BOOL)isDeleteSoundFile
{
    PNItemService *itemService = [PNItemService sharedPNItemService];
    PNImagesService *imageService = [PNImagesService sharedPNImagesService];
    PNImageFileService *imageFileService = [PNImageFileService sharedPNImageFileService];
    NSArray *imageRecords = [item.images allObjects];
    for (PNImages *imageRecord in imageRecords) {
        [imageFileService removeImageFileByPath:imageRecord.imagePath];
        [imageService removeImages:imageRecord];
    }
    
    NSString *soundFilePath = [PNTools getItemSoundFilePathByUUID:item.itemKey];
    if (isDeleteSoundFile) {
        if ([PNTools checkSoundFileIsExist:soundFilePath]) {
            [PNTools deleteSoundFileByPath:soundFilePath];
        }
    }
    [itemService removeItem:item];
}

+(NSString *)getItemSoundFilePathByUUID:(NSString *)uuid
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"/soundFiles/%@.caf", uuid]];
    return path;
}

+(BOOL)checkSoundFileIsExist:(NSString *)soundFilePath
{
    BOOL isThere = [[NSFileManager defaultManager] fileExistsAtPath:soundFilePath];
    if (isThere) {
        return YES;
    }
    else
    {
        NSLog(@"不存在音频文件");
        return NO;
    }
}


+(void)deleteSoundFileByPath:(NSString *)soundFilePath
{
    if ([PNTools checkSoundFileIsExist:soundFilePath]) {
        BOOL isDeleSoundFile = [[NSFileManager defaultManager] removeItemAtPath:soundFilePath error:nil];
        if (isDeleSoundFile) {
            NSLog(@"成功删除声音文件");
        }
    }
}




+(NSArray *)getAllItemsSplitedByCourseNameToMultiArray
{
    NSMutableArray *allItemsArrary = [NSMutableArray array];
    NSMutableArray *courseKindsArray = [NSMutableArray array];
    NSArray *allItems = [[PNItemService sharedPNItemService] getAllItemsSortedByCourseName];
    NSString *coursName;
    for (PNItem *item in allItems) {
        if (![item.courseName isEqualToString:coursName]) {
            [courseKindsArray addObject:item.courseName];
            coursName = item.courseName;
        }
    }
    for (NSString *courseName in courseKindsArray) {
        NSArray *itemsArray = [[PNItemService sharedPNItemService] getItemsByCousrseName:courseName];
        [allItemsArrary addObject:itemsArray];
    }
    return [allItemsArrary copy];
}


//**************************************************************************************************************//
-(NSDate *)stringTodate:(NSString *)string withFormString: (NSString *)formStr
{
    NSDateFormatter *form = [[NSDateFormatter alloc] init];
    form.dateFormat = formStr;
    NSDate *date = [form dateFromString:string];
    return date;
}


-(NSString *)dateTostring:(NSDate *)date withFormString: (NSString *)formStr
{
    NSDateFormatter *form = [[NSDateFormatter alloc] init];
    form.dateFormat = formStr;
    NSString *str = [form stringFromDate:date];
    //NSLog(@"%@",str);
    return str;
}


-(NSArray *)getAllItemsDataInThreeArraysSortedByCreatedTime
{
    NSMutableArray *todayItems = [NSMutableArray array];
    NSMutableArray *yesterdyItems = [NSMutableArray array];
    NSMutableArray *pastItems = [NSMutableArray array];
    
    NSString *todayStr = [self dateTostring:[NSDate date] withFormString:@"yy-MM-dd"];
    NSString *yesterdayStr = [self dateTostring:[NSDate dateWithTimeIntervalSinceNow:-24*3600] withFormString:@"yy-MM-dd"];
    
    PNItemService *itemService = [PNItemService sharedPNItemService];
    NSArray *allItems = [itemService getAllItemsSortedByCreatedTime];
    for (PNItem *item in allItems) {
        if ([[self dateTostring:item.dateCreated withFormString:@"yy-MM-dd"] isEqualToString:todayStr] ) {
            [todayItems addObject:item];
        }else
            if([[self dateTostring:item.dateCreated withFormString:@"yy-MM-dd"] isEqualToString:yesterdayStr])
            {
                [yesterdyItems addObject:item];
            }else
            {
                [pastItems addObject:item];
            }
    }
    return  [NSArray arrayWithObjects:todayItems,yesterdyItems,pastItems, nil];
}


-(NSArray *)getOneCourseItemsDataInThreeArraysSortedByCreatedTimeWithCourse:(NSString *)courseName
{
    NSMutableArray *todayItems = [NSMutableArray array];
    NSMutableArray *yesterdyItems = [NSMutableArray array];
    NSMutableArray *pastItems = [NSMutableArray array];
    
    NSString *todayStr = [self dateTostring:[NSDate date] withFormString:@"yy-MM-dd"];
    NSString *yesterdayStr = [self dateTostring:[NSDate dateWithTimeIntervalSinceNow:-24*3600] withFormString:@"yy-MM-dd"];
    
    PNItemService *itemService = [PNItemService sharedPNItemService];
    NSArray *allItems = [itemService getItemsByCousrseName:courseName];
    for (PNItem *item in allItems) {
        if ([[self dateTostring:item.dateCreated withFormString:@"yy-MM-dd"] isEqualToString:todayStr] ) {
            [todayItems addObject:item];
        }else
            if([[self dateTostring:item.dateCreated withFormString:@"yy-MM-dd"] isEqualToString:yesterdayStr])
            {
                [yesterdyItems addObject:item];
            }else
            {
                [pastItems addObject:item];
            }
    }
    return  [NSArray arrayWithObjects:todayItems,yesterdyItems,pastItems, nil];
}


-(NSArray *)getSearchItemsDataInThreeArraysSortedByCreatedTimeWithSearchWord:(NSString *)searchWords SearchLevel:(NSUInteger)searchLevel
{
    NSMutableArray *todayItems = [NSMutableArray array];
    NSMutableArray *yesterdyItems = [NSMutableArray array];
    NSMutableArray *pastItems = [NSMutableArray array];
    
    NSString *todayStr = [self dateTostring:[NSDate date] withFormString:@"yy-MM-dd"];
    NSString *yesterdayStr = [self dateTostring:[NSDate dateWithTimeIntervalSinceNow:-24*3600] withFormString:@"yy-MM-dd"];
    
    PNItemService *itemService = [PNItemService sharedPNItemService];
    NSArray *allItems = [itemService getItemsBySearchWords:searchWords WithSearchLevel:searchLevel];
    for (PNItem *item in allItems) {
        if ([[self dateTostring:item.dateCreated withFormString:@"yy-MM-dd"] isEqualToString:todayStr] ) {
            [todayItems addObject:item];
        }else
            if([[self dateTostring:item.dateCreated withFormString:@"yy-MM-dd"] isEqualToString:yesterdayStr])
            {
                [yesterdyItems addObject:item];
            }else
            {
                [pastItems addObject:item];
            }
    }
    return  [NSArray arrayWithObjects:todayItems,yesterdyItems,pastItems, nil];
}

-(NSArray *)getFisrtImageByAllPNItem:(NSArray *)allItems
{
    
    NSMutableArray *todayItemsFirstImages = [NSMutableArray array];
    NSMutableArray *yesterdyItemsFirstImages = [NSMutableArray array];
    NSMutableArray *pastItemsFirstImages = [NSMutableArray array];
    NSArray *allFirstImages = [NSArray arrayWithObjects:todayItemsFirstImages, yesterdyItemsFirstImages, pastItemsFirstImages, nil];
    
    for (int i=0; i<timeLineSecetionNumer; i++) {
        for (PNItem *item in allItems[i]) {
            PNImageFileService *imageFileService = [PNImageFileService sharedPNImageFileService];
            PNImagesService *imageService = [PNImagesService sharedPNImagesService];
            NSString *imagePath = [[[imageService getImagesByItem:item] firstObject] imagePath];
            NSLog(@"%@",imagePath);
            UIImage *image = [imageFileService readImageFromFileByPath:imagePath];
            
            [allFirstImages[i] addObject:image];
        }
    }
    return allFirstImages;
}

@end
