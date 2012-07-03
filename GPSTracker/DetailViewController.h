//
//  DetailViewController.h
//  GPSTracker
//
//  Created by  on 12-7-3.
//  Copyright (c) 2012年 freelancer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
