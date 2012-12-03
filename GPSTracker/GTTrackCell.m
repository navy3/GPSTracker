//
//  GTTrackCell.m
//  GPSTracker
//
//  Created by  on 12-7-19.
//  Copyright (c) 2012年 freelancer. All rights reserved.
//

#import "GTTrackCell.h"
#import "Helper.h"

@interface GTTrackCell()

@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *addressLabel;
@property (nonatomic, retain) KDImageView *imgView;
@property (nonatomic, retain) GTTrack *track;
@property (nonatomic, retain) UILabel *timeLabel;

@end

@implementation GTTrackCell

@synthesize nameLabel,addressLabel,imgView,track,timeLabel;

- (void)dealloc
{
    GT_RELEASE(track);
    GT_RELEASE(imgView);
    GT_RELEASE(nameLabel);
    GT_RELEASE(addressLabel);
    GT_RELEASE(timeLabel);
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    if (!imgView) {
        self.imgView = [[[KDImageView alloc] initWithFrame:CGRectMake(3, 3, 54, 54)] autorelease];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.image = [UIImage imageNamed:@"pin.png"];
        //[imgView setURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"pin" ofType:@"png"]]];
        [self.contentView addSubview:imgView];
        imgView.delegate = self;
    }
    
    if (!nameLabel) {
		self.nameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(80, 5, 160, 20)] autorelease];
		nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textColor = [UIColor blackColor];
		nameLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
		nameLabel.font = [UIFont fontWithName:@"FZCuYuan-M03" size:16];
        nameLabel.highlightedTextColor = [UIColor whiteColor];
		[self.contentView addSubview:nameLabel];
        nameLabel.text = @"";
	}
    
    if (!addressLabel) {
		self.addressLabel = [[[UILabel alloc] initWithFrame:CGRectMake(80, 28, 220, 30)] autorelease];
		addressLabel.backgroundColor = [UIColor clearColor];
		addressLabel.textColor = [UIColor grayColor];
		addressLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
		addressLabel.font = [UIFont systemFontOfSize:12];
        addressLabel.numberOfLines = 2;
        addressLabel.highlightedTextColor = [UIColor whiteColor];
		[self.contentView addSubview:addressLabel];
        addressLabel.text = @"";
	}
    
    if (!timeLabel) {
		self.timeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(260, 3, 60, 20)] autorelease];
		timeLabel.backgroundColor = [UIColor clearColor];
		timeLabel.textColor = [UIColor darkGrayColor];
		timeLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
		timeLabel.font = [UIFont systemFontOfSize:13];
        timeLabel.numberOfLines = 2;
        timeLabel.highlightedTextColor = [UIColor whiteColor];
		[self.contentView addSubview:timeLabel];
        timeLabel.text = @"";
	}
}

- (void)updateCell:(GTTrack *)gttrack
{
    self.track = gttrack;
    if ([self.track.trackImageUrl length]) {
        imgView.image = [UIImage imageWithContentsOfFile:self.track.trackImageUrl];
    }
    else {
        imgView.image = [UIImage imageNamed:@"pin.png"];
    }
    
    timeLabel.text = [Helper getYearStringByDateTime:track.trackTime];
    nameLabel.text = track.trackName;
    addressLabel.text = track.trackAddress;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
