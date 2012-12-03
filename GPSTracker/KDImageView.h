//
//  KDImageView.h
//
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

#import <UIKit/UIKit.h>
#import "KDImageViewDelegate.h"

@interface KDImageView : UIImageView {
    UIImage *_img;
    dispatch_queue_t _imgLoad;
    BOOL _isCanceled;
}

@property (atomic, strong) NSURL *imageUrl;
@property (nonatomic, unsafe_unretained) id <KDImageViewDelegate> delegate;

- (id)initWithURL:(NSURL *)url;
- (void)setURL:(NSURL *)url;

@end