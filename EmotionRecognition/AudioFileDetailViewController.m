//
//  AudioFileDetailViewController.m
//  EmotionRecognition
//
//  Created by Akash Krishnan on 7/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AudioFileDetailViewController.h"
#import "AudioFile.h"

@implementation AudioFileDetailViewController

@synthesize filenameLabel;
@synthesize recordDateLabel;
@synthesize emotionLabel;
@synthesize angryLabel;
@synthesize fearfulLabel;
@synthesize happyLabel;
@synthesize sadLabel;

@synthesize af;

@synthesize analyzeAudioFileButton;
@synthesize submitCorrectionButton;
@synthesize playAudioFileButton;
@synthesize deleteAudioFileButton;

@synthesize rvc;

-(IBAction)analyzeAudioFileButtonPressed:(id)sender
{
    [AudioFile analyze:af.fileURL username:rvc.username password:rvc.encPassword];
    [analyzeAudioFileButton setEnabled:false];
}

-(IBAction)submitCorrectionButtonPressed:(id)sender
{
    
}

-(IBAction)playAudioFileButtonPressed:(id)sender
{
    NSError *error = af.error;
    AVAudioPlayer * avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:af.fileURL error:&error];
	[avPlayer prepareToPlay];
	[avPlayer play];
}

-(IBAction)deleteAudioFileButtonPressed:(id)sender
{
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [filenameLabel release];
    [recordDateLabel release];
    [emotionLabel release];
    [angryLabel release];
    [fearfulLabel release];
    [happyLabel release];
    [sadLabel release];
    
    [analyzeAudioFileButton release];
    [submitCorrectionButton release];
    [playAudioFileButton release];
    [deleteAudioFileButton release];
     
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
    
    filenameLabel.text = [NSString stringWithFormat:@"Filename: %@", af.filename];
    recordDateLabel.text = [NSString stringWithFormat:@"Recorded Date: %@", af.recordDate];
    emotionLabel.text = [NSString stringWithFormat:@"Emotion: %@", af.emotion];
    angryLabel.text = [NSString stringWithFormat:@"Angry: %@", af.angry];
    fearfulLabel.text = [NSString stringWithFormat:@"Fearful: %@", af.fearful];
    happyLabel.text = [NSString stringWithFormat:@"Happy: %@", af.happy];
    sadLabel.text = [NSString stringWithFormat:@"Sad: %@", af.sad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
