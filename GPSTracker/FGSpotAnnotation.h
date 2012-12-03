//
//  FGSpotAnnotation.h
//  FreeGo
//
//  Created by navy on 12-1-3.
//  Copyright 2012 freelancer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "GTTrack.h"

@interface FGSpotAnnotation : NSObject <MKAnnotation>
{
	GTTrack *track;
	
	CLLocationCoordinate2D coordinate;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) GTTrack *track;

- (id)initWithCoords:(CLLocationCoordinate2D)coords;

@end
