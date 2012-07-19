//
//  GTHelper.h
//  GPSTracker
//
//  Created by  on 12-7-6.
//  Copyright (c) 2012年 freelancer. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kGroupKey @"kGroupKey"
#define kGroupListName @"gtgroup.plist"

@interface GTHelper : NSObject

+ (void)registerAllDefaults;

+ (void)saveGroupList:(NSArray *)arr;
+ (NSArray *)groupList;

@end
