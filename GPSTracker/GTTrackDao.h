//
//  GTTrackDao.h
//  GPSTracker
//
//  Created by  on 12-7-15.
//  Copyright (c) 2012年 freelancer. All rights reserved.
//

#import "GTBaseDao.h"
#import "GTTrack.h"

@interface GTTrackDao : GTBaseDao

- (NSMutableArray *)select;
- (NSMutableArray *)selectByGroup:(NSString *)group;

- (BOOL)insertByTrack:(GTTrack *)track;

- (BOOL)updateByTrack:(GTTrack *)track;

- (BOOL)deleteAt:(int)index;

@end
