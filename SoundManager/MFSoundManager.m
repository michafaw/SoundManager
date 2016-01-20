//
//  MFSoundManager.m
//  SoundManager
//
//  Created by Micha Faw on 1/19/16.
//  Copyright © 2016 Micha Faw. All rights reserved.
//

#import "MFSoundManager.h"
#import "AVFoundation/AVFoundation.h"

@implementation MFSoundManager

@synthesize audioPlayers;

// Method for gettiing a MFSoundManager singleton instance
+(id)sharedManager {
    static MFSoundManager *sharedMFSoundManager = nil;
    @synchronized(self) {
        if (sharedMFSoundManager == nil)
            sharedMFSoundManager = [[self alloc] init];
    }
    return sharedMFSoundManager;
}


-(id)init {
    
    self = [super init];
    if(self) {
        // Initialize audioPlayers list (currently active AVAudioPlayer objects)
        audioPlayers = [[NSMutableArray alloc] init];
    }
    
    return self;
}


// Plays a sound located at a URL, returns the AVAudioPlayer object if the user wants more control
// Currently leaks the AVAudioPlayer object if the user sets their own delegate
-(AVAudioPlayer *)playSoundFileFromURL:(NSURL *)filePathURL {
    
    NSLog(@"playFile called with filePathURL: '%@'.", [filePathURL lastPathComponent]);
    
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:filePathURL error:nil];
    [audioPlayers addObject:audioPlayer];
    [audioPlayer play];
    
    // Register for AVAudioPlayerDelegate messages
    audioPlayer.delegate = [MFSoundManager sharedManager];
 
    return audioPlayer;
}


// Plays a sound located at file location string, returns the AVAudioPlayer object if the user wants more control
// IMPORTANT: The user must manually call one of the stopSoundFiles methods if they
//     set their own delegate. This is to ensure that the AVAudioPlayer is not caught in
//     a retain cycle.
-(AVAudioPlayer *)playSoundFileFromFileLocation:(NSString *)filePathString {

    AVAudioPlayer *audioPlayer = [self playSoundFileFromURL:[NSURL URLWithString:filePathString]];
    
    return audioPlayer;
}


// Check active AVAudioPlayer objects to see if one of them is playing the sound file
-(BOOL)isSoundFileFromURLPlaying:(NSURL *)filePathURL {

    for (AVAudioPlayer *audioPlayer in audioPlayers) {
        if([filePathURL isEqual:[audioPlayer url]])
            return YES;
    }
    
    return NO;
}


// Check active AVAudioPlayer objects to see if one of them is playing the sound file
-(BOOL)isSoundFileFromFileLocationPlaying:(NSString *)filePathString {
    
    return [self isSoundFileFromURLPlaying:[NSURL URLWithString:filePathString]];
}


// Stops all instances of the sound currently being played from the file specified
-(void)stopSoundFilesFromURL:(NSURL *)filePathURL {
    
    NSMutableArray *playersToRemove = [[NSMutableArray alloc] init];
    for(AVAudioPlayer *audioPlayer in audioPlayers) {
        if([[audioPlayer url] isEqual:filePathURL]) {
            [audioPlayer stop];
            [playersToRemove addObject:audioPlayer];
        }
    }
    
    for(AVAudioPlayer *audioPlayer in playersToRemove) {
        audioPlayer.delegate = nil;
        [audioPlayers removeObject:audioPlayer];
    }
    
}


// Stops all instances of the sound currently being played from the file specified
-(void)stopSoundFilesFromFileLocation:(NSString *)filePathString {
    
    [self stopSoundFilesFromURL:[NSURL URLWithString:filePathString]];
}



// Delegate Methods for AVAudioPlayer
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)audioPlayer successfully:(BOOL)completed {
    
    NSURL *filePathURL = [audioPlayer url];
    if (completed == YES) {
        NSLog(@"audioPlayerDidFinishPlaying successfully. (%@)", [filePathURL lastPathComponent]);
    } else {
        NSLog(@"audioPlayerDidFinishPlaying but did not complete successfully. (%@)", [filePathURL lastPathComponent]);
    }
    
    // Remove the audioPlayer from the audioPlayers list so it will be dealloc'd
    audioPlayer.delegate = nil;
    [audioPlayers removeObject:audioPlayer];
}

@end
