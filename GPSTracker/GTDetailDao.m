//
//  GTDetailDao.m
//  GPSTracker
//
//  Created by  on 12-7-24.
//  Copyright (c) 2012年 freelancer. All rights reserved.
//

#import "GTDetailDao.h"
#import "FMDatabase.h"

#define SELECT_By_TrackId		@"select * from %@ where tid = ?"

#define INSERT_ROSTER       @"insert into %@ (tid,contentType,content,addTime) values(?,?,?,?)"
#define UPDATE_ROSTER		@"update %@ set tid = ?, contentType=? ,content = ?,addTime = ? where did = ?"
#define DELETE_ROSTER		@"delete from %@ where did = ?"

@implementation GTDetailDao

-(NSString *)setTable:(NSString *)sql{
	return [NSString stringWithFormat:sql,  @"trackdetails"];
}

- (NSMutableArray *)selectByTrackId:(int)tid
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:0];
    FMResultSet *rs = [db executeQuery:[self setTable:SELECT_By_TrackId],[NSNumber numberWithInt:tid]];
	while ([rs next]) {
		GTTrackDetail *detail = [[GTTrackDetail alloc] init];
		detail.did = [rs intForColumn:@"did"];
        detail.tid = [rs intForColumn:@"tid"];
        detail.contentType = [rs intForColumn:@"contentType"];
        
        detail.content = [rs stringForColumn:@"content"];
        detail.addTime = [rs dateForColumn:@"addTime"];
		
		[result addObject:detail];
		[detail release];
	}
	[rs close];
    return result;
}

- (BOOL)insertByDetail:(GTTrackDetail *)detail
{
    BOOL success = YES;
	[db executeUpdate:[self setTable:INSERT_ROSTER], [NSNumber numberWithInt:detail.tid], [NSNumber numberWithInt:detail.contentType],detail.content,detail.addTime];
	if ([db hadError]) {
		NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
		success = NO;
	}
	return success; 
}

- (BOOL)updateByDetail:(GTTrackDetail *)detail
{
    BOOL success = YES;
	[db executeUpdate:[self setTable:UPDATE_ROSTER], [NSNumber numberWithInt:detail.tid], [NSNumber numberWithInt:detail.contentType],detail.content,detail.addTime,[NSNumber numberWithInt: detail.did]];
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
