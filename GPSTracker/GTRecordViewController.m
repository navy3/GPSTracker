//
//  GTRecordViewController.m
//  GPSTracker
//
//  Created by  on 12-7-25.
//  Copyright (c) 2012年 freelancer. All rights reserved.
//

#import "GTRecordViewController.h"
#import "SNFileObject.h"
#import "FGAudioRecoder.h"

@interface GTRecordViewController ()

@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, copy) NSString *recordPath;
@property (nonatomic, retain) GradientButton *recordBtn;
@property (nonatomic, retain) GradientButton *stopBtn;
@property (nonatomic, retain) GradientButton *saveBtn;

- (void)createNavItem;
- (void)createTimer;
- (void)stopTimer;

@end

@implementation GTRecordViewController

@synthesize timer,timeLabel,recordPath,delegate,recordBtn,stopBtn,saveBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = PATH_COLOR;
        self.title = NSLocalizedString(@"GT_Detail_New_Record", );
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    [self createNavItem];
	
	timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 300, 160)];
	timeLabel.backgroundColor = [UIColor clearColor];
	timeLabel.textColor = [UIColor blackColor];
	timeLabel.font = [UIFont boldSystemFontOfSize:100];
	timeLabel.textAlignment = UITextAlignmentCenter;
	timeLabel.text = @"00:00";
	[self.view addSubview:timeLabel];
    
	self.recordPath = [[SNFileObject sharedInstance] dir:SNRecordDir];
	self.recordPath = [recordPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.caf",[NSDate date]]];
	
	[[FGAudioRecoder sharedWTAudio] initRecord:recordPath];
	
	self.recordBtn = [GradientButton buttonWithType:UIButtonTypeCustom];
	[recordBtn useRedDeleteStyle];
	[recordBtn setTitle:NSLocalizedString(@"GT_Record_Record",@"") forState:UIControlStateNormal];
	[recordBtn setFrame:CGRectMake(20, 240, 280, 45)];
	recordBtn.titleLabel.font = [UIFont boldSystemFontOfSize:24];
	[recordBtn addTarget:self action:@selector(recordAction:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:recordBtn];
	
	self.stopBtn = [GradientButton buttonWithType:UIButtonTypeCustom];
	[stopBtn useBlackStyle];
	[stopBtn setTitle:NSLocalizedString(@"GT_Record_Stop",@"") forState:UIControlStateNormal];
	[stopBtn setFrame:CGRectMake(20, 300, 280, 45)];
	stopBtn.titleLabel.font = [UIFont boldSystemFontOfSize:24];
	[stopBtn addTarget:self action:@selector(stopAction:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:stopBtn];
	
	self.saveBtn = [GradientButton buttonWithType:UIButtonTypeCustom];
	[saveBtn useSimpleOrangeStyle];
	[saveBtn setTitle:NSLocalizedString(@"GT_Record_Save",@"") forState:UIControlStateNormal];
	[saveBtn setFrame:CGRectMake(20, 360, 280, 45)];
	saveBtn.titleLabel.font = [UIFont boldSystemFontOfSize:24];
	[saveBtn addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:saveBtn];
    saveBtn.enabled = NO;
	
}

- (void)recordAction:(id)sender
{
	if([[(GradientButton *)sender currentTitle] isEqualToString:NSLocalizedString(@"GT_Record_Record",@"")])
	{
		[[FGAudioRecoder sharedWTAudio] startRecord];
		[self createTimer];
		recordBtn.enabled = NO;
		return;
	}
	if([[(GradientButton *)sender currentTitle] isEqualToString:NSLocalizedString(@"GT_Record_Play",@"")])
	{
		[[FGAudioRecoder sharedWTAudio] startPlay:recordPath];
		//count = 0;
		//[self createTimer];
		recordBtn.enabled = NO;
		return;
	}
}

- (void)stopAction:(id)sender
{
	[self stopTimer];
	
	[[FGAudioRecoder sharedWTAudio] stopRecord];
    
	[recordBtn setTitle:NSLocalizedString(@"GT_Record_Play",@"") forState:UIControlStateNormal];
	
	recordBtn.enabled = YES;
	saveBtn.enabled = YES;
}

- (void)updateLabel
{
	count ++;
	
	int min = count/60;
	if (min > 0 && min < 10) {
		if (count%60 < 10) {
			NSString *str = [NSString stringWithFormat:@"0%d:0%d",count/60,count%60];
			timeLabel.text = str;
		}
		else {
			NSString *str = [NSString stringWithFormat:@"0%d:%d",count/60,count%60];
			timeLabel.text = str;
		}
		
		
	}
	else if( min > 10)
	{
		if (count%60 < 10) {
			NSString *str = [NSString stringWithFormat:@"%d:0%d",count/60,count%60];
			timeLabel.text = str;
		}
		else {
			NSString *str = [NSString stringWithFormat:@"%d:%d",count/60,count%60];
			timeLabel.text = str;
		}
	}
	else {
		if (count%60 < 10) {
			NSString *str = [NSString stringWithFormat:@"00:0%d",count%60];
			timeLabel.text = str;
		}
		else {
			NSString *str = [NSString stringWithFormat:@"00:%d",count%60];
			timeLabel.text = str;
		}
	}
	
}

- (void)saveAction:(id)sender
{
	if (recordPath) {
		if ([delegate respondsToSelector:@selector(addRecord:withRootController:)]) {
			[delegate addRecord:self.recordPath withRootController:self];
			[self.navigationController popViewControllerAnimated:YES];
		}
	}
}

- (void)createNavItem
{
//	UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
//																			 target:self 
//																			 action:@selector(cancelAction:)];
//	self.navigationItem.leftBarButtonItem = leftBar;
//	[leftBar release];
	
	UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
																target:self
																action:@selector(saveAction:)];
	self.navigationItem.rightBarButtonItem = rightBar;
	[rightBar release];
}

- (void)cancelAction:(id)sender
{
	if (timer) {
		[timer invalidate];
		timer = nil;
	}
	[[FGAudioRecoder sharedWTAudio] stopRecord];
	[[FGAudioRecoder sharedWTAudio] stopPlay];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)createTimer
{
	[self stopTimer];
	
	self.timer = [NSTimer scheduledTimerWithTimeInterval:1 
                                                  target:self 
                                                selector:@selector(updateLabel)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)stopTimer
{
	if (timer) {
		[timer invalidate];
		timer = nil;
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    GT_RELEASE(timer);
	GT_RELEASE(timeLabel);
	GT_RELEASE(recordPath);
	GT_RELEASE(recordBtn);
	GT_RELEASE(stopBtn);
    GT_RELEASE(saveBtn);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (timer) {
		[timer invalidate];
		timer = nil;
	}
	[[FGAudioRecoder sharedWTAudio] stopRecord];
	[[FGAudioRecoder sharedWTAudio] stopPlay];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    GT_RELEASE(timer);
	GT_RELEASE(timeLabel);
	GT_RELEASE(recordPath);
	GT_RELEASE(recordBtn);
	GT_RELEASE(stopBtn);
    GT_RELEASE(saveBtn);
    [super dealloc];
}


@end
