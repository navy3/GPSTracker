//
//  SNFileObject.m
//  SmartNote
//
//  Created by navy on 12-4-18.
//  Copyright 2012 freelancer. All rights reserved.
//

#import "SNFileObject.h"

static SNFileObject *snFile = nil;

@implementation SNFileObject

+ (SNFileObject *)sharedInstance
{
	if (!snFile) {
		snFile = [[[self class] alloc] init];
	}
	return snFile;
}

- (id)init
{
	if (self = [super init]) {
		[self createDir];
	}
	return self;
}

- (void)createDir
{
	//create path
	NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
	//初始化图片文件路径
	NSString *imgPath = [path stringByAppendingPathComponent:@"Images"];
	//初始化涂鸦文件路径
	NSString *paintPath = [path stringByAppendingPathComponent:@"Paints"];
	//初始化录音文件路径
	NSString *recordPath = [path stringByAppendingPathComponent:@"Records"];

	if (![[NSFileManager defaultManager] fileExistsAtPath:imgPath]) {
		[[NSFileManager defaultManager] createDirectoryAtPath:imgPath withIntermediateDirectories:YES attributes:nil error:nil];
	}
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:paintPath]) {
		[[NSFileManager defaultManager] createDirectoryAtPath:paintPath withIntermediateDirectories:YES attributes:nil error:nil];
	}
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:recordPath]) {
		[[NSFileManager defaultManager] createDirectoryAtPath:recordPath withIntermediateDirectories:YES attributes:nil error:nil];
	}
}

- (NSString *) dir:(int)type
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *dir;
	switch (type) {
		case SNImageDir:
			dir = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Images"];
			break;
		case SNPaintDir:
			dir = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Paints"];
			break;
		case SNRecordDir:
			dir = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Records"];
	}
	return dir;
}

- (NSString *)saveImage:(UIImage *)img
{
	NSString *path = [[self dir:SNImageDir] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",[NSDate date]]];
	
	if([[NSFileManager defaultManager] createFileAtPath:path contents:UIImagePNGRepresentation(img) attributes:nil])
		return path;
	else 
		return nil;
}

- (NSString *)savePaint:(UIImage *)img
{
	NSString *path = [[self dir:SNPaintDir] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",[NSDate date]]];
	
	if([[NSFileManager defaultManager] createFileAtPath:path contents:UIImagePNGRepresentation(img) attributes:nil])
		return path;
	else 
		return nil;
}

@end
