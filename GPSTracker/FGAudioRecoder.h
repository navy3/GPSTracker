//
//  FGAudioRecoder.h
//  FreeGo
//
//  Created by navy on 11-12-21.
//  Copyright 2011 freelancer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface FGAudioRecoder : NSObject {
	AVAudioRecorder *recorder;
	AVAudioPlayer	*player;
}

@property (nonatomic, retain) AVAudioRecorder *recorder;
@property (nonatomic, retain) AVAudioPlayer *player;

+ (id)sharedWTAudio;
- (void)initRecord:(NSString *)path;

- (void)startRecord;
- (void)stopRecord;

- (float)currentRecordVolume;

- (void)startPlay:(NSString *)path;
- (void)stopPlay;

@end