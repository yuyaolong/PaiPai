//
//  PNImagesService.m
//  photoNote
//
//  Created by yuyaolong on 15/4/29.
//  Copyright (c) 2015年 yuyaolong. All rights reserved.
//

#import "PNImagesService.h"
#import "PNSingleton.h"
#import "PNDbManager.h"
@implementation PNImagesService
singleton_implementation(PNImagesService)

-(NSManagedObjectContext *)context
{
    return [PNDbManager sharedPNDbManager].context;
}

-(NSArray *)getAllImages
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"PNImages"];
    NSError *error;
    //进行查询
    NSArray *results=[self.context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"查询所有PNImages中发生错误，错误信息：%@！",error.localizedDescription);
    }
    return results;

}

-(NSArray *)getImagesByItem:(PNItem *)item
{
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"PNImages"];
    request.predicate=[NSPredicate predicateWithFormat:@"%K=%@",@"imageItem",item];
    NSError *error;
    //进行查询
    NSArray *results=[self.context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"查询PNImages中发生错误，错误信息：%@！",error.localizedDescription);
    }
    return results;
}

-(PNImages *)getImageByImagePath:(NSString *)imagePath
{
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"PNImages"];
    request.predicate=[NSPredicate predicateWithFormat:@"%K=%@",@"imagePath",imagePath];
    NSError *error;
    PNImages *image;
    //进行查询
    NSArray *results=[self.context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"查询PNImage过程中发生错误，错误信息：%@！",error.localizedDescription);
    }else{
        image=[results firstObject];
    }
    return image;
}

-(void)addImages:(PNImages *)image
{
    [self addImagesWithItem:image.imageItem imagePath:image.imagePath imageMemo:image.imageMemo];
}

-(void)addImagesWithItem:(PNItem *)item imagePath:(NSString *)imagePath imageMemo:(NSString *)imageMemo
{
    if (item != nil) {
        if ([self getImageByImagePath:imagePath] == nil) {
            PNImages *image= [NSEntityDescription insertNewObjectForEntityForName:@"PNImages" inManagedObjectContext:self.context];
            image.imageItem = item;
            image.imagePath = imagePath;
            image.imageMemo = imageMemo;
            
            NSError *error;
            //保存上下文
            if (![self.context save:&error]) {
                NSLog(@"添加照片过程中发生错误,错误信息：%@！",error.localizedDescription);
            }
        }
        else
        {
            NSLog(@"存储错误: 该照片路径已经存储在数据库");
        }
    }
    else
    {
        NSLog(@"添加照片失败，请确定照片所属的笔记后再添加");
    }
}

-(void)removeImages:(PNImages *)image
{
    [self.context deleteObject:image];
    NSLog(@"删除一张照片，itemKey:%@ path:%@",image.imageItem.itemKey, image.imagePath);
    NSError *error;
    if (![self.context save:&error]) {
        NSLog(@"删除笔记过程中发生错误，错误信息：%@!",error.localizedDescription);
    }
}

-(void)removeImagesByImagePath:(NSString *)imagePath
{
    PNImages *image = [self getImageByImagePath:imagePath];
    if (image != nil) {
        [self removeImages:image];
    }
}

-(void)modifyImageByImagePath:(NSString *)imagePath WithImageMemo:(NSString *)imageMemo imageItem:(PNItem *)item
{
    PNImages *image = [self getImageByImagePath:imagePath];
    if (image != nil) {
        image.imageMemo = imageMemo;
        image.imageItem = item;
        NSError *error;
        if (![self.context save:&error]) {
            NSLog(@"修改照片的过程中发生错误,错误信息：%@",error.localizedDescription);
        }
    }
    else
    {
        NSLog(@"修改照片发现照片不存在");

    }
    
}



@end
