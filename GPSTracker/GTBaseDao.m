//
//  GTBaseDao.m
//  GPSTracker
//
//  Created by  on 12-7-15.
//  Copyright (c) 2012年 freelancer. All rights reserved.
//

#import "GTBaseDao.h"
#import "GTDBHelper.h"

@implementation GTBaseDao

@synthesize db;

- (id)init
{
	if (self = [super init]) {
		self.db = [[GTDBHelper defaultHelper] database];
	}
	return self;
}

-(NSString *)setTable:(NSString *)sql{
	return NULL;
}

- (void)dealloc {
	[super dealloc];
}

@end
