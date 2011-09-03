//
//  FilesViewController.m
//  EmotionRecognition
//
//  Created by Akash Krishnan on 7/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FilesViewController.h"
#import "AudioFile.h"
#import "AudioFileDetailViewController.h"
#import "OCPromptView.h"
#import "OCPasswordPromptView.h"
#import "ASIFormDataRequest.h"

@implementation FilesViewController

@synthesize recordAudioButton;
@synthesize recordNavigationController;
@synthesize username;
@synthesize nickname;
@synthesize encPassword;

-(IBAction)recordAudioButtonPressed:(id)sender
{
    if(!loggedIn)
    {
        OCPromptView *alert = [[OCPromptView alloc] initWithPrompt:@"Login: Username"
                                                           message:@"Enter Username:"
                                                          delegate:self
                                                 cancelButtonTitle:@"Register"
                                                 acceptButtonTitle:@"Next"];
        
        alert.tag = 4;
        [alert show];
        [alert release];
    }
    else
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
            [recordAudioButton setTitle:@" Record" forState:UIControlStateNormal];
            [recordNavigationController.navigationItem setTitle:@"Record Audio"];
            [recordAudioActivitySpinner stopAnimating];
            
            [audioRecorder stop];
            
            // Send new file to server
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://aakay.net/EmotionRecognition/iOS/?r=af&u=%@&p=%@&f=%@&l=%@", username, encPassword, @"Untitled+Audio+File", [[recordedAudioTmpFile absoluteString] stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"]]];
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
            [request startSynchronous];
            
            [self updateRecordedFilesList];
            
            // Send analyze file request
            UIAlertView *analyzeRecordedAudioAlertView = [[UIAlertView alloc] initWithTitle:@"Analyze Audio"
                                                                                    message:@"Audio has been recorded. Would you like to send the audio over to the processing server for analyzation now? If not, you may always analyze later."
                                                                                   delegate:self
                                                                          cancelButtonTitle:@"No"
                                                                          otherButtonTitles:@"Yes", nil];
            analyzeRecordedAudioAlertView.tag = 2;
            [analyzeRecordedAudioAlertView show];
            [analyzeRecordedAudioAlertView release];
        }
    }
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
                [recordAudioButton setTitle:@" Stop" forState:UIControlStateNormal];
                [recordNavigationController.navigationItem setTitle:@"Recording Audio..."];
                [recordAudioActivitySpinner startAnimating];
                
                NSMutableDictionary *recordAudioSettings = [[NSMutableDictionary alloc] init];
                [recordAudioSettings setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
                [recordAudioSettings setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
                [recordAudioSettings setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
                [recordAudioSettings setValue:[NSNumber numberWithInt:8] forKey:AVLinearPCMBitDepthKey];
                [recordAudioSettings setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
                [recordAudioSettings setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
                
                recordedAudioTmpFile = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%.0f.%@", [NSDate timeIntervalSinceReferenceDate] * 1000.0, @"caf"]]];
                
                audioRecorder = [[AVAudioRecorder alloc] initWithURL:recordedAudioTmpFile settings:recordAudioSettings error:&recordAudioError];
                [audioRecorder setDelegate:self];
                [audioRecorder prepareToRecord];
                [audioRecorder record];
                
                // In order to record for set interval, use following:
                //[recorder recordForDuration:(NSTimeInterval) 10];
            }
            break;
        }
        case 2:
        {
            if(buttonIndex == 1)
            {
                [AudioFile analyze:recordedAudioTmpFile username:username password:encPassword];
            }
            break;
        }
        case 3:
        {
            break;
        }
        case 4:
        {
            if(buttonIndex == 0)
            {
                OCPromptView *alert = [[OCPromptView alloc] initWithPrompt:@"Registration: New Username"
                                                                   message:@"Enter New Username:"
                                                                  delegate:self
                                                         cancelButtonTitle:@"Cancel"
                                                         acceptButtonTitle:@"Next"];
                alert.tag = 6;
                [alert show];
                [alert release];
            }
            else if(buttonIndex == 1)
            {
                username = [[(OCPromptView *)actionSheet enteredText] copy];
                OCPasswordPromptView *alert = [[OCPasswordPromptView alloc] initWithPrompt:@"Login: Password"
                                                                                   message:@"Enter Password:"
                                                                                  delegate:self
                                                                         cancelButtonTitle:@"Register"
                                                                         acceptButtonTitle:@"Login"];
                alert.tag = 5;
                [alert show];
                [alert release];
            }
            break;
        }
        case 5:
        {
            if(buttonIndex == 0)
            {
                OCPromptView *alert = [[OCPromptView alloc] initWithPrompt:@"Registration: New Username"
                                                                   message:@"Enter New Username:"
                                                                  delegate:self
                                                         cancelButtonTitle:@"Cancel"
                                                         acceptButtonTitle:@"Next"];
                alert.tag = 6;
                [alert show];
                [alert release];
            }
            else if(buttonIndex == 1)
            {
                encPassword = [[(OCPasswordPromptView *)actionSheet enteredText] copy];
                
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://aakay.net/EmotionRecognition/iOS/?r=l&u=%@&p=%@&d=2", username, encPassword]];
                ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
                [request startSynchronous];
                NSString *response = [request responseString];
                
                if([response isEqualToString:@"0"])
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Failure"
                                                                    message:@"Username/password combination is incorrect. Please try again."
                                                                   delegate:self
                                                          cancelButtonTitle:@"Close"
                                                          otherButtonTitles: nil];
                    [alert show];
                    [alert release];
                }
                else if([response isEqualToString:@"1"])
                {
                    loggedIn = true;
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Success"
                                                                    message:@"You have successfully logged in."
                                                                   delegate:self
                                                          cancelButtonTitle:@"Close"
                                                          otherButtonTitles: nil];
                    [alert show];
                    [alert release];
                    
                    [self updateRecordedFilesList];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Failure"
                                                                    message:@"An unknown error has occured. Please try again."
                                                                   delegate:self
                                                          cancelButtonTitle:@"Close"
                                                          otherButtonTitles: nil];
                    [alert show];
                    [alert release];
                }
            }
            break;
        }
        case 6:
        {
            if(buttonIndex == 1)
            {
                username = [[(OCPromptView *)actionSheet enteredText] copy];
                OCPasswordPromptView *alert = [[OCPasswordPromptView alloc] initWithPrompt:@"Registration: New Password"
                                                                                   message:@"Enter New Password:"
                                                                                  delegate:self
                                                                         cancelButtonTitle:@"Cancel"
                                                                         acceptButtonTitle:@"Register"];
                alert.tag = 7;
                [alert show];
                [alert release];
            }
            break;
        }
        case 7:
        {
            if(buttonIndex == 1)
            {
                encPassword = [[(OCPasswordPromptView *)actionSheet enteredText] copy];
                
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://aakay.net/EmotionRecognition/iOS/?r=r&u=%@&p=%@&d=2", username, encPassword]];
                ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
                [request startSynchronous];
                NSString *response = [request responseString];
                
                if([response isEqualToString:@"0"])
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration Failure"
                                                                    message:@"Username must be at least four (4) characters long."
                                                                   delegate:self
                                                          cancelButtonTitle:@"Close"
                                                          otherButtonTitles: nil];
                    [alert show];
                    [alert release];
                }
                else if([response isEqualToString:@"1"])
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration Failure"
                                                                    message:@"Password must be at least four (4) characters long."
                                                                   delegate:self
                                                          cancelButtonTitle:@"Close"
                                                          otherButtonTitles: nil];
                    [alert show];
                    [alert release];
                }
                else if([response isEqualToString:@"2"])
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration Failure"
                                                                    message:@"Username is already in use. Please choose another username."
                                                                   delegate:self
                                                          cancelButtonTitle:@"Close"
                                                          otherButtonTitles: nil];
                    [alert show];
                    [alert release];
                }
                else if([response isEqualToString:@"3"])
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration Success"
                                                                    message:@"You have successfully registered an account. You may now login with your new account."
                                                                   delegate:self
                                                          cancelButtonTitle:@"Close"
                                                          otherButtonTitles: nil];
                    [alert show];
                    [alert release];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration Failure"
                                                                    message:@"An unknown error has occured. Please try again."
                                                                   delegate:self
                                                          cancelButtonTitle:@"Close"
                                                          otherButtonTitles: nil];
                    [alert show];
                    [alert release];
                }
            }
            break;
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    recordAudioToggle = false;
    
    recordAudioActivitySpinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [recordAudioActivitySpinner setHidesWhenStopped:true];
    recordAudioActivityButton = [[UIBarButtonItem alloc] initWithCustomView:recordAudioActivitySpinner];
    recordNavigationController.navigationItem.leftBarButtonItem = recordAudioActivityButton;
    [recordAudioActivityButton release];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&recordAudioError];
    [audioSession setActive:true error:&recordAudioError];
    
	mobject = [[NSMutableArray alloc] init];
	
    loggedIn = false;
    username = nil;
    nickname = nil;
    encPassword = nil;
    
	self.navigationItem.title = @"Recorded Files";
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkForUpdates) userInfo:nil repeats:true];
    [timer fire];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mobject count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    
    AudioFile *af = [mobject objectAtIndex:indexPath.row];
	NSString *cellValue = [NSString stringWithFormat:@"%@ %@", af.recordDate, af.filename];
	[cell.textLabel setText:cellValue];
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AudioFile *af = [mobject objectAtIndex:indexPath.row];
    AudioFileDetailViewController *dvController = [[AudioFileDetailViewController alloc] initWithNibName:@"AudioFileDetailViewController" bundle:nil];
    dvController.af = af;
    dvController.username = username;
    dvController.encPassword = encPassword;
    [self.navigationController pushViewController:dvController animated:YES];
    [dvController release];
    dvController = nil;
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellAccessoryDisclosureIndicator;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    recordAudioToggle = false;
    
    [recordAudioActivitySpinner release];
    
    NSFileManager *fm = [NSFileManager defaultManager];
	[fm removeItemAtPath:[recordedAudioTmpFile path] error:&recordAudioError];
    recordedAudioTmpFile = nil;
	[fm dealloc];
    
	[audioRecorder dealloc];
    audioRecorder = nil;
    recordAudioError = nil;
}

-(void)updateRecordedFilesList
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://aakay.net/EmotionRecognition/iOS/?r=rf&u=%@&p=%@", username, encPassword]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request startSynchronous];
    NSString *response = [request responseString];
    NSArray *lines = [response componentsSeparatedByString:@"\n"];
    [mobject removeAllObjects];
    for(NSString *line in lines)
    {
        if(![line isEqualToString:@""] && ![line isEqualToString:@"0"])
        {
            NSArray *items = [line componentsSeparatedByString:@"\t"];
            AudioFile *af = [[AudioFile alloc] init];
            af.fid = [items objectAtIndex:0];
            af.filename = [items objectAtIndex:1];
            af.recordDate = [items objectAtIndex:2];
            af.fileURL = [NSURL URLWithString:[items objectAtIndex:3]];
            af.emotion = [items objectAtIndex:4];
            af.angry = [items objectAtIndex:5];
            af.fearful = [items objectAtIndex:6];
            af.happy = [items objectAtIndex:7];
            af.sad = [items objectAtIndex:8];
            [mobject insertObject:af atIndex:0];
            [af release];
        }
    }
    [self.tableView reloadData];
}

-(void)checkForNewAlerts
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://aakay.net/EmotionRecognition/iOS/?r=a&u=%@&p=%@", username, encPassword]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request startSynchronous];
    NSString *response = [request responseString];
    
    NSArray *lines = [response componentsSeparatedByString:@"\n"];
    for(NSString *line in lines)
    {
        if(![line isEqualToString:@""] && ![line isEqualToString:@"0"])
        {
            NSArray *items = [line componentsSeparatedByString:@"\t"];
            NSString *aid = [items objectAtIndex:0];
            NSString *title = [items objectAtIndex:1];
            NSString *msg = [items objectAtIndex:2];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                            message:msg
                                                           delegate:nil
                                                  cancelButtonTitle:@"Close"
                                                  otherButtonTitles: nil];
            [alert show];
            [alert release];
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://aakay.net/EmotionRecognition/iOS/?r=ra&u=%@&p=%@&a=%@", username, encPassword, aid]];
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
            [request startSynchronous];
        }
    }
}

-(void)checkForUpdates
{
    if(loggedIn)
    {
        [self updateRecordedFilesList];
        [self checkForNewAlerts];
    }
}

- (void)dealloc
{
    [recordAudioButton release];
    [recordNavigationController release];
    [username release];
    [nickname release];
    [encPassword release];
    [super dealloc];
}

@end
