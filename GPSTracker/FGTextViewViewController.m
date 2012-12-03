    //
//  FGTextViewViewController.m
//  FreeGo
//
//  Created by navy on 11-11-6.
//  Copyright 2011 freelancer. All rights reserved.
//

#import "FGTextViewViewController.h"

@interface FGTextViewViewController()

- (void)createTextView;
- (void)buildNav;

@end


@implementation FGTextViewViewController

@synthesize textView,delegate;

- (void)createTextView
{
	UITextView *tv = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width - 20, 160)];
	tv.font = [UIFont fontWithName:@"FZCuYuan-M03" size:17];
	tv.textAlignment = UITextAlignmentLeft;
    tv.backgroundColor = [UIColor clearColor];
	//tv.layer.cornerRadius = 8.0f;	
	[self.view addSubview:tv];
	self.textView = tv;
	[tv release];
	
}


- (void)buildNav
{
	[self.view setBackgroundColor:PATH_COLOR];
		
	UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
	self.navigationItem.rightBarButtonItem = rightBtn;
	[rightBtn release];
}

- (void)doneAction:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
	
	if ([delegate respondsToSelector:@selector(didInputTextView:rootController:)]) {
		[delegate didInputTextView:textView.text rootController:self];
	}
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
	
	self.view.backgroundColor = [UIColor whiteColor];
	
	[self buildNav];
	[self createTextView];
	
	[textView performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.5];

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
	self.textView = nil;
}


- (void)dealloc {
	[textView release];
	textView = nil;
    [super dealloc];
}


@end
