//
//  ViewController.m
//  SoundManager
//
//  Created by Micha Faw on 1/19/16.
//  Copyright © 2016 Micha Faw. All rights reserved.
//

#import "ViewController.h"
#import "MFSoundManager.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize soundManager, soundFileList, playStopButton, fileNameLabel, filePickerView;


-(void)viewDidLoad {
    [super viewDidLoad];
    
    // Grab an instance of the MFSoundManager singleton
    soundManager = [MFSoundManager sharedManager];
    soundFileList = [[NSBundle mainBundle] pathsForResourcesOfType:nil inDirectory:@"Sounds"];
    currentSelection = 0;
    [self updatePlayInformation];
}


-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)playStopButtonPressed:(UIButton *)sender {
    
    NSString *soundFileLocation = [soundFileList objectAtIndex:currentSelection];
    if([soundManager isSoundFileFromFileLocationPlaying:soundFileLocation]) {
        [soundManager stopSoundFilesFromFileLocation:soundFileLocation];
    } else {
        AVAudioPlayer *audioPlayer = [soundManager playSoundFileFromFileLocation:soundFileLocation];
        audioPlayer.delegate = self;
    }
    [self updatePlayInformation];
    
}


// Returns the number of 'columns' to display in UIPickerView.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// Returns the number of rows in UIPickerView
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [soundFileList count];
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return [[soundFileList objectAtIndex:row] lastPathComponent];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    currentSelection = row;
    [self updatePlayInformation];
    
}


-(void)updatePlayInformation {
    
    // Set button text to Play or Stop
    if([soundManager isSoundFileFromFileLocationPlaying:[soundFileList objectAtIndex:currentSelection]]) {
        [playStopButton setTitle:@"Stop" forState:UIControlStateNormal];
        [playStopButton setTitle:@"Stop" forState:UIControlStateSelected];
        [playStopButton setTitle:@"Stop" forState:UIControlStateHighlighted];
    } else {
        [playStopButton setTitle:@"Play" forState:UIControlStateNormal];
        [playStopButton setTitle:@"Play" forState:UIControlStateSelected];
        [playStopButton setTitle:@"Play" forState:UIControlStateHighlighted];
    }
    
    [playStopButton setNeedsDisplay];
    
    // Update "Current Selection" label text
    fileNameLabel.text = [[soundFileList objectAtIndex:currentSelection] lastPathComponent];
    
}


// Delegate Methods for AVAudioPlayer
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)audioPlayer successfully:(BOOL)completed {
    
    NSURL *filePathURL = [audioPlayer url];
    if (completed == YES) {
        NSLog(@"audioPlayerDidFinishPlaying successfully. (%@)", [filePathURL lastPathComponent]);
    } else {
        NSLog(@"audioPlayerDidFinishPlaying but did not complete successfully. (%@)", [filePathURL lastPathComponent]);
    }
    
    // Remove the audioPlayer from the soundManager so it will be released properly
    [soundManager stopSoundFilesFromURL:filePathURL];
    
    // Update Play/Stop button
    [self updatePlayInformation];
}

@end
