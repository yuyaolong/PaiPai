//
//  PNItemService.m
//  photoNote
//
//  Created by yuyaolong on 15/4/28.
//  Copyright (c) 2015年 yuyaolong. All rights reserved.
//

#import "PNItemService.h"
#import "PNSingleton.h"
#import "PNDbManager.h"

@implementation PNItemService
singleton_implementation(PNItemService)

-(NSManagedObjectContext *)context
{
    return [PNDbManager sharedPNDbManager].context;
}

-(NSArray *)getAllItemsSortedByCreatedTime
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"PNItem"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"dateCreated" ascending:NO]];
    NSError *error;
    NSArray *result = [self.context executeFetchRequest:request error:&error];
    
    if (!result) {
         NSLog(@"获取全部PNItem发生错误,错误信息：%@！",error.localizedDescription);
    }
    return result;
}


-(NSArray *)getAllItemsSortedByCourseName
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"PNItem"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"courseName" ascending:YES]];
    NSError *error;
    NSArray *result = [self.context executeFetchRequest:request error:&error];
    
    if (!result) {
        NSLog(@"获取全部PNItem发生错误,错误信息：%@！",error.localizedDescription);
    }
    return result;
}

-(NSArray *)getItemsByCousrseName:(NSString *)courseName
{
    //实例化查询
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"PNItem"];
    //使用谓词查询是基于Keypath查询的，如果键是一个变量，格式化字符串时需要使用%K而不是%@
    request.predicate=[NSPredicate predicateWithFormat:@"%K=%@",@"courseName",courseName];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"dateCreated" ascending:NO]];
    //    request.predicate=[NSPredicate predicateWithFormat:@"name=%@",name];
    NSError *error;
    //进行查询
    NSArray *results=[self.context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"查询PNItem过程中发生错误，错误信息：%@！",error.localizedDescription);
    }
    return results;
}

-(NSArray *)getItemsBySearchWords:(NSString *)searchWords WithSearchLevel:(NSUInteger)searchLevel
{
    //实例化查询
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"PNItem"];
    //使用谓词查询是基于Keypath查询的，如果键是一个变量，格式化字符串时需要使用%K而不是%@
    switch (searchLevel) {
        case 1:
            request.predicate=[NSPredicate predicateWithFormat:@"%K contains[cd] %@",@"memo",searchWords];
            break;
        case 2:
            request.predicate=[NSPredicate predicateWithFormat:@"%K contains[cd] %@",@"courseName",searchWords];
            break;
        case 3:
            request.predicate=[NSPredicate predicateWithFormat:@"%K contains[cd] %@",@"tag",searchWords];
            break;
        default:
            request.predicate=[NSPredicate predicateWithFormat:@"memo LIKE '*%@*'",searchWords];
            break;
    }
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"dateCreated" ascending:NO]];
    NSError *error;
    //进行查询
    NSArray *results=[self.context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"查询PNItem过程中发生错误，错误信息：%@！",error.localizedDescription);
    }
    return results;
}


-(PNItem *)getItemByitemKey:(NSString *)itemKey
{
    //实例化查询
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"PNItem"];
    //使用谓词查询是基于Keypath查询的，如果键是一个变量，格式化字符串时需要使用%K而不是%@
    request.predicate=[NSPredicate predicateWithFormat:@"%K=%@",@"itemKey",itemKey];
    //    request.predicate=[NSPredicate predicateWithFormat:@"name=%@",name];
    NSError *error;
   PNItem *item;
    //进行查询
    NSArray *results=[self.context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"查询PNItem过程中发生错误，错误信息：%@！",error.localizedDescription);
    }else{
        item=[results firstObject];
    }
    return item;
}


-(void)addItem:(PNItem *)item
{
    [self addItemWithItemKey:item.itemKey courseName:item.courseName memo:item.memo tag:item.tag dateCreated:item.dateCreated dateReminder:item.dateReminder];
}


-(PNItem *)addItemWithItemKey:(NSString *)itemKey courseName:(NSString *)courseName memo:(NSString *)memo tag:(NSString *)tag dateCreated:(NSDate *)dateCreated dateReminder:(NSDate *)dateReminder
{
    //保证一个key只能存一条
    if([self getItemByitemKey:itemKey] == nil)
    {
        PNItem *item = [NSEntityDescription insertNewObjectForEntityForName:@"PNItem" inManagedObjectContext:self.context];
        item.itemKey = itemKey;
        item.courseName = courseName;
        item.memo = memo;
        item.tag = tag;
        item.dateCreated = dateCreated;
        item.dateReminder = dateReminder;
        NSError *error;
        //保存上下文
        if (![self.context save:&error]) {
            NSLog(@"添加笔记过程中发生错误,错误信息：%@！",error.localizedDescription);
            return nil;
        }
        else
        {
            NSLog(@"成功存入一条Item");
        }
        return item;
    }
    else
    {
        NSLog(@"存储的PNItem的key已在数据库中");
        return nil;
    }
    
}

-(void)removeItem:(PNItem *)item
{
    [self.context deleteObject:item];
    NSLog(@"删除一条笔记，key：%@",item.itemKey);
    NSError *error;
    if (![self.context save:&error]) {
        NSLog(@"删除笔记过程中发生错误，错误信息：%@!",error.localizedDescription);
    }
}
-(void)removeItemWithKey:(NSString *)itemKey
{
    PNItem *item = [self getItemByitemKey:itemKey];
    if (item != nil) {
        [self removeItem:item];
    }
    
}

-(void)modifyItem:(PNItem *)item
{
    [self modifyItemByItemKey:item.itemKey WithCourseName:item.courseName memo:item.memo tag:item.tag dateCreated:item.dateCreated dateReminder:item.dateReminder];
}

-(void)modifyItemByItemKey:(NSString *)itemKey WithCourseName:(NSString *)courseName memo:(NSString *)memo tag:(NSString *)tag dateCreated:(NSDate *)dateCreated dateReminder:(NSDate *)dateReminder
{
    PNItem *item = [self getItemByitemKey:itemKey];
    if (item !=nil) {
        item.courseName = courseName;
        item.memo = memo;
        item.tag = tag;
        item.dateCreated = dateCreated;
        item.dateReminder = dateReminder;
        
        NSError *error;
        if (![self.context save:&error]) {
            NSLog(@"修改笔记过程中发生错误,错误信息：%@",error.localizedDescription);
        }
    }
    else
    {
        NSLog(@"修改笔记发现笔记不存在");
    }


}


@end
