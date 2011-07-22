//
//  RootViewController.h
//  AudioRecordingTest3
//
//  Created by Akash Krishnan on 7/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "MBProgressHUD.h"

@interface RootViewController : UITableViewController <UIAlertViewDelegate, AVAudioRecorderDelegate, MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    
    IBOutlet UIBarButtonItem *recordAudioButton;
    
    UIBarButtonItem *recordAudioActivityButton;
    UIActivityIndicatorView *recordAudioActivitySpinner;
    
    bool recordAudioToggle;
    NSURL *recordedAudioTmpFile;
    AVAudioRecorder *audioRecorder;
    NSError *recordAudioError;
    
    NSMutableArray *mobject;
    
    bool loggedIn;
    NSString *username;
    NSString *nickname;
    NSString *encPassword;
}

@property (nonatomic, retain) UIBarButtonItem *recordAudioButton;

-(IBAction)recordAudioButtonPressed:(id)sender;

@end
