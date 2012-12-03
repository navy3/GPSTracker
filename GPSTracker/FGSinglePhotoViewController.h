//
//  FGSinglePhotoViewController.h
//  FreeGo
//
//  Created by navy on 11-11-15.
//  Copyright 2011 freelancer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TapDetectingImageView.h"

@protocol FGPhotoDelegate; 

@interface FGSinglePhotoViewController : UIViewController<UIScrollViewDelegate, TapDetectingImageViewDelegate> {
	UIScrollView *imageScrollView;
	UIImageView *imageView;
    id<FGPhotoDelegate> delegate;
}
@property (nonatomic, assign) id<FGPhotoDelegate> delegate;
@property (nonatomic, retain) UIImageView *imageView;

- (id)initWithImage:(UIImage *)img;

@end

@protocol FGPhotoDelegate <NSObject>

- (void)addToCover;

@end