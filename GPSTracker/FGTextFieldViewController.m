    //
//  FGTextFieldViewController.m
//  FreeGo
//
//  Created by navy on 11-11-5.
//  Copyright 2011 freelancer. All rights reserved.
//

#import "FGTextFieldViewController.h"

@interface FGTextFieldViewController()

- (void)createTextField;

@end


@implementation FGTextFieldViewController

@synthesize textField,delegate;

- (void)createTextField
{
	textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 240, 40)];
	textField.borderStyle = UITextBorderStyleRoundedRect;
	textField.rightViewMode = UITextFieldViewModeWhileEditing;
	textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	//textField.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.placeholder = self.title;
	textField.textAlignment = UITextAlignmentCenter;
	textField.delegate = self;
	textField.center = CGPointMake(self.view.center.x, 80);
	textField.returnKeyType = UIReturnKeyDone;
	[self.view addSubview:textField];
	[textField becomeFirstResponder];
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


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    [super loadView];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
	
	UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
                                                                               target:self
                                                                               action:@selector(doneAction:)];
	self.navigationItem.rightBarButtonItem = rightItem;
	[rightItem release];
    
    [self createTextField];
}


- (BOOL)textFieldShouldReturn:(UITextField *)tf
{
	if ([textField.text length]) {
		[self.navigationController popViewControllerAnimated:YES];
		
		if ([delegate respondsToSelector:@selector(didInputText:rootController:)]) {
			[delegate didInputText:textField.text rootController:self];
		}
	}
	return YES;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)doneAction:(id)sender
{
	if ([textField.text length]) {
		[self.navigationController popViewControllerAnimated:YES];
		
		if ([delegate respondsToSelector:@selector(didInputText:rootController:)]) {
			[delegate didInputText:textField.text rootController:self];
		}
	}
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
	GT_RELEASE(textField);
}


- (void)dealloc {
	GT_RELEASE(textField);
    [super dealloc];
}


@end
