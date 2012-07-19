//
//  AppDelegate.m
//  GPSTracker
//
//  Created by  on 12-7-3.
//  Copyright (c) 2012年 freelancer. All rights reserved.
//

#import "AppDelegate.h"

#import "MasterViewController.h"

#import "DetailViewController.h"

#import "GTGroupListViewController.h"

#import "GTDBHelper.h"

#import "GTTrackDao.h"

#import "UINavigationBar+BackgroundImage.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize splitViewController = _splitViewController;

- (void)dealloc
{
    [_window release];
    [_navigationController release];
    [_splitViewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    {
//        NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
//
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        NSArray *bundleDirectory = [fileManager contentsOfDirectoryAtPath:bundlePath error:nil];
//
//        NSPredicate *filter = [NSPredicate predicateWithFormat:@"self ENDSWITH '.png'"];
//        NSArray *pngFiles = [bundleDirectory filteredArrayUsingPredicate:filter];
//
//        NSArray *filesURLs = [[NSBundle mainBundle] URLsForResourcesWithExtension:@"png" subdirectory:nil];
//
//        NSLog(@"PNG files: %@ %@", pngFiles,filesURLs);
//        
//        // Using the application home directory, get dictionary of attributes
//        NSDictionary *attributesDict = [fileManager attributesOfFileSystemForPath:NSHomeDirectory() error:NULL];
//        
//        // Print total file system size and available space  
//        NSLog(@"File system size: %lld", [[attributesDict objectForKey:NSFileSystemSize] longLongValue]);
//        NSLog(@"File system free space: %lld", [[attributesDict objectForKey:NSFileSystemFreeSize] longLongValue]);
//    }
    
    [[GTDBHelper defaultHelper] createCommonDBTables];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        GTGroupListViewController *masterViewController = [[[GTGroupListViewController alloc] init] autorelease];
        self.navigationController = [[[UINavigationController alloc] initWithRootViewController:masterViewController] autorelease];
        [UINavigationBar iOS5UINavigationBarBackgroundImage];
        self.navigationController.navigationBar.tintColor = NAVBAR_TINTCOLOR;
        self.window.rootViewController = self.navigationController;
        [masterViewController showTrackAtIndex:0 withAnimation:NO];
    } else {
        MasterViewController *masterViewController = [[[MasterViewController alloc] initWithNibName:@"MasterViewController_iPad" bundle:nil] autorelease];
        UINavigationController *masterNavigationController = [[[UINavigationController alloc] initWithRootViewController:masterViewController] autorelease];
        
        DetailViewController *detailViewController = [[[DetailViewController alloc] initWithNibName:@"DetailViewController_iPad" bundle:nil] autorelease];
        UINavigationController *detailNavigationController = [[[UINavigationController alloc] initWithRootViewController:detailViewController] autorelease];
    	
    	masterViewController.detailViewController = detailViewController;
    	
        self.splitViewController = [[[UISplitViewController alloc] init] autorelease];
        self.splitViewController.delegate = detailViewController;
        self.splitViewController.viewControllers = [NSArray arrayWithObjects:masterNavigationController, detailNavigationController, nil];
        
        self.window.rootViewController = self.splitViewController;
    }
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
