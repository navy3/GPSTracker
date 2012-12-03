//
//  GTDetailDao.h
//  GPSTracker
//
//  Created by  on 12-7-24.
//  Copyright (c) 2012年 freelancer. All rights reserved.
//

#import "GTBaseDao.h"
#import "GTTrack.h"
#import "GTTrackDetail.h"

@interface GTDetailDao : GTBaseDao

- (NSMutableArray *)selectByTrackId:(int)tid;

- (BOOL)insertByDetail:(GTTrackDetail *)detail;

- (BOOL)updateByDetail:(GTTrackDetail *)detail;

- (BOOL)deleteAt:(int)index;


@end
