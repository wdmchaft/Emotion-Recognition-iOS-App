//
//  RootViewController.h
//  AudioRecordingTest2
//
//  Created by Akash Krishnan on 7/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@interface RootViewController : UITableViewController <UIAlertViewDelegate, AVAudioRecorderDelegate>
{
    IBOutlet UIBarButtonItem *recordAudioButton;
    
    UIBarButtonItem *recordAudioActivityButton;
    UIActivityIndicatorView *recordAudioActivitySpinner;
    
    bool recordAudioToggle;
    
    NSURL *recordedAudioTmpFile;
    AVAudioRecorder *audioRecorder;
    NSError *recordAudioError;
    
    RecordedFilesDataController *recordedFilesDataController;
    UIView *myView;
}

@property (nonatomic, retain) UIBarButtonItem *recordAudioButton;
@property (nonatomic, retain) RecordedFilesDataController *recordedFilesDataController;
@property (nonatomic, retain) UIView *myView;

-(IBAction)recordAudioButtonPressed:(id)sender;

@end
