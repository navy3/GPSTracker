//
//  GTTrackCell.m
//  GPSTracker
//
//  Created by  on 12-7-19.
//  Copyright (c) 2012年 freelancer. All rights reserved.
//

#import "GTTrackCell.h"
#import "GTTrack.h"

@implementation GTTrackCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
