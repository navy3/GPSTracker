//
//  SNFileObject.h
//  SmartNote
//
//  Created by navy on 12-4-18.
//  Copyright 2012 freelancer. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	SNImageDir = 1,
	SNPaintDir = 2,
	SNRecordDir =3,
}SNDirTypes;

@interface SNFileObject : NSObject {

}

+ (SNFileObject *)sharedInstance;

- (void)createDir;
- (NSString *) dir:(int)type;

- (NSString *)saveImage:(UIImage *)img;
- (NSString *)savePaint:(UIImage *)img;

@end
