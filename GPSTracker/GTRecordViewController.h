//
//  GTRecordViewController.h
//  GPSTracker
//
//  Created by  on 12-7-25.
//  Copyright (c) 2012年 freelancer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GradientButton.h"

@protocol GTRecordDelegate;

@interface GTRecordViewController : UIViewController
{
    UILabel *timeLabel;
	NSTimer *timer;
	int		count;
	id<GTRecordDelegate> delegate;
	NSString *recordPath;
	BOOL isShow;
	GradientButton *recordBtn;
	GradientButton *stopBtn;
    GradientButton *saveBtn;
}

@property (nonatomic, assign) id<GTRecordDelegate> delegate;

@end

@protocol GTRecordDelegate <NSObject>

- (void)addRecord:(NSString *)path withRootController:(GTRecordViewController *)ctrl;

@end