//
//  PNImages.h
//  photoNote
//
//  Created by yuyaolong on 15/4/28.
//  Copyright (c) 2015年 yuyaolong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PNItem;

@interface PNImages : NSManagedObject

@property (nonatomic, retain) NSString * imagePath;
@property (nonatomic, retain) NSString * imageMemo;
@property (nonatomic, retain) PNItem *imageItem;

@end
