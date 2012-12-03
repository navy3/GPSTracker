    //
//  FGSinglePhotoViewController.m
//  FreeGo
//
//  Created by navy on 11-11-15.
//  Copyright 2011 freelancer. All rights reserved.
//

#import "FGSinglePhotoViewController.h"

#define ZOOM_VIEW_TAG 100
#define ZOOM_STEP 2


@interface FGSinglePhotoViewController (UtilityMethods)
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;
@end

@implementation FGSinglePhotoViewController

@synthesize imageView;
@synthesize delegate;

- (id)initWithImage:(UIImage *)img
{
	self = [super init];
	if (self) {

		//self.navigationController.navigationBar.tintColor = NAVBAR_BLUE_TINTCOLOR;
//		UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction:)];
//		self.navigationItem.leftBarButtonItem = leftBtn;
//		[leftBtn release];
		
        UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"GT_Photo_Cover", ) 
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(coverAction:)
                                     ];
		self.navigationItem.rightBarButtonItem = rightBar;
		[rightBar release];
		
        
		// set up main scroll view
		imageScrollView = [[UIScrollView alloc] initWithFrame:[[self view] bounds]];
		[imageScrollView setBackgroundColor:[UIColor blackColor]];
		[imageScrollView setDelegate:self];
		[imageScrollView setBouncesZoom:YES];
		[[self view] addSubview:imageScrollView];
		
		// add touch-sensitive image view to the scroll view
		imageView = [[UIImageView alloc] initWithImage:img];
		[imageView setTag:ZOOM_VIEW_TAG];
		[imageView setUserInteractionEnabled:YES];
		[imageScrollView setContentSize:[imageView frame].size];
		[imageScrollView addSubview:imageView];
		
		// add gesture recognizers to the image view
		UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
		UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
		UITapGestureRecognizer *twoFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoFingerTap:)];
		
		[doubleTap setNumberOfTapsRequired:2];
		[twoFingerTap setNumberOfTouchesRequired:2];
		
		[imageView addGestureRecognizer:singleTap];
		[imageView addGestureRecognizer:doubleTap];
		[imageView addGestureRecognizer:twoFingerTap];
		
		[singleTap release];
		[doubleTap release];
		[twoFingerTap release];
		
		// calculate minimum scale to perfectly fit image width, and begin at that scale
		float minimumScale = [imageScrollView frame].size.width  / [imageView frame].size.width;
		[imageScrollView setMinimumZoomScale:minimumScale];
		[imageScrollView setZoomScale:minimumScale];
	}
	return self;
}

- (void)dealloc {
	GT_RELEASE(imageView);
	GT_RELEASE(imageScrollView);
    [super dealloc];
}

- (void)coverAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];

    if ([delegate respondsToSelector:@selector(addToCover)]) {
        [delegate addToCover];
    }
}

- (void)cancelAction:(id)sender
{
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark UIScrollViewDelegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [imageScrollView viewWithTag:ZOOM_VIEW_TAG];
}

/************************************** NOTE **************************************/
/* The following delegate method works around a known bug in zoomToRect:animated: */
/* In the next release after 3.0 this workaround will no longer be necessary      */
/**********************************************************************************/
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
    [scrollView setZoomScale:scale+0.01 animated:NO];
    [scrollView setZoomScale:scale animated:NO];
}

#pragma mark TapDetectingImageViewDelegate methods

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    // single tap does nothing for now
	[self dismissModalViewControllerAnimated:YES];
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer {
    // double tap zooms in
    float newScale = [imageScrollView zoomScale] * ZOOM_STEP;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
    [imageScrollView zoomToRect:zoomRect animated:YES];
}

- (void)handleTwoFingerTap:(UIGestureRecognizer *)gestureRecognizer {
    // two-finger tap zooms out
    float newScale = [imageScrollView zoomScale] / ZOOM_STEP;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
    [imageScrollView zoomToRect:zoomRect animated:YES];
}

#pragma mark Utility methods

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    // the zoom rect is in the content view's coordinates. 
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = [imageScrollView frame].size.height / scale;
    zoomRect.size.width  = [imageScrollView frame].size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
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
}


@end
