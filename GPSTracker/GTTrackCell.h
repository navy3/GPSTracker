//
//  GTTrackCell.h
//  GPSTracker
//
//  Created by  on 12-7-19.
//  Copyright (c) 2012年 freelancer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KDImageView.h"
#import "GTTrack.h"

@interface GTTrackCell : UITableViewCell<KDImageViewDelegate>

- (void)updateCell:(GTTrack *)gttrack;

@end
