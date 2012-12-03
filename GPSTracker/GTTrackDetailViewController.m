//
//  GTTrackDetailViewController.m
//  GPSTracker
//
//  Created by  on 12-7-22.
//  Copyright (c) 2012年 freelancer. All rights reserved.
//

#import "GTTrackDetailViewController.h"
#import "GTTrack.h"
#import "GTTrackDetail.h"
#import "UIToolbar+BackgroundImage.h"
#import "Helper.h"

#import "GTHelper.h"

#import "FGSingleChooseViewController.h"

#import "GAPI.h"
#import "SBJson.h"

#import "SNFileObject.h"
#import "FGAudioRecoder.h"
#import "FGSpotMapViewController.h"

@interface GTTrackDetailViewController ()

@property (nonatomic, retain) UIPopoverController *masterPopoverController;

@end

@implementation GTTrackDetailViewController

@synthesize track = _track;
@synthesize dataArray = _dataArray;
@synthesize tbView = _tbView;
@synthesize masterPopoverController = _masterPopoverController;
@synthesize trackDao = _trackDao;
@synthesize detailDao = _detailDao;
@synthesize trackDetail = _trackDetail;
@synthesize pickerCtrl = _pickerCtrl;
@synthesize textFlag = _textFlag;
@synthesize selectedIndex = _selectedIndex;

- (void)dealloc
{
    GT_RELEASE(_trackDao);
    GT_RELEASE(_detailDao);
    GT_RELEASE(_track);
    GT_RELEASE(_trackDetail);
    GT_RELEASE(_dataArray);
    GT_RELEASE(_tbView);
    GT_RELEASE(_pickerCtrl);
    GT_RELEASE(_masterPopoverController);
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    GT_RELEASE(_trackDao);
    GT_RELEASE(_detailDao);
    GT_RELEASE(_track);
    GT_RELEASE(_trackDetail);
    GT_RELEASE(_dataArray);
    GT_RELEASE(_tbView);
    GT_RELEASE(_pickerCtrl);
    GT_RELEASE(_masterPopoverController);
}

- (void)createTableView
{
	if( _tbView )
		return ;
	
	_tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height  - 40) style:UITableViewStyleGrouped];
	_tbView.scrollEnabled = YES;
	_tbView.alwaysBounceVertical = YES;
	_tbView.delegate = self;
	_tbView.dataSource = self;
	_tbView.scrollsToTop = YES;
    _tbView.allowsSelectionDuringEditing = YES;
    //    tbView.layer.cornerRadius = 8.0f;
    //    tbView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //    tbView.layer.borderWidth = 1.0f;
	_tbView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	_tbView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	_tbView.backgroundColor = [UIColor clearColor];
	[self.view addSubview:_tbView];
}

- (void)initPicker
{
	if (_pickerCtrl) 
		return;
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.allowsEditing = NO;
	picker.delegate = self;
	self.pickerCtrl = picker;
	[picker release];
}

- (void)createToolbar
{
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 40 - 40, self.view.bounds.size.width, 40)];
    //toolbar.tintColor = NAVBAR_TINTCOLOR;
    
    [UIToolbar iOS5UIToolbarBackgroundImage];
    
    UIBarButtonItem *item1 = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"text.png"]
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(textAction:)] 
                               autorelease];
    
    UIBarButtonItem *item2 = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"photo.png"]
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(cameraAction:)] 
                              autorelease];
    
    UIBarButtonItem *item3 = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"picture.png"]
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(imageAction:)] 
                              autorelease];
   
    UIBarButtonItem *item4 = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"mic.png"]
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(recordAction:)] 
                              autorelease];
    
//    UIBarButtonItem *item5 = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"globe.png"]
//                                                               style:UIBarButtonItemStylePlain
//                                                              target:self
//                                                              action:nil] 
//                              autorelease];
    
    UIBarButtonItem *flex = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                           target:nil
                                                                           action:nil] 
                             autorelease];

    
    [toolbar setItems:[NSArray arrayWithObjects:item1,flex,item2,flex,item3,flex,item4, nil]];
    
    [self.view addSubview:toolbar];
    
    [toolbar release];
}

#pragma mark - 
#pragma toolbar actions

- (void)textAction:(id)sender
{    
    self.trackDetail.contentType = GT_Text;
    self.trackDetail.addTime = [NSDate date];
    self.textFlag = Text_New;

    FGTextViewViewController *tv = [[FGTextViewViewController alloc] init];
    tv.title = NSLocalizedString(@"GT_Detail_New_Text",);
    tv.delegate = self;
    [self.navigationController pushViewController:tv animated:YES];
    [tv release];
}

- (void)imageAction:(id)sender
{
    self.trackDetail.contentType = GT_Image;
    self.trackDetail.addTime = [NSDate date];
    
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
		self.pickerCtrl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		self.pickerCtrl.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
		[self presentModalViewController:self.pickerCtrl animated:YES];
	}
}

- (void)cameraAction:(id)sender
{
    self.trackDetail.contentType = GT_Image;
    self.trackDetail.addTime = [NSDate date];

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		self.pickerCtrl.sourceType = UIImagePickerControllerSourceTypeCamera;
		self.pickerCtrl.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
		[self presentModalViewController:self.pickerCtrl animated:YES];
	}
}

- (void)recordAction:(id)sender
{
    self.trackDetail.contentType = GT_Record;
    self.trackDetail.addTime = [NSDate date];

    GTRecordViewController *record = [[GTRecordViewController alloc] init];
    record.delegate = self;
    [self.navigationController pushViewController:record animated:YES];
    [record release];
}


- (void)didInputTextView:(NSString *)text rootController:(UIViewController *)ctrl
{
    if (Text_New == self.textFlag) {
        self.trackDetail.content = text;
        if ([self.detailDao insertByDetail:self.trackDetail]) {
            [self loadDetail];
        }
    }
    else if (Text_Modify == self.textFlag) {
        GTTrackDetail *temp = [self.dataArray objectAtIndex:self.selectedIndex];
        temp.content = text;
        if ([self.detailDao updateByDetail:temp]) {
            [self loadDetail];
        }
    }
    else {
        self.track.trackAddress = text;
        
        if([self.trackDao updateByTrack:self.track])
        {
            [self.tbView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:3]] withRowAnimation:UITableViewRowAnimationFade];
        }

    }
}

- (void)addRecord:(NSString *)path withRootController:(GTRecordViewController *)ctrl
{
    self.trackDetail.content = path;
    
    if ([self.detailDao insertByDetail:self.trackDetail]) {
        [self dismissModalViewControllerAnimated:YES];
        [self loadDetail];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    
	self.trackDetail.content = [[SNFileObject sharedInstance] saveImage:img];
    
    if ([self.detailDao insertByDetail:self.trackDetail]) {
        [self dismissModalViewControllerAnimated:YES];
        [self loadDetail];
    }
}

- (void)loadDetail
{
    self.dataArray =[self.detailDao selectByTrackId:self.track.tid];
    [self.tbView reloadSections:[NSIndexSet indexSetWithIndex:4] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)initData
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    if (!_trackDao) {
        self.trackDao = [[[GTTrackDao alloc] init] autorelease];
    }
    
    if (!_detailDao) {
        self.detailDao = [[[GTDetailDao alloc] init] autorelease];
    }
    
    if (!_trackDetail) {
        _trackDetail = [[GTTrackDetail alloc] init];
    }
}

- (void)setTrack:(GTTrack *)newTrack
{
    if (_track != newTrack) {
        [_track release];
        _track = [newTrack retain];
        
        if (_trackDetail) {
            [_trackDetail release];
        }
        _trackDetail = [[GTTrackDetail alloc] init];        
        
        [self configureView];
    }
    
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}

- (void)configureView
{    
    self.trackDetail.tid = self.track.tid;
    self.dataArray =[self.detailDao selectByTrackId:self.track.tid];

    [self.tbView reloadData];    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = PATH_COLOR;
        
        self.title = NSLocalizedString(@"GT_Detail", );
        
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                                                target:self
                                                                                                action:@selector(editAction:)] 
                                                  autorelease];
        
        [self initData];
        [self initPicker];

    }
    return self;
}

- (void)editAction:(id)sender
{
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                            target:self
                                                                                            action:@selector(doneAction:)] 
                                              autorelease];
    
    [self.tbView setEditing:YES animated:YES];
    [self.tbView performSelector:@selector(reloadData) withObject:nil afterDelay:0.3];
}

- (void)doneAction:(id)sender
{
    if ([self.trackDao updateByTrack:self.track]) {
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                                                target:self
                                                                                                action:@selector(editAction:)] 
                                                  autorelease];
        [self.tbView setEditing:NO animated:YES];
        [self.tbView performSelector:@selector(reloadData) withObject:nil afterDelay:0.3];
    }
}

- (void)loadView
{
    [super loadView];
    [self createTableView];
    [self createToolbar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int rows;
    switch (section) {
        case 3:
            rows = 2;
            break;
        case 4:
            rows = [self.dataArray count];
            break;
        default:
            rows = 1;
            break;
    }
    return rows;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title;
    switch (section) {
        case 0:
            title = NSLocalizedString(@"GT_Detail_Name", );
            break;
        case 1:
            title = NSLocalizedString(@"GT_Detail_Group", );
            break;
        case 2:
            title = NSLocalizedString(@"GT_Detail_Time", );
            break;
        case 3:
            title = NSLocalizedString(@"GT_Detail_Address", );
            break;
        case 4:
            title = NSLocalizedString(@"GT_Detail_Note", );
            break;
        default:
            break;
    }
    return title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height;
    if (3 == indexPath.section && 0 == indexPath.row) {
        if ([self.track.trackAddress length]) {
            height = 60;
        }
        else {
            height = 40;
        }
        
    }
    else {
        height = 40;
    }
	return height;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
	if (4 == indexPath.section) {
		return YES;
	}
	else {
		return NO;
	}
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (4 == indexPath.section) {
		return UITableViewCellEditingStyleDelete;
	}
	return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UITableViewCellEditingStyleDelete == editingStyle) {
        GTTrackDetail *temp = [self.dataArray objectAtIndex:indexPath.row];
        if ([self.detailDao deleteAt:temp.did]) {
            [self.dataArray removeObjectAtIndex:indexPath.row];
            [self.tbView reloadSections:[NSIndexSet indexSetWithIndex:4] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
		//cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.textLabel.font = [UIFont fontWithName:@"FZCuYuan-M03" size:17];

    }

    if (0 == indexPath.section) {
        if ([self.tbView isEditing]) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        cell.imageView.image = nil;

        cell.textLabel.textColor = TEXT_BLUE_COLOR;
        cell.textLabel.text = self.track.trackName;
    }
    else if (1 == indexPath.section) {
        
        if ([self.tbView isEditing]) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        cell.imageView.image = nil;

        cell.textLabel.textColor = TEXT_BLUE_COLOR;
        cell.textLabel.text = self.track.trackGroup;
    }
    else if (2 == indexPath.section) {
        cell.imageView.image = nil;

        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textColor = TEXT_BLUE_COLOR;
        cell.textLabel.text = [Helper getStringByDateTime:self.track.trackTime];
    }
    else if (3 == indexPath.section) {

        if (0 == indexPath.row) {
            if ([self.tbView isEditing]) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }

            cell.imageView.image = nil;

            if ([self.track.trackAddress length]) {
                cell.textLabel.numberOfLines = 2;
                cell.textLabel.textColor = [UIColor grayColor];
                cell.textLabel.text = self.track.trackAddress;
            }
            else {
                cell.textLabel.textColor = [UIColor redColor];
                cell.textLabel.text = NSLocalizedString(@"GT_Detail_UpdateAddress", );
            }

        }
        else {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.imageView.image = nil;

            cell.textLabel.textColor = TEXT_BLUE_COLOR;
            cell.textLabel.text = [NSString stringWithFormat:@"lat:%f lon:%f",self.track.latitude,self.track.longitude];
        }
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = [UIColor blackColor];
        
        GTTrackDetail *temp = [self.dataArray objectAtIndex:indexPath.row];
        cell.imageView.image = [GTHelper imageWithType:temp.contentType];
        cell.textLabel.text = [Helper getStringByDateTime: temp.addTime withFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.tbView isEditing]) {
        if (0 == indexPath.section) {
            FGTextFieldViewController *tf = [[FGTextFieldViewController alloc] init];
            tf.title = NSLocalizedString(@"GT_Detail_Name", );
            tf.delegate = self;
            [self.navigationController pushViewController:tf animated:YES];
            if ([self.track.trackName length]) {
                tf.textField.text = self.track.trackName;
            }
            [tf release];
        }
        else if (1 == indexPath.section) {
            FGSingleChooseViewController *single = [[FGSingleChooseViewController alloc] initWithArray:[GTHelper groupList]];
            single.title = NSLocalizedString(@"GT_Detail_Group", );
            single.delegate = self;
            [self.navigationController pushViewController:single animated:YES];
            [single release];
        }
        else if (3 == indexPath.section) {
            if (0 == indexPath.row) {
                if ([self.track.trackAddress length]) {
                    self.textFlag = 2;
                    FGTextViewViewController *tv = [[FGTextViewViewController alloc] init];
                    tv.delegate = self;
                    [self.navigationController pushViewController:tv animated:YES];
                    tv.textView.text = self.track.trackAddress;
                    [tv release];
                }
                else {
                    if ([Helper checkNewWork]) 
                        [self loadDetailAddress];
                    
                }
            }
            else {
                FGSpotMapViewController *map = [[FGSpotMapViewController alloc] init];
                [self.navigationController pushViewController:map animated:YES];
                [map addAnnotations:[NSArray arrayWithObject:self.track]];
                [map release];
            }
        }
    }
    else {
        if (3 == indexPath.section) {
            if (0 == indexPath.row) {
                if (![self.track.trackAddress length]) {
                    if ([Helper checkNewWork]) 
                        [self loadDetailAddress];
                }
            }
            else {
                FGSpotMapViewController *map = [[FGSpotMapViewController alloc] init];
                [self.navigationController pushViewController:map animated:YES];
                [map addAnnotations:[NSArray arrayWithObject:self.track]];
                [map release];
            }
        }
        else if (4 == indexPath.section) {
            self.selectedIndex = indexPath.row;

            GTTrackDetail *temp = [self.dataArray objectAtIndex:indexPath.row];            
            
            if (GT_Text == temp.contentType) {
                self.textFlag = Text_Modify;

                FGTextViewViewController *tv = [[FGTextViewViewController alloc] init];
                tv.delegate = self;
                [self.navigationController pushViewController:tv animated:YES];
                tv.textView.text = temp.content;
                [tv release];
            }
            else if (GT_Record == temp.contentType) {
                UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                   delegate:self
                                                          cancelButtonTitle:NSLocalizedString(@"GT_ActionSheet_Cancel", )
                                                     destructiveButtonTitle:nil
                                                          otherButtonTitles:NSLocalizedString(@"GT_ActionSheet_Play", ),
                                        NSLocalizedString(@"GT_ActionSheet_Stop", ), nil];
                [sheet showInView:self.view];
                [sheet release];
            }
            else if (GT_Image == temp.contentType) {
                FGSinglePhotoViewController *photo = [[FGSinglePhotoViewController alloc] initWithImage:
                                                      [UIImage imageWithContentsOfFile:temp.content]];
                photo.delegate = self;
                [self.navigationController pushViewController:photo animated:YES];
                [photo release];
            }
        }
        
    }

}

#pragma mark - 
#pragma mark custom delegate methods

- (void)addToCover
{
    GTTrackDetail *temp = [self.dataArray objectAtIndex:self.selectedIndex];
    self.track.trackImageUrl = temp.content;
    
    if([self.trackDao updateByTrack:self.track])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:NSLocalizedString(@"GT_Alert_Success", )
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"GT_Alert_OK", )
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    GTTrackDetail *temp = [self.dataArray objectAtIndex:self.selectedIndex];
    if (0 == buttonIndex) {
        [[FGAudioRecoder sharedWTAudio] startPlay:temp.content];
    }
    else if ( 1 == buttonIndex) {
        [[FGAudioRecoder sharedWTAudio] stopPlay];
    }
}

-(void)didInputText:(NSString *)text rootController:(UIViewController *)ctrl
{
    self.track.trackName = text;
    [self.tbView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];   
}

- (void)didChooseString:(NSString *)str rootController:(UIViewController *)ctrl
{
    self.track.trackGroup = str;
    [self.tbView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];    
}

- (void)loadDetailAddress
{
    GAPI *api = [[GAPI alloc] init];
    [api setDelegate:self];
    [api requestURL:[NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?latlng=%f,%f&sensor=true",_track.latitude,_track.longitude] withSuccessSEL:@selector(apiSuccess:) errorSEL:@selector(apiError:)];
    [api release];
}

- (void)apiSuccess:(id)sender
{
	NSArray *arr = [[sender JSONValue] objectForKey:@"results"];
	self.track.trackAddress = [[arr objectAtIndex:0] objectForKey:@"formatted_address"];

    if([self.trackDao updateByTrack:self.track])
    {
        [self.tbView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:3]] withRowAnimation:UITableViewRowAnimationFade];
    }

}

- (void)apiError:(GAPI *)sender
{

}

@end
