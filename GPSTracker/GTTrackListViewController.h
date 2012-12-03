//
//  GTTrackListViewController.h
//  GPSTracker
//
//  Created by  on 12-7-5.
//  Copyright (c) 2012年 freelancer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class GTTrackDetailViewController;

@interface GTTrackListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,CLLocationManagerDelegate>

@end
