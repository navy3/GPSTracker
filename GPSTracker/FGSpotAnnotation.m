//
//  FGSpotAnnotation.m
//  FreeGo
//
//  Created by navy on 12-1-3.
//  Copyright 2012 freelancer. All rights reserved.
//

#import "FGSpotAnnotation.h"


@implementation FGSpotAnnotation

@synthesize track,coordinate;

-(id)initWithCoords:(CLLocationCoordinate2D)coords{
	self = [super init];
	
	coordinate = coords;
	
	NSLog(@"%f %f ",coordinate.latitude,coordinate.longitude);
	return self;
}

- (void)setCoordinate:(CLLocationCoordinate2D)c
{
	coordinate = c;
}

//- (id)initWithSpot:(FGSpot *)fgSpot
//{
//	self = [super init];
//	if (self) {
//		self.spot = fgSpot;
//	}
//	return self;
//}

//- (CLLocationCoordinate2D)coordinate;
//{
//    CLLocationCoordinate2D theCoordinate;
//    theCoordinate.latitude = 37.810000+(arc4random()%10)/10.0;
//    theCoordinate.longitude = -122.477989-(arc4random()%10)/10.0;
//    return theCoordinate; 
//}

// required if you set the MKPinAnnotationView's "canShowCallout" property to YES
- (NSString *)title
{
    return track.trackName;
}

// optional
- (NSString *)subtitle
{
    return track.trackAddress;
}

- (void)dealloc
{
	GT_RELEASE(track);
    [super dealloc];
}

@end
