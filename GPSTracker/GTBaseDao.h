//
//  GTBaseDao.h
//  GPSTracker
//
//  Created by  on 12-7-15.
//  Copyright (c) 2012年 freelancer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMDatabase;

@interface GTBaseDao : NSObject
{
    FMDatabase *db;
}

@property (nonatomic, assign) FMDatabase *db;

-(NSString *)setTable:(NSString *)sql;

@end
