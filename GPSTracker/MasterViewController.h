//
//  MasterViewController.h
//  GPSTracker
//
//  Created by  on 12-7-3.
//  Copyright (c) 2012年 freelancer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
