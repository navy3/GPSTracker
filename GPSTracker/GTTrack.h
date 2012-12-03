//
//  GTTrack.h
//  GPSTracker
//
//  Created by  on 12-7-14.
//  Copyright (c) 2012年 freelancer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTTrack : NSObject
{
    int tid;
    
    double latitude;
    double longitude;
    
    NSString *trackName;
    NSString *trackAddress;
    NSString *trackGroup;
    NSString *trackImageUrl;
    
    int trackType;
    
    NSDate *trackTime;
}

@property (nonatomic, assign) int tid;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;

@property (nonatomic, assign) int trackType;

@property (nonatomic, copy) NSString *trackName;
@property (nonatomic, copy) NSString *trackAddress;
@property (nonatomic, copy) NSString *trackGroup;
@property (nonatomic, copy) NSString *trackImageUrl;

@property (nonatomic, retain) NSDate *trackTime;

@end
