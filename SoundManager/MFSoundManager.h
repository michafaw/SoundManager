//
//  MFSoundManager.h
//  SoundManager
//
//  Created by Micha Faw on 1/19/16.
//  Copyright © 2016 Micha Faw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVFoundation/AVFoundation.h"

@interface MFSoundManager <AVAudioPlayerDelegate> : NSObject {
    NSMutableArray *audioPlayers;
}

@property (nonatomic, strong) NSMutableArray *audioPlayers;

// Singleton-related methods, using Matt Galloway's common naming scheme
// Use [MFSoundManager sharedManager] to get an instance of this class
+(id)sharedManager;


// Public-facing interface
-(AVAudioPlayer *)playSoundFileFromURL:(NSURL *)filePathURL;
-(AVAudioPlayer *)playSoundFileFromFileLocation:(NSString *)filePathString;

-(BOOL)isSoundFileFromURLPlaying:(NSURL *)filePathURL;
-(BOOL)isSoundFileFromFileLocationPlaying:(NSString *)filePathString;

-(void)stopSoundFilesFromURL:(NSURL *)filePathURL;
-(void)stopSoundFilesFromFileLocation:(NSString *)filePathString;

@end
