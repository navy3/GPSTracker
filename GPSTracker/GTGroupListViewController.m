//
//  GTGroupListViewController.m
//  GPSTracker
//
//  Created by  on 12-7-5.
//  Copyright (c) 2012年 freelancer. All rights reserved.
//

#import "GTGroupListViewController.h"
#import "GTTrackListViewController.h"
#import "GTHelper.h"
#import "UINavigationBar+BackgroundImage.h"

@interface GTGroupListViewController ()

@property (nonatomic, retain) NSMutableArray *dataArray;

@end

@implementation GTGroupListViewController

@synthesize dataArray;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"GT_Group_Title", );
        
        self.tableView.allowsSelectionDuringEditing = YES;

        self.dataArray = [NSMutableArray arrayWithArray:[GTHelper groupList]];
        
        UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                                  target:self
                                                                                  action:@selector(editAction:)];
        self.navigationItem.rightBarButtonItem = rightBar;
        [rightBar release];
    }
    return self;
}

- (void)showTrackAtIndex:(int)index withAnimation:(BOOL)animated
{
    GTTrackListViewController *track = [[GTTrackListViewController alloc] init];
    if (0 == index) {
        track.title = NSLocalizedString(@"GT_Group_All", );
    }
    else {
        track.title = [dataArray objectAtIndex:index - 1];
    }
    [self.navigationController pushViewController:track animated:animated];
    [track release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    

}

- (void)editAction:(id)sender
{
	[self.tableView setEditing:!self.tableView.editing animated:YES];
	UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
																			  target:self
																			  action:@selector(doneAction:)];
	[self.navigationItem setRightBarButtonItem:rightBar animated:YES];
	[rightBar release];
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:
                                            [NSIndexPath indexPathForRow:0 inSection:0]] 
                          withRowAnimation:UITableViewRowAnimationFade];
}

- (void)doneAction:(id)sender
{
	[self.tableView setEditing:!self.tableView.editing animated:YES];

    [GTHelper saveGroupList:dataArray];

	UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
																			  target:self
																			  action:@selector(editAction:)];
	[self.navigationItem setRightBarButtonItem:rightBar animated:YES];
	[rightBar release];
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:
                                            [NSIndexPath indexPathForRow:0 inSection:0]] 
                          withRowAnimation:UITableViewRowAnimationFade];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [dataArray count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            //cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
    }
    // Configure the cell...

    if (0 == indexPath.row)
    {
        if ([self.tableView isEditing]) {
            cell.textLabel.text = NSLocalizedString(@"GT_Group_Add", );
        }
        else {
            cell.textLabel.text = NSLocalizedString(@"GT_Group_All", );
        }
    }
    else {
        cell.textLabel.text = [dataArray objectAtIndex:indexPath.row - 1];
    }

    
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (0 == indexPath.row) {
		return UITableViewCellEditingStyleInsert;
	}
	return UITableViewCellEditingStyleDelete;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndex = indexPath.row;
    
    // Navigation logic may go here. Create and push another view controller.
    if ([self.tableView isEditing]) {
        GTTextFieldViewController *detailViewController = [[GTTextFieldViewController alloc] init];
        
        detailViewController.delegate = self;
        
        if (0 == indexPath.row) {
            detailViewController.title = NSLocalizedString(@"GT_Group_New", );
        }
        else {
            detailViewController.title = NSLocalizedString(@"GT_Group_Modify", );
            [detailViewController groupName:[dataArray objectAtIndex:indexPath.row - 1]];
        }
        
        [self.navigationController pushViewController:detailViewController animated:YES];
        [detailViewController release];
    }
    else {
        [self showTrackAtIndex:indexPath.row withAnimation:YES];
    }
}

-(void)didInputTextField:(NSString *)text rootController:(UIViewController *)ctrl
{
    if (0 == selectedIndex) {
        [dataArray addObject:text];
        [self.tableView reloadData];
    }
    else {
        [dataArray replaceObjectAtIndex:selectedIndex - 1 withObject:text];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:selectedIndex inSection:0]]
                              withRowAnimation:UITableViewRowAnimationFade];
    }    
}

@end
