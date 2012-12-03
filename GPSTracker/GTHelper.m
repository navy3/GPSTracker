//
//  GTHelper.m
//  GPSTracker
//
//  Created by  on 12-7-6.
//  Copyright (c) 2012年 freelancer. All rights reserved.
//

#import "GTHelper.h"

@implementation GTHelper

+ (void)registerAllDefaults
{
	NSDictionary *defaultValues = [NSDictionary dictionaryWithObjectsAndKeys:
                                   nil];
	
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
	[[NSUserDefaults standardUserDefaults] synchronize];
}


+ (void)saveGroupList:(NSArray *)arr
{
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:kGroupListName];
	[arr writeToFile:path atomically:YES];
}

+ (NSArray *)groupList
{
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:kGroupListName];
	NSArray *arr = [[NSArray alloc] initWithContentsOfFile:path];
	return [arr autorelease];
}


+ (UIImage *)imageWithType:(int)type
{
    UIImage *img;
    switch (type) {
        case GT_Text:
            img = [UIImage imageNamed:@"text_type.png"];
            break;
        case GT_Image:
            img = [UIImage imageNamed:@"image_type.png"];
            break;
        case GT_Record:
            img = [UIImage imageNamed:@"record_type.png"];
            break;
    }
    return img;
}

@end
