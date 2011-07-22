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


@interface AudioFileDetailViewController : UIViewController
{
    IBOutlet UILabel *filenameLabel;
    IBOutlet UILabel *recordDateLabel;
    IBOutlet UILabel *fileURLLabel;
    
    NSString *filename;
    NSString *recordDate;
    NSURL *fileURL;
    NSError *error;
    
    IBOutlet UIButton *playAudioFileButton;
}

@property (nonatomic, retain) UILabel *filenameLabel;
@property (nonatomic, retain) UILabel *recordDateLabel;
@property (nonatomic, retain) UILabel *fileURLLabel;

@property (nonatomic, retain) NSString *filename;
@property (nonatomic, retain) NSString *recordDate;
@property (nonatomic, retain) NSURL *fileURL;
@property (nonatomic, retain) NSError *error;

@property (nonatomic, retain) UIButton *playAudioFileButton;

-(IBAction)playAudioFileButtonPressed:(id)sender;

@end
