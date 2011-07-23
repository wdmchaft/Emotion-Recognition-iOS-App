//
//  AudioFileDetailViewController.h
//  AudioRecordingTest3
//
//  Created by Akash Krishnan on 7/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "AudioFile.h"
#import "RootViewController.h"

@interface AudioFileDetailViewController : UIViewController <UIAlertViewDelegate>
{
    IBOutlet UILabel *filenameLabel;
    IBOutlet UILabel *recordDateLabel;
    IBOutlet UILabel *emotionLabel;
    IBOutlet UILabel *angryLabel;
    IBOutlet UILabel *fearfulLabel;
    IBOutlet UILabel *happyLabel;
    IBOutlet UILabel *sadLabel;
    
    AudioFile *af;
    
    IBOutlet UIButton *analyzeAudioFileButton;
    IBOutlet UIButton *submitCorrectionButton;
    IBOutlet UIButton *playAudioFileButton;
    IBOutlet UIButton *deleteAudioFileButton;
    
    RootViewController *rvc;
}

@property (nonatomic, retain) UILabel *filenameLabel;
@property (nonatomic, retain) UILabel *recordDateLabel;
@property (nonatomic, retain) UILabel *emotionLabel;
@property (nonatomic, retain) UILabel *angryLabel;
@property (nonatomic, retain) UILabel *fearfulLabel;
@property (nonatomic, retain) UILabel *happyLabel;
@property (nonatomic, retain) UILabel *sadLabel;

@property (nonatomic, retain) AudioFile *af;

@property (nonatomic, retain) UIButton *analyzeAudioFileButton;
@property (nonatomic, retain) UIButton *submitCorrectionButton;
@property (nonatomic, retain) UIButton *playAudioFileButton;
@property (nonatomic, retain) UIButton *deleteAudioFileButton;

@property (nonatomic, retain) RootViewController *rvc;

-(IBAction)analyzeAudioFileButtonPressed:(id)sender;
-(IBAction)submitCorrectionButtonPressed:(id)sender;
-(IBAction)playAudioFileButtonPressed:(id)sender;
-(IBAction)deleteAudioFileButtonPressed:(id)sender;

@end
