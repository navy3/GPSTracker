//
//  GTDBHelper.h
//  GPSTracker
//
//  Created by  on 12-7-14.
//  Copyright (c) 2012年 freelancer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface GTDBHelper : NSObject
{
    FMDatabase		 * database;
}

@property (nonatomic, retain, readonly) FMDatabase *database;

+(void)destroyHelper;
+(GTDBHelper *)defaultHelper;
- (int) createCommonDBTables;

@end
