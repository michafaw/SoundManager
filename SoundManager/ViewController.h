//
//  ViewController.h
//  SoundManager
//
//  Created by Micha Faw on 1/19/16.
//  Copyright © 2016 Micha Faw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFSoundManager.h"

@interface ViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, AVAudioPlayerDelegate> {
    
    MFSoundManager *soundManager;
    NSArray *soundFileList;
    NSInteger currentSelection;
}

@property (nonatomic, strong) MFSoundManager *soundManager;
@property (nonatomic, strong) NSArray *soundFileList;

@property (weak, nonatomic) IBOutlet UIButton *playStopButton;
@property (weak, nonatomic) IBOutlet UILabel *fileNameLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *filePickerView;

- (IBAction)playStopButtonPressed:(UIButton *)sender;

@end

