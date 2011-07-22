//
//  AudioRecordingTest1ViewController.m
//  AudioRecordingTest1
//
//  Created by Akash Krishnan on 7/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AudioRecordingTest1ViewController.h"

@implementation AudioRecordingTest1ViewController

@synthesize recordAudioButton;
@synthesize playRecordedAudioButton;
@synthesize recordAudioActivitySpinner;

-(IBAction)recordAudioButtonPressed:(id)sender
{
    if(!recordAudioToggle)
    {
        UIAlertView *recordAudioAlertView = [[UIAlertView alloc] initWithTitle:@"Record Audio"
                                                                       message:@"You are about to record audio. Would you like to proceed?"
                                                                      delegate:self
                                                             cancelButtonTitle:@"No"
                                                             otherButtonTitles:@"Yes", nil];
        recordAudioAlertView.tag = 1;
        [recordAudioAlertView show];
        [recordAudioAlertView release];
    }
    else
    {
        // Stop recording now
        
        recordAudioToggle = false;
        [playRecordedAudioButton setEnabled:true];
        [recordAudioButton setTitle:@"Record Audio" forState:UIControlStateNormal];
        [recordAudioActivitySpinner stopAnimating];
        
        [audioRecorder stop];
    }
}

-(IBAction)playRecordedAudioButtonPressed:(id)sender
{
    AVAudioPlayer * avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:recordedAudioTmpFile error:&recordAudioError];
	[avPlayer prepareToPlay];
	[avPlayer play];
}

-(void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch(actionSheet.tag)
    {
        case 1:
        {
            if(buttonIndex == 1)
            {
                // start recording audio now
                
                recordAudioToggle = true;
                [playRecordedAudioButton setEnabled:false];
                [recordAudioButton setTitle:@"Stop Recording" forState:UIControlStateNormal];
                [recordAudioActivitySpinner startAnimating];
                
                NSMutableDictionary *recordAudioSettings = [[NSMutableDictionary alloc] init];
                [recordAudioSettings setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
                [recordAudioSettings setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
                [recordAudioSettings setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
                
                recordedAudioTmpFile = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%.0f.%@", [NSDate timeIntervalSinceReferenceDate] * 1000.0, @"caf"]]];
                
                audioRecorder = [[AVAudioRecorder alloc] initWithURL:recordedAudioTmpFile settings:recordAudioSettings error:&recordAudioError];
                [audioRecorder setDelegate:self];
                [audioRecorder prepareToRecord];
                [audioRecorder record];
                
                // In order to record for set interval, use following:
                //[recorder recordForDuration:(NSTimeInterval) 10];
            }
        }
    }
}

- (void)dealloc
{
    [recordAudioButton release];
    [playRecordedAudioButton release];
    [recordAudioActivitySpinner release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    recordAudioToggle = false;
    [playRecordedAudioButton setEnabled:false];
    [recordAudioActivitySpinner setHidesWhenStopped:true];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&recordAudioError];
    [audioSession setActive:true error:&recordAudioError];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    recordAudioToggle = false;
    [playRecordedAudioButton setEnabled:false];
    
    NSFileManager *fm = [NSFileManager defaultManager];
	[fm removeItemAtPath:[recordedAudioTmpFile path] error:&recordAudioError];
    recordedAudioTmpFile = nil;
	[fm dealloc];
    
	[audioRecorder dealloc];
    audioRecorder = nil;
    recordAudioError = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
