//
//  FGTextViewViewController.h
//  FreeGo
//
//  Created by navy on 11-11-6.
//  Copyright 2011 freelancer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FGTextViewDelegate;

@interface FGTextViewViewController : UIViewController {
	UITextView *textView;
	id<FGTextViewDelegate> delegate;
}
@property (nonatomic, assign) id<FGTextViewDelegate> delegate;
@property (nonatomic, retain) UITextView *textView;

@end

@protocol FGTextViewDelegate<NSObject>

- (void)didInputTextView:(NSString *)text rootController:(UIViewController *)ctrl;

@end