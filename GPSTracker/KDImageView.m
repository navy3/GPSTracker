//
//  KDImageView.h
/*
 
 Copyright 2011 Kyr Dunenkoff
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "KDImageView.h"

@implementation KDImageView

@synthesize imageUrl = _imageUrl;
@synthesize delegate = _delegate;

- (id)initWithURL:(NSURL *)url {
    self = [super init];
    if (self) {
        [self setURL:url];
    }
    return self;
}

- (void)setURL:(NSURL *)url {
    if (url == nil) {
        // Consider loading was canceled
        _isCanceled = YES;
        self.image = nil;
        _imageUrl = nil;
        return;
    }
    
    _isCanceled = NO;
    
    // No problem creating queue for loading image every time,
    // I doubt it will create concurrency problems
    _imgLoad = dispatch_queue_create("KDImageViewLoadImage", NULL);
    
    dispatch_async(_imgLoad, ^{
        
        NSURLRequest *req = [NSURLRequest requestWithURL:url];
        NSURLResponse __autoreleasing *response = nil;
        NSError __autoreleasing *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&error];
        
        // If there's data, no error and image setting hasn't been canceled
        if (data != nil && error == nil && !_isCanceled) {
            
            // All UI operations should run on main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                
                // In case we created imageView with CGRectZero,
                // that's default behavior for imageView -
                // set size to that of given image.
                if (self.frame.size.width == 0 || self.frame.size.width == 0) {
                    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, _img.size.width, _img.size.height);
                }
                
                self.image = [UIImage imageWithData:data];
                
                // Send message to delegate that we finished loading this image successfully.
                // Let's assume that delegate will use this message to update UI, 
                // so we're sending it in main thread also
                if ([_delegate respondsToSelector:@selector(imageView:finishedLoadingWithImage:)]) {
                    [_delegate imageView:self finishedLoadingWithImage:self.image];
                }

            });
            
        }
    });
}

@end
