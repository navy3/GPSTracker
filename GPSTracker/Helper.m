//
//  Helper.m
//  FreeGo
//
//  Created by navy on 11-12-21.
//  Copyright 2011 freelancer. All rights reserved.
//

#import "Helper.h"
#import "Reachability.h"

@implementation Helper

+(UIWindow*) getMainWindow{
    return [[UIApplication sharedApplication] keyWindow];
}

+ (BOOL)checkNewWork
{
	BOOL flag = YES;
	
	Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
	NetworkStatus status = [reach currentReachabilityStatus];
	
	switch (status) {
		case NotReachable:
		{
			flag = NO;
            
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
															message:NSLocalizedString(@"GT_Alert_NO_Network",) 
														   delegate:nil 
												  cancelButtonTitle:NSLocalizedString(@"GT_Alert_OK",) 
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
			break;
		default:
			break;
	}
	return flag;
}

+ (NSString *)documentPath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
	return basePath;
}

+ (NSString *)pathForDocumentFile:(NSString *)fileName
{
	NSString * documentPath = [Helper documentPath];
	return [NSString stringWithFormat:@"%@/%@", documentPath, fileName];
}

+ (NSString *)pathForTempFile:(NSString *)fileName
{
	return [NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), fileName];
}

+ (NSString *)pathForBundleResource:(NSString *)name ofType:(NSString *)type
{
	return [[NSBundle mainBundle] pathForResource:name ofType:type];
}

#pragma mark  -
#pragma mark operations about date and string

+ (NSString *) getStringFromTimeInterval:(NSTimeInterval)t
{
	NSDateFormatter *dateFormatter  = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] autorelease]];
	[dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
	//设置显示样式
	[dateFormatter setDateFormat:@"YYYY年M月d日EEEE"];
	NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:t];
	
	NSString *str = [dateFormatter stringFromDate:date];
	return str;
}

+ (NSString *) getDetailStringFromTimeInterval:(NSTimeInterval)t
{
	NSDateFormatter *dateFormatter  = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] autorelease]];
	[dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
	//设置显示样式
	[dateFormatter setDateFormat:@"YYYY年M月d日EEEE HH:mm:ss"];
	NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:t];
	
	NSString *str = [dateFormatter stringFromDate:date];
	return str;
}

+ (NSString *) getStringByDateTime:(NSDate *)nsDate{
	NSDateFormatter * dateFormatter = [[[NSDateFormatter alloc] init]autorelease];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss EEEE"];
	NSString * stringDate = [dateFormatter stringFromDate:nsDate];
	return stringDate;
}

+ (NSString *) getStringByDateTime:(NSDate *)nsDate withFormat:(NSString*)format{
	NSDateFormatter * dateFormatter = [[[NSDateFormatter alloc] init]autorelease];
	[dateFormatter setDateFormat:format];
	NSString * stringDate = [dateFormatter stringFromDate:nsDate];
	return stringDate;
}

+ (NSString *) getStringByFormatDateTimeString:(NSString *)strDate  withFormat:(NSString*)format{
	NSDate * temp	= [Helper getDateTimeByString:strDate];
	return [Helper getStringByDateTime:temp withFormat:@"yyyy-MM-dd"];
}

+ (NSDate *) getDateTimeByString:(NSString *)strDate{
	NSDateFormatter * dateFormatter = [[[NSDateFormatter alloc] init]autorelease];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSDate * nsDate = [dateFormatter dateFromString:strDate];
	return nsDate;
}

+ (NSDate *) getDateTimeByString:(NSString *)strDate withFormat:(NSString*)format {
	NSDateFormatter * dateFormatter = [[[NSDateFormatter alloc] init]autorelease];
	[dateFormatter setDateFormat:format];
	NSDate * nsDate = [dateFormatter dateFromString:strDate];
	return nsDate;
}

+ (NSString *) getYearStringByDateTime:(NSDate *)nsDate{
	NSDateFormatter * dateFormatter = [[[NSDateFormatter alloc] init]autorelease];
	[dateFormatter setDateFormat:@"YY-MM-dd"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
	NSString * stringDate = [dateFormatter stringFromDate:nsDate];
	return stringDate;	
}

+ (NSString *) getYearMonthStringByDateTime:(NSDate *)nsDate{
	NSDateFormatter * dateFormatter = [[[NSDateFormatter alloc] init]autorelease];
	[dateFormatter setDateFormat:@"yyyy-MM"];
	NSString * stringDate = [dateFormatter stringFromDate:nsDate];
	return stringDate;	
}

+ (NSString *) getYearStringByDateString:(NSString *)strDate{
	NSDateFormatter * dateFormatter = [[[NSDateFormatter alloc] init]autorelease];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSDate * nsDate = [dateFormatter dateFromString:strDate];
	
	NSDateFormatter * dateYearFormatter = [[[NSDateFormatter alloc] init]autorelease];
	[dateYearFormatter setDateFormat:@"yyyy-MM-dd"];
	NSString * stringDate = [dateYearFormatter stringFromDate:nsDate];
	return stringDate;
}

+ (void) updateYearStringForDateString:(NSMutableString *)strTargetString replaceSourceString:(NSString *)strReplaceSource{
	[strTargetString replaceCharactersInRange:NSMakeRange(0, 10) withString:strReplaceSource];
}

+ (NSString *) stringFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
{
	unsigned int unitFlags = NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
	NSCalendar * cal = [NSCalendar currentCalendar];
	NSDateComponents * comp = [cal components:unitFlags fromDate:fromDate toDate:toDate options:0];
	if( [comp day] )
	{
		switch ([comp day]) {
			case 1:
				return NSLocalizedString(@"common_yesterday", nil);
			case 2:
				return NSLocalizedString(@"common_2days_ago", nil);
			default:
			{
				unsigned int fullunitFlags = NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit;
				NSDateComponents * fullcomp = [cal components:fullunitFlags fromDate:fromDate];
				return [NSString stringWithFormat:@"%02d-%02d-%02d", [fullcomp year] % 100, [fullcomp month], [fullcomp day]];
			}
		}
	}
	else if( [comp hour] )
		return [NSString stringWithFormat:@"%d%@", [comp hour], NSLocalizedString(@"common_hours_ago", nil)];
	else if( [comp minute] )
		return [NSString stringWithFormat:@"%d%@", [comp minute], NSLocalizedString(@"common_minutes_ago", nil)];
	else 
		return [NSString stringWithFormat:@"%d%@", [comp second], NSLocalizedString(@"common_seconds_ago", nil)];	
}

+ (NSString *) stringFromDuration:(NSInteger) duration
{
	int iLeft = 0;
	int iHour = duration/3600;
	iLeft = duration%3600;
	int iMin = iLeft/60;
	iLeft = iLeft % 60;
	
	if( duration > 3600 )
		return [NSString stringWithFormat:@"%d%@", iHour, NSLocalizedString(@"common_hour", nil)];
	else if ( duration > 60 )
		return [NSString stringWithFormat:@"%d%@", iMin, NSLocalizedString(@"common_mintues", nil)];
	else
		return [NSString stringWithFormat:@"%d%@", iLeft, NSLocalizedString(@"common_second", nil)];
}

@end
