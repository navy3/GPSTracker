//
//  GTTrackListViewController.m
//  GPSTracker
//
//  Created by  on 12-7-5.
//  Copyright (c) 2012年 freelancer. All rights reserved.
//

#import "GTTrackListViewController.h"
#import "GTTrackDao.h"
#import "UIToolbar+BackgroundImage.h"
#import "GTTrackCell.h"

#import "GAPI.h"
#import "SBJson.h"

#import "GTTrackDetailViewController.h"

@interface GTTrackListViewController ()

@property (nonatomic, retain) UITableView *tbView;
@property (nonatomic, retain) GTTrackDao *trackDao;
@property (nonatomic, retain) GTTrack *track;
@property (nonatomic, retain) CLLocationManager *locManager;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) GTTrackDetailViewController *detailViewController;

@end

@implementation GTTrackListViewController

@synthesize tbView,trackDao,locManager,dataArray,track,detailViewController;

- (void)dealloc
{
    GT_RELEASE(detailViewController);
    GT_RELEASE(track);
    GT_RELEASE(trackDao);
    GT_RELEASE(dataArray);
    GT_RELEASE(tbView);
    if (locManager.delegate = self) {
        locManager.delegate = nil;
    }
    GT_RELEASE(locManager);
    [super dealloc];
}

- (void)createTableView
{
	if( tbView )
		return ;
	
	self.tbView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height  - 40) style:UITableViewStylePlain] autorelease];
	tbView.scrollEnabled = YES;
	tbView.alwaysBounceVertical = YES;
	tbView.delegate = self;
	tbView.dataSource = self;
	tbView.scrollsToTop = YES;
    //    tbView.layer.cornerRadius = 8.0f;
    //    tbView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //    tbView.layer.borderWidth = 1.0f;
	tbView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	tbView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	tbView.backgroundColor = [UIColor clearColor];
	[self.view addSubview:tbView];
}

- (void)createToolbar
{
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 40 - 44, self.view.bounds.size.width, 40)];
    //toolbar.tintColor = NAVBAR_TINTCOLOR;
    
    [UIToolbar iOS5UIToolbarBackgroundImage];
    
    UIBarButtonItem *item1 = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
                                                                            target:self 
                                                                            action:@selector(addAction:)]
                              autorelease];
    
//    UIBarButtonItem *item2 = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch 
//                                                                            target:self 
//                                                                            action:@selector(searchAction:)] 
//                              autorelease];
//    
//    UIBarButtonItem *item3 = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
//                                                                            target:self 
//                                                                            action:@selector(moreAction:)] 
//                              autorelease];
    
    UIBarButtonItem *flex = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                           target:nil
                                                                           action:nil] autorelease];
    
    [toolbar setItems:[NSArray arrayWithObjects:flex,item1,flex, nil]];
    [self.view addSubview:toolbar];

    [toolbar release];
}

- (void)addAction:(id)sender
{
    track.trackTime = [NSDate date];
    track.trackName = NSLocalizedString(@"GT_Track_Name", );
    track.trackImageUrl = nil;
    
    [locManager startUpdatingLocation];

}

- (void)searchAction:(id)sender
{
    
}

- (void)moreAction:(id)sender
{
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor whiteColor];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
        }
        
        [self initLoc];
        
        [self initData];
        
        //[self loadData];

    }
    return self;
}

- (void)loadData
{
    if ([self.title isEqualToString:NSLocalizedString(@"GT_Group_All", )]) {
        self.dataArray = [trackDao select];
    }
    else {
        self.dataArray = [trackDao selectByGroup:self.title];
    }
    [tbView reloadData];
}

- (void)initLoc
{
    locManager = [[CLLocationManager alloc] init];
	[locManager setDelegate:self];
	[locManager setDesiredAccuracy:kCLLocationAccuracyBest];    
    [locManager setDistanceFilter:kCLDistanceFilterNone];
}



- (void)loadDetailAddress
{
    GAPI *api = [[GAPI alloc] init];
    [api setDelegate:self];
    [api requestURL:[NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?latlng=%f,%f&sensor=true",track.latitude,track.longitude] withSuccessSEL:@selector(apiSuccess:) errorSEL:@selector(apiError:)];
    [api release];
}

- (void)apiSuccess:(id)sender
{
	NSArray *arr = [[sender JSONValue] objectForKey:@"results"];
	track.trackAddress = [[arr objectAtIndex:0] objectForKey:@"formatted_address"];
    NSLog(@"%s %@",__func__,track.trackImageUrl);

    if ([trackDao insertByTrack:track]) {
        [self loadData];
    }
}

- (void)apiError:(GAPI *)sender
{


    if ([trackDao insertByTrack:track]) {
        [self loadData];
    }
//	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//													message:@"获取位置信息失败" 
//												   delegate:nil 
//										  cancelButtonTitle:nil
//										  otherButtonTitles:@"确定",nil];
//	[alert show];
//	[alert release];
}

#pragma mark -
#pragma mark Location manager
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    CLLocationCoordinate2D loc = [newLocation coordinate];
    
    track.latitude = loc.latitude;
    track.longitude = loc.longitude;
    [locManager stopUpdatingLocation];
    
    [self loadDetailAddress];
    
} 

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)loadView
{
    [super loadView];

    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                                            target:self
                                                                                            action:@selector(editAction:)] 
                                              autorelease];
    
    [self createTableView];
    
    [self createToolbar];
}

- (void)editAction:(id)sender
{
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                            target:self
                                                                                            action:@selector(doneAction:)] 
                                              autorelease];
    
    [self.tbView setEditing:YES animated:YES];
}

- (void)doneAction:(id)sender
{
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                                            target:self
                                                                                            action:@selector(editAction:)] 
                                              autorelease];
    [self.tbView setEditing:NO animated:YES];
}

#pragma mark -
#pragma mark load data

- (void)initData
{
    if (!track) {
        self.track = [[[GTTrack alloc] init] autorelease];
    }
    if (!trackDao) {
        self.trackDao = [[[GTTrackDao alloc] init] autorelease];
    }
}


#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UITableViewCellEditingStyleDelete == editingStyle) {
        GTTrack *temp = [self.dataArray objectAtIndex:indexPath.row];
        if ([self.trackDao deleteAt:temp.tid]) {
            [self.dataArray removeObjectAtIndex:indexPath.row];
            [self.tbView reloadData];
        }
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    GTTrackCell *cell = (GTTrackCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[GTTrackCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryNone;
		//cell.editingStyle = UITableViewCellEditingStyleInsert;
    }
    
    //cell.imageView.image = [UIImage imageNamed:@"pin.png"];
    GTTrack *temp = [dataArray objectAtIndex:indexPath.row];
    //cell.textLabel.text = [temp.trackTime descriptionWithLocale:[NSLocale currentLocale]];
    [cell updateCell:temp];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.track = [dataArray objectAtIndex:indexPath.row];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    if (!self.detailViewController) {
	        self.detailViewController = [[[GTTrackDetailViewController alloc] init] autorelease];
	    }
	    self.detailViewController.track = track;
        [self.navigationController pushViewController:self.detailViewController animated:YES];

    } else {
        self.detailViewController.track = track;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    GT_RELEASE(detailViewController);
    GT_RELEASE(track);
    GT_RELEASE(trackDao);
    GT_RELEASE(dataArray);
    GT_RELEASE(tbView);
    if (locManager.delegate = self) {
        locManager.delegate = nil;
    }
    GT_RELEASE(locManager);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
