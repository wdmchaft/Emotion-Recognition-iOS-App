//
//  AudioFileDetailViewController.m
//  AudioRecordingTest3
//
//  Created by Akash Krishnan on 7/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AudioFileDetailViewController.h"


@implementation AudioFileDetailViewController

@synthesize filenameLabel;
@synthesize recordDateLabel;
@synthesize fileURLLabel;
@synthesize filename;
@synthesize recordDate;
@synthesize fileURL;
@synthesize playAudioFileButton;
@synthesize error;

-(IBAction)playAudioFileButtonPressed:(id)sender
{
    AVAudioPlayer * avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&error];
	[avPlayer prepareToPlay];
	[avPlayer play];
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
    [fileURLLabel release];
    [filename release];
    [recordDate release];
    [fileURL release];
    [error release];
    [playAudioFileButton release];
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
    
    filenameLabel.text = [NSString stringWithFormat:@"Filename: %@", filename];
    recordDateLabel.text = [NSString stringWithFormat:@"Recorded Date: %@", recordDate];
    fileURLLabel.text = [NSString stringWithFormat:@"File URL: %@", [fileURL absoluteString]];
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
