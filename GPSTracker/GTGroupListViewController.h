//
//  GTGroupListViewController.h
//  GPSTracker
//
//  Created by  on 12-7-5.
//  Copyright (c) 2012年 freelancer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTTextFieldViewController.h"

@interface GTGroupListViewController : UITableViewController<GTTextFieldDelegate>
{
    int selectedIndex;
}

- (void)showTrackAtIndex:(int)index withAnimation:(BOOL)animated;

@end
