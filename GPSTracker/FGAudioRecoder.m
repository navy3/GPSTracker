//
//  FGAudioRecoder.m
//  FreeGo
//
//  Created by navy on 11-12-21.
//  Copyright 2011 freelancer. All rights reserved.
//

#import "FGAudioRecoder.h"

static FGAudioRecoder *sharedAudio = NULL;

@implementation FGAudioRecoder

@synthesize recorder,player;

+ (id)sharedWTAudio
{
	if (!sharedAudio) {
		sharedAudio = [[FGAudioRecoder alloc] init];
	}
	return sharedAudio;
}

- (id)init
{
	if (self = [super init]) {
		
	}
	return self;
}

- (void)initRecord:(NSString *)path
{
	if (recorder) {
		[recorder release];
		recorder = nil;
	}
	
	NSURL *url = [NSURL fileURLWithPath:path];
	
	NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
							  [NSNumber numberWithFloat: 16000.0],                 AVSampleRateKey,
							  [NSNumber numberWithInt: kAudioFormatAppleIMA4],     AVFormatIDKey,
							  [NSNumber numberWithInt: 1],                         AVNumberOfChannelsKey,
							  //[NSNumber numberWithInt: AVAudioQualityMedium],      AVEncoderAudioQualityKey, 
							  nil];
	
	NSError *error = nil;
	
	recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
	recorder.meteringEnabled = YES;
}

- (void)startRecord
{
	if ([recorder prepareToRecord] == YES){
		[recorder record];
	}
}

- (float)currentRecordVolume
{
	float volume;
	if (recorder) {
		volume =1.0f  +  [recorder averagePowerForChannel:0]/100.0f;
		if (0 > volume) {
			volume  = 0;
		}
	}
	return volume;
}

- (void)stopRecord
{
	if (recorder) {
		[recorder stop];
	}
}

- (void)startPlay:(NSString *)path
{
	if (player) {
		[player release];
		player = nil;
	}
	
	NSURL  *url = [NSURL fileURLWithPath:path];
    NSError  *error;
    player  = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    player.numberOfLoops  = 0;
    if  (player == nil)
        NSLog(@"%@",[error  description]);
    else
		[player  play];
}

- (void)stopPlay
{
	if (player) {
		if ([player isPlaying]) {
			[player stop];
		}
	}
}

- (void)dealloc
{
	[recorder release];
	[player release];
	[super dealloc];
}

@end
