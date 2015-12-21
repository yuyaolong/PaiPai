//
//  PNDbManager.m
//  photoNote
//
//  Created by yuyaolong on 15/4/28.
//  Copyright (c) 2015年 yuyaolong. All rights reserved.
//

#import "PNDbManager.h"

@implementation PNDbManager
//单例的实现宏
singleton_implementation(PNDbManager)

#pragma mark 重写初始化方法
-(instancetype)init{
    if((self=[super init]))
    {
        _context=[self createDbContext];
    }
    return self;
}

-(NSManagedObjectContext *)createDbContext{
    NSManagedObjectContext *context;
    //打开模型文件，参数为nil则打开包中所有模型文件并合并成一个
    NSManagedObjectModel *model=[NSManagedObjectModel mergedModelFromBundles:nil];
    //创建解析器
    NSPersistentStoreCoordinator *storeCoordinator=[[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model];
    //创建数据库保存路径
    NSString *dir=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSLog(@"%@",dir);
    NSString *path=[dir stringByAppendingPathComponent:@"photoNote.db"];
    NSURL *url=[NSURL fileURLWithPath:path];
    //添加SQLite持久存储到解析器
    NSError *error;
    [storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
    if(error){
        NSLog(@"数据库打开失败！错误:%@",error.localizedDescription);
    }else{
        context=[[NSManagedObjectContext alloc]init];
        context.persistentStoreCoordinator=storeCoordinator;
        NSLog(@"数据库打开成功！");
    }
    return context;
}


@end
