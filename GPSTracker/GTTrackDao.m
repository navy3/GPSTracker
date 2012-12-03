//
//  GTTrackDao.m
//  GPSTracker
//
//  Created by  on 12-7-15.
//  Copyright (c) 2012年 freelancer. All rights reserved.
//

#import "GTTrackDao.h"
#import "FMDatabase.h"

#define SELECT_ROSTER		@"select * from %@"
#define SELECT_By_Group		@"select * from %@ where trackgroup = ?"

#define INSERT_ROSTER       @"insert into %@ (latitude,longitude,trackName,trackAddress,trackGroup,trackType,trackTime,trackImageUrl) values(?,?,?,?,?,?,?,?)"
#define UPDATE_ROSTER		@"update %@ set latitude = ?, longitude=? ,trackName = ?,trackAddress = ? ,trackGroup = ? ,trackType = ?,trackTime = ? ,trackImageUrl = ? where tid = ?"
#define DELETE_ROSTER		@"delete from %@ where tid = ?"

@implementation GTTrackDao

-(NSString *)setTable:(NSString *)sql{
	return [NSString stringWithFormat:sql,  @"tracks"];
}

-(NSMutableArray *)select
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:0];
    FMResultSet *rs = [db executeQuery:[self setTable:SELECT_ROSTER]];
	while ([rs next]) {
		GTTrack *track = [[GTTrack alloc] init];
		track.tid = [rs intForColumn:@"tid"];
        track.latitude = [rs doubleForColumn:@"latitude"];
        track.longitude = [rs doubleForColumn:@"longitude"];
        
        track.trackName = [rs stringForColumn:@"trackName"];
        track.trackAddress = [rs stringForColumn:@"trackAddress"];
        
        track.trackType = [rs intForColumn:@"trackType"];
        track.trackTime = [rs dateForColumn:@"trackTime"];
		
        track.trackGroup = [rs stringForColumn:@"trackGroup"];
        
        track.trackImageUrl = [rs stringForColumn:@"trackImageUrl"];
		[result addObject:track];
		[track release];
	}
	[rs close];
    return result;
}

- (NSMutableArray *)selectByGroup:(NSString *)group
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:0];
    FMResultSet *rs = [db executeQuery:[self setTable:SELECT_By_Group],group];
	while ([rs next]) {
		GTTrack *track = [[GTTrack alloc] init];
		track.tid = [rs intForColumn:@"tid"];
        track.latitude = [rs doubleForColumn:@"latitude"];
        track.longitude = [rs doubleForColumn:@"longitude"];
        
        track.trackName = [rs stringForColumn:@"trackName"];
        track.trackAddress = [rs stringForColumn:@"trackAddress"];
        
        track.trackType = [rs intForColumn:@"trackType"];
        track.trackTime = [rs dateForColumn:@"trackTime"];
		
        track.trackGroup = [rs stringForColumn:@"trackGroup"];
        track.trackImageUrl = [rs stringForColumn:@"trackImageUrl"];
        
		[result addObject:track];
		[track release];
	}
	[rs close];
    return result;
}

- (BOOL)insertByTrack:(GTTrack *)track
{
    BOOL success = YES;
	[db executeUpdate:[self setTable:INSERT_ROSTER], [NSNumber numberWithDouble:track.latitude], [NSNumber numberWithDouble:track.longitude],track.trackName,track.trackAddress,track.trackGroup,[NSNumber numberWithInt:track.trackType],track.trackTime,track.trackImageUrl];
    NSLog(@"%s %@",__func__,track.trackImageUrl);
	if ([db hadError]) {
		NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
		success = NO;
	}
	return success;
}

- (BOOL)updateByTrack:(GTTrack *)track
{
    BOOL success = YES;
	[db executeUpdate:[self setTable:UPDATE_ROSTER], [NSNumber numberWithDouble:track.latitude], [NSNumber numberWithDouble:track.longitude],track.trackName,track.trackAddress,track.trackGroup,[NSNumber numberWithInt:track.trackType],track.trackTime,track.trackImageUrl,[NSNumber numberWithInt: track.tid]];
	if ([db hadError]) {
		NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
		success = NO;
	}
	return success;
}

- (BOOL)deleteAt:(int)index
{
    BOOL success = YES;
	[db executeUpdate:[self setTable:DELETE_ROSTER], [NSNumber numberWithInt:index]];
	if ([db hadError]) {
		NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
		success = NO;
	}
	return success;
}

@end
