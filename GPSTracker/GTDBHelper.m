//
//  GTDBHelper.m
//  GPSTracker
//
//  Created by  on 12-7-14.
//  Copyright (c) 2012年 freelancer. All rights reserved.
//

#import "GTDBHelper.h"

#define DATABASE_FILE_NAME			@"tracker.db"

static GTDBHelper *helper = nil;

@implementation GTDBHelper

+(GTDBHelper *)defaultHelper
{
	if (!helper) {
		helper = [[GTDBHelper alloc] init];
	}
	return helper;
}

+(void)destroyHelper
{
	if (helper) {
		[helper release];
		helper = nil;
	}
}

- (id) init
{
	self = [super init];
	if (self) {
		database = nil;
	}
	return self;
}

- (FMDatabase *) database
{
	if( !database )
	{
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
		NSString * filePath = [NSString stringWithFormat:@"%@/%@", basePath, DATABASE_FILE_NAME];
        
		database = [[FMDatabase alloc] initWithPath:filePath];
		if( ![database open] )
		{
			[database release];
			database = nil;
		}
		[database setShouldCacheStatements:YES];
		[database setBusyRetryTimeout:120];
		[database setLogsErrors:YES];
	}
	
	return database;
}

- (int) createCommonDBTables
{
	FMDatabase *db = nil;
	NSString * sqlFile = [[NSBundle mainBundle] pathForResource:@"tracks" ofType:@"sql"];
    NSString * sql2File = [[NSBundle mainBundle] pathForResource:@"trackdetails" ofType:@"sql"];

	if( nil != sqlFile || nil != sql2File ) 
	{
		NSString * sqlString = [NSString stringWithContentsOfFile:sqlFile encoding:NSUTF8StringEncoding error:NULL];
        NSString * sql2String = [NSString stringWithContentsOfFile:sql2File encoding:NSUTF8StringEncoding error:NULL];

		db = [self database];
		[db beginTransaction];
		BOOL bSuccess = [db executeUpdate:sqlString];
        bSuccess = [db executeUpdate:sql2String];
		[db commit];
		if( !bSuccess )
		{
			NSLog( @" EXECUTE SQL ERROR  \n" );
		}
		
		return bSuccess;
	}
	
	return 0;
}

- (void) dealloc
{
	if( database )
	{
		[database close];
		[database release];
	}
	[super dealloc];
}

@end
