//
//  GTTrackDetail.m
//  GPSTracker
//
//  Created by  on 12-7-14.
//  Copyright (c) 2012年 freelancer. All rights reserved.
//

#import "GTTrackDetail.h"

@implementation GTTrackDetail

@synthesize did,tid,content,contentType,addTime;

- (id)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)dealloc
{
    GT_RELEASE(content);
    GT_RELEASE(addTime);
    [super dealloc];
}
@end
