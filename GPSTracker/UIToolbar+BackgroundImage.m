//
//  UIToolbar.m
//  PhotoShare
//
//  Created by  on 12-7-13.
//  Copyright (c) 2012年 freelancer. All rights reserved.
//

#import "UIToolbar+BackgroundImage.h"

@implementation UIToolbar (BackgroundImage)

- (void)drawRect:(CGRect)rect 
{
    UIImage *img1 = [UIImage imageNamed: @"navigationbar.png"];
    UIImage* img2 = [img1 stretchableImageWithLeftCapWidth:4 topCapHeight:0.0];
    [img2 drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self setTintColor:nil];
}

+ (void) iOS5UIToolbarBackgroundImage
{
    if ([UIToolbar respondsToSelector: @selector(appearance)])
    {
        UIImage *img1 = [UIImage imageNamed: @"navigationbar.png"];
        UIImage* img2 = [img1 stretchableImageWithLeftCapWidth:4 topCapHeight:0.0];
        [[UIToolbar appearance] setBackgroundImage:img2 forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
        [[UIToolbar appearance] setTintColor:nil];
    }
}

@end

