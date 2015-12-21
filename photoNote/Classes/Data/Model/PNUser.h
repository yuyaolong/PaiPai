//
//  PNUser.h
//  photoNote
//
//  Created by yuyaolong on 15/4/28.
//  Copyright (c) 2015年 yuyaolong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PNItem;

@interface PNUser : NSManagedObject

@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSSet *items;
@end

@interface PNUser (CoreDataGeneratedAccessors)

- (void)addItemsObject:(PNItem *)value;
- (void)removeItemsObject:(PNItem *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
