//
//  PNItem.h
//  photoNote
//
//  Created by yuyaolong on 15/4/28.
//  Copyright (c) 2015年 yuyaolong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PNImages, PNUser;

@interface PNItem : NSManagedObject

@property (nonatomic, retain) NSString * courseName;
@property (nonatomic, retain) NSString * tag;
@property (nonatomic, retain) NSString * memo;
@property (nonatomic, retain) NSString * itemKey;
@property (nonatomic, retain) NSDate * dateReminder;
@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) PNUser *itemUser;
@property (nonatomic, retain) NSSet *images;
@end

@interface PNItem (CoreDataGeneratedAccessors)

- (void)addImagesObject:(PNImages *)value;
- (void)removeImagesObject:(PNImages *)value;
- (void)addImages:(NSSet *)values;
- (void)removeImages:(NSSet *)values;

@end
