//
//  AudioRecordingTest1ViewController.h
//  AudioRecordingTest1
//
//  Created by Akash Krishnan on 7/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@interface AudioRecordingTest1ViewController : UIViewController <UIAlertViewDelegate, AVAudioRecorderDelegate>
{
    IBOutlet UIButton *recordAudioButton;
    IBOutlet UIButton *playRecordedAudioButton;
    IBOutlet UIActivityIndicatorView *recordAudioActivitySpinner;
    bool recordAudioToggle;
    
    NSURL *recordedAudioTmpFile;
    AVAudioRecorder *audioRecorder;
    NSError *recordAudioError;
}

@property (nonatomic, retain) UIButton *recordAudioButton;
@property (nonatomic, retain) UIButton *playRecordedAudioButton;
@property (nonatomic, retain) UIActivityIndicatorView *recordAudioActivitySpinner;

-(IBAction)recordAudioButtonPressed:(id)sender;
-(IBAction)playRecordedAudioButtonPressed:(id)sender;

@end
