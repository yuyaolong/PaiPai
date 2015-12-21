//
//  PNDbManager.h
//  photoNote
//
//  Created by yuyaolong on 15/4/28.
//  Copyright (c) 2015年 yuyaolong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "PNSingleton.h"

@interface PNDbManager : NSObject
//单例的声明宏
singleton_interface(PNDbManager);

#pragma mark - 属性
#pragma mark 数据库引用，使用它进行数据库操作
@property (nonatomic) NSManagedObjectContext *context;


#pragma mark - 共有方法
/**
 *  打开数据库
 *
 *  @return 创建的context
 */
-(NSManagedObjectContext *)createDbContext;

@end
