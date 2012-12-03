//
//  FGSpotMapViewContoller.h
//  FreeGo
//
//  Created by navy on 12-1-3.
//  Copyright 2012 freelancer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "FGSpotAnnotation.h"

@interface FGSpotMapViewController : UIViewController<MKMapViewDelegate>  {
	MKMapView *mapView;
	NSMutableArray *mapAnnotations;
	NSMutableArray *spotArray;
	
	double		centerLat;
	double      centerLong;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) NSMutableArray *spotArray;
@property (nonatomic, retain) NSMutableArray *mapAnnotations;

- (void)addAnnotations:(NSMutableArray *)arr;

@end
