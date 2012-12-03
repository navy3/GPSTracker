//
//  FGTextFieldViewController.h
//  FreeGo
//
//  Created by navy on 11-11-5.
//  Copyright 2011 freelancer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FGTextFieldDelegate;

@interface FGTextFieldViewController : UIViewController<UITextFieldDelegate> {
	UITextField	*textField;
	id<FGTextFieldDelegate> delegate;
}

@property (nonatomic, assign) id<FGTextFieldDelegate> delegate;
@property (nonatomic, retain) UITextField *textField;

@end

@protocol FGTextFieldDelegate<NSObject>

@optional

-(void)didInputText:(NSString *)text rootController:(UIViewController *)ctrl;
@end