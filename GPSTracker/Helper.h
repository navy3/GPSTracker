//
//  Helper.h
//  FreeGo
//
//  Created by navy on 11-12-21.
//  Copyright 2011 freelancer. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Helper : NSObject {

}

+(UIWindow*) getMainWindow;

//network
+ (BOOL)checkNewWork;

//paths
+ (NSString *)documentPath;
+ (NSString *)pathForDocumentFile:(NSString *)fileName;
+ (NSString *)pathForTempFile:(NSString *)fileName;
+ (NSString *)pathForBundleResource:(NSString *)name ofType:(NSString *)type;

// format "yyyy-MM-dd HH:MM:SS"
+ (NSString *) getStringByDateTime:(NSDate *)nsDate;
+ (NSString *) getStringByDateTime:(NSDate *)nsDate withFormat:(NSString*)format;
//format "yyyy-MM-dd HH:MM:SS"
+ (NSDate *) getDateTimeByString:(NSString *)strDate;
+ (NSDate *) getDateTimeByString:(NSString *)strDate withFormat:(NSString*)format;
//format "yyyy-MM-dd HH:MM:SS"
+ (NSString *) getStringByFormatDateTimeString:(NSString *)strDate  withFormat:(NSString*)format;
//format "yyyy-MM-dd"
+ (NSString *) getYearStringByDateTime:(NSDate *)nsDate;
//format "yyyy-MM-dd"
+ (NSString *) getYearMonthStringByDateTime:(NSDate *)nsDate;
+ (NSString *) getYearStringByDateString:(NSString *)strDate;


+ (NSString *) getStringFromTimeInterval:(NSTimeInterval)t;
+ (NSString *) getDetailStringFromTimeInterval:(NSTimeInterval)t;

+ (void) updateYearStringForDateString:(NSMutableString *)strTargetString replaceSourceString:(NSString *)strReplaceSource;
+ (NSString *) stringFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;
+ (NSString *) stringFromDuration:(NSInteger) duration;

@end
