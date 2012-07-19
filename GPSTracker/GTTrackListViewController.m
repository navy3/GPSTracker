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

@interface GTTrackListViewController ()

@property (nonatomic, retain) UITableView *tbView;
@property (nonatomic, retain) GTTrackDao *trackDao;
@property (nonatomic, retain) CLLocationManager *locManager;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) GTTrack *track;

@end

@implementation GTTrackListViewController

@synthesize tbView,trackDao,locManager,dataArray,track;

- (void)dealloc
{
    GT_RELEASE(track);
    GT_RELEASE(trackDao);
    GT_RELEASE(dataArray);
    GT_RELEASE(tbView);
    [super dealloc];
}

- (void)createTableView
{
	if( tbView )
		return ;
	
	self.tbView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height  - 44) style:UITableViewStylePlain] autorelease];
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
    toolbar.tintColor = NAVBAR_TINTCOLOR;
    [UIToolbar iOS5UIToolbarBackgroundImage];
    UIBarButtonItem *item1 = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
                                                                            target:self 
                                                                            action:@selector(addAction:)]
                              autorelease];
    
    UIBarButtonItem *item2 = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch 
                                                                            target:self 
                                                                            action:@selector(searchAction:)] 
                              autorelease];
    
    UIBarButtonItem *item3 = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                            target:self 
                                                                            action:@selector(moreAction:)] 
                              autorelease];
    
    UIBarButtonItem *flex = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                           target:nil
                                                                           action:nil] autorelease];
    
    [toolbar setItems:[NSArray arrayWithObjects:item1,flex,item2,flex,item3, nil]];
    [self.view addSubview:toolbar];

    [toolbar release];
}

- (void)addAction:(id)sender
{
    [locManager startUpdatingLocation];
    track.trackTime = [NSDate date];
    if ([trackDao insertByTrack:track]) {
        [self loadData];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)initLoc
{
    locManager = [[CLLocationManager alloc] init];
	[locManager setDelegate:self];
	[locManager setDesiredAccuracy:kCLLocationAccuracyBest];    
    [locManager setDistanceFilter:kCLDistanceFilterNone];
	[locManager startUpdatingLocation];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self createTableView];
    
    [self createToolbar];
    
    [self initLoc];
    
    [self initData];
    //[self loadData];
    
}

- (void)addTrack:(id)sender
{
    [locManager startUpdatingLocation];
    track.trackTime = [NSDate date];
    if ([trackDao insertByTrack:track]) {
        [self loadData];
    }
}

#pragma mark -
#pragma mark load data

- (void)initData
{
    self.track = [[[GTTrack alloc] init] autorelease];
    self.trackDao = [[[GTTrackDao alloc] init] autorelease];
}

- (void)loadData
{
    self.dataArray = [trackDao select];
    [tbView reloadData];
}

#pragma mark -
#pragma mark Location manager
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    CLLocationCoordinate2D loc = [newLocation coordinate];
    
    NSLog(@"%f %f",loc.latitude,loc.longitude);
    track.latitude = loc.latitude;
    track.longitude = loc.longitude;
    [locManager stopUpdatingLocation];

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

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_bg.png"]];
		//cell.editingStyle = UITableViewCellEditingStyleInsert;
    }
    
    cell.imageView.image = [UIImage imageNamed:@"pin.png"];
    GTTrack *temp = [dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [temp.trackTime descriptionWithLocale:[NSLocale currentLocale]];
    
    return cell;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
