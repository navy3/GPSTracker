//
//  GTTrackDetail.h
//  GPSTracker
//
//  Created by  on 12-7-14.
//  Copyright (c) 2012年 freelancer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTTrackDetail : NSObject
{
    int did;
    
    int tid;
    
    int contentType;
    
    NSString *content;
    NSDate *addTime;
    
}

@property (nonatomic, assign) int did;
@property (nonatomic, assign) int tid;

@property (nonatomic, assign) int contentType;

@property (nonatomic, copy) NSString *content;
@property (nonatomic, retain) NSDate *addTime;

@end
