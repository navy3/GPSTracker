//
//  FGSpotMapViewContoller.m
//  FreeGo
//
//  Created by navy on 12-1-3.
//  Copyright 2012 freelancer. All rights reserved.
//

#import "FGSpotMapViewController.h"
#import "MapViewUtil.h"

#define kBaseTag 1000

@implementation FGSpotMapViewController

@synthesize mapView, mapAnnotations,spotArray;

#pragma mark -

+ (CGFloat)annotationPadding;
{
    return 10.0f;
}
+ (CGFloat)calloutHeight;
{
    return 40.0f;
}

- (void)gotoLocation
{
    // start off by default in San Francisco
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = 37.786996;
    newRegion.center.longitude = -122.440100;
    newRegion.span.latitudeDelta = 1.112872;
    newRegion.span.longitudeDelta = 1.109863;
	
    [self.mapView setRegion:newRegion animated:YES];
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title =NSLocalizedString(@"GT_Detail_Map", );
	
	centerLat = 0;
	centerLong = 0;
	
	self.mapView.mapType = MKMapTypeStandard;   // also MKMapTypeSatellite or MKMapTypeHybrid
    
    // create out annotations array (in this example only 2)
    self.mapAnnotations = [[NSMutableArray alloc] initWithCapacity:0];

	//[self gotoLocation];    // finally goto San Francisco
	
}

- (void)addAnnotations:(NSMutableArray *)arr
{
	self.spotArray = arr;
	
	for (int i = 0 ; i < [spotArray count]; i++) {
        GTTrack *track = [spotArray objectAtIndex:i];
		FGSpotAnnotation *annotation = [[FGSpotAnnotation alloc] initWithCoords:CLLocationCoordinate2DMake( track.latitude, track.longitude)];
		annotation.track = track;
		centerLat += track.latitude;
		centerLong += track.longitude;
		[mapAnnotations addObject:annotation];
		[annotation release];
	}
	if (0 < [spotArray count]) {
		centerLat = centerLat/[spotArray count];
		centerLong = centerLong/[spotArray count];
	}
	
	//[self gotoLocation];  
	[self.mapView addAnnotations:self.mapAnnotations];
	
	[mapView setCenterCoordinate:CLLocationCoordinate2DMake(centerLat, centerLong)
					   zoomLevel:10
						animated:YES];
}

- (void)displayAction:(id)sender
{
	[self.mapView addAnnotations:self.mapAnnotations];
}

#pragma mark -
#pragma mark MKMapViewDelegate

//- (void)showDetails:(id)sender
//{
//    // the detail view does not want a toolbar so hide it  
//	UIButton *btn = (UIButton *)sender;
//	
//	FGSpotDetailViewController *detail = [[FGSpotDetailViewController alloc] init];
//	for (int i = 0 ; i < [spotArray count] ; i++) {
//		FGSpot *spot = [spotArray objectAtIndex:i];
//		if (spot.spotId == ([btn tag] - kBaseTag)) {
//			detail.spot = spot;
//			break;
//		}
//	}
//	detail.hidesBottomBarWhenPushed = YES;
//	[self.navigationController pushViewController:detail animated:YES];
//	[detail release];
//}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // handle our two custom annotations
    //
    if ([annotation isKindOfClass:[FGSpotAnnotation class]]) // for Golden Gate Bridge
    {
		NSLog(@"%@",annotation);
        // try to dequeue an existing pin view first
        static NSString* SpotAnnotationIdentifier = @"SpotAnnotationIdentifier";
        MKPinAnnotationView* pinView = (MKPinAnnotationView *)
		[mapView dequeueReusableAnnotationViewWithIdentifier:SpotAnnotationIdentifier];
        if (!pinView)
        {
            // if an existing pin view was not available, create one
            MKPinAnnotationView* customPinView = [[[MKPinAnnotationView alloc]
												   initWithAnnotation:annotation reuseIdentifier:SpotAnnotationIdentifier] autorelease];
			customPinView.pinColor = MKPinAnnotationColorRed;
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = YES;
            customPinView.draggable = YES;
            // add a detail disclosure button to the callout which will open a new view controller page
            //
            // note: you can assign a specific call out accessory view, or as MKMapViewDelegate you can implement:
            //  - (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control;
            //
//            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//			FGSpotAnnotation *sa = (FGSpotAnnotation *)annotation;
//			rightButton.tag = kBaseTag + sa.spot.spotId;
//            [rightButton addTarget:self
//                            action:@selector(showDetails:)
//                  forControlEvents:UIControlEventTouchUpInside];
//            customPinView.rightCalloutAccessoryView = rightButton;
			
            return customPinView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    
    return nil;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	GT_RELEASE(spotArray);
	GT_RELEASE(mapView);
	GT_RELEASE(mapAnnotations);
}


- (void)dealloc {
	GT_RELEASE(spotArray);
	GT_RELEASE(mapView);
	GT_RELEASE(mapAnnotations);
    [super dealloc];
}


@end
