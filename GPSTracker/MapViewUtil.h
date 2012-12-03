//
//  MapViewUtil.h
//  iPinner
//
//  Created by navy on 11-9-23.
//  Copyright 2011 freelancer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MKMapView (MapViewUtil)

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;

@end 
