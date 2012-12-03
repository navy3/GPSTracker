//
//  GTTrack.m
//  GPSTracker
//
//  Created by  on 12-7-14.
//  Copyright (c) 2012年 freelancer. All rights reserved.
//

#import "GTTrack.h"

@implementation GTTrack

@synthesize tid,latitude,longitude,trackName,trackAddress,trackGroup,trackType,trackTime,trackImageUrl;

- (id)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)dealloc
{
    GT_RELEASE(trackImageUrl);
    GT_RELEASE(trackName);
    GT_RELEASE(trackAddress);
    GT_RELEASE(trackGroup);
    GT_RELEASE(trackTime);    
    [super dealloc];
}
@end
