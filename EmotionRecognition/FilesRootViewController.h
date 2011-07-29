//
//  FilesRootViewController.h
//  EmotionRecognition
//
//  Created by Akash Krishnan on 7/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@interface FilesRootViewController : UITableViewController <UIAlertViewDelegate, AVAudioRecorderDelegate>
{
    IBOutlet UINavigationBar *recordNavBar;
    IBOutlet UIButton *recordAudioButton;
    
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

@property (nonatomic, retain) UINavigationBar *recordNavBar;
@property (nonatomic, retain) UIButton *recordAudioButton;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *nickname;
@property (nonatomic, retain) NSString *encPassword;


-(IBAction)recordAudioButtonPressed:(id)sender;
-(void)updateRecordedFilesList;
-(void)checkForNewAlerts;
-(void)checkForUpdates;

@end
