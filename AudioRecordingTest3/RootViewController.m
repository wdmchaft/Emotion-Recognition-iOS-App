//
//  RootViewController.m
//  AudioRecordingTest3
//
//  Created by Akash Krishnan on 7/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "AudioFile.h"
#import "AudioFileDetailViewController.h"
#import "OCPromptView.h"
#import "OCPasswordPromptView.h"
#import "ASIFormDataRequest.h"

@implementation RootViewController

@synthesize recordAudioButton;

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
            [recordAudioButton setTitle:@"Record"];
            [self.navigationItem setTitle:@"Recorded Files"];
            [recordAudioActivitySpinner stopAnimating];
            
            [audioRecorder stop];
            
            // Send new file to server
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://aakay.net/EmotionRecognition/iOS/?r=af&u=%@&p=%@&f=%@&l=%@", username, encPassword, @"Untitled+Audio+File", [[recordedAudioTmpFile absoluteString] stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"]]];
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
            [request startSynchronous];
            
            // Update recorded files list
            url = [NSURL URLWithString:[NSString stringWithFormat:@"http://aakay.net/EmotionRecognition/iOS/?r=rf&u=%@&p=%@", username, encPassword]];
            
            request = [ASIFormDataRequest requestWithURL:url];
            [request startSynchronous];
            NSError *error = [request error];
            NSString *response = [request responseString];
            NSArray *lines = [response componentsSeparatedByString:@"\n"];
            [mobject removeAllObjects];
            for(NSString *line in lines)
            {
                if(![line isEqualToString:@""])
                {
                    NSArray *items = [line componentsSeparatedByString:@"\t"];
                    AudioFile *af = [[AudioFile alloc] init];
                    af.filename = [items objectAtIndex:0];
                    af.recordDate = [items objectAtIndex:1];
                    af.fileURL = [NSURL URLWithString:[items objectAtIndex:2]];
                    [mobject insertObject:af atIndex:0];
                    [af release];
                }
            }
            [self.tableView reloadData];
            
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
                [recordAudioButton setTitle:@"Stop"];
                [self.navigationItem setTitle:@"Recording Audio..."];
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
            break;
        }
        case 2:
        {
            if(buttonIndex == 1)
            {
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://aakay.net/EmotionRecognition/iOS/?r=f&u=%@&p=%@&l=%@", username, encPassword, @"Untitled+Audio+File", [[recordedAudioTmpFile absoluteString] stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"]]];
                ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
                [request setPostFormat:ASIMultipartFormDataPostFormat];
                //[request setUploadProgressDelegate:theProgressView];
                [request setFile:[recordedAudioTmpFile relativePath] forKey:@"file"];
                [request startAsynchronous];
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
                NSError *error = [request error];
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
                    
                    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://aakay.net/EmotionRecognition/iOS/?r=rf&u=%@&p=%@", username, encPassword]];
                    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
                    [request startSynchronous];
                    NSError *error = [request error];
                    NSString *response = [request responseString];
                    NSArray *lines = [response componentsSeparatedByString:@"\n"];
                    [mobject removeAllObjects];
                    for(NSString *line in lines)
                    {
                        if(![line isEqualToString:@""])
                        {
                            NSArray *items = [line componentsSeparatedByString:@"\t"];
                            AudioFile *af = [[AudioFile alloc] init];
                            af.filename = [items objectAtIndex:0];
                            af.recordDate = [items objectAtIndex:1];
                            af.fileURL = [NSURL URLWithString:[items objectAtIndex:2]];
                            [mobject insertObject:af atIndex:0];
                            [af release];
                        }
                    }
                    [self.tableView reloadData];
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
                NSError *error = [request error];
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
    self.navigationItem.leftBarButtonItem = recordAudioActivityButton;
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

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

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
    
    // Set up the cell...
    AudioFile *af = [mobject objectAtIndex:indexPath.row];
	NSString *cellValue = [NSString stringWithFormat:@"%@ %@", af.recordDate, af.filename];
	[cell.textLabel setText:cellValue];
	
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete)
 {
 // Delete the row from the data source.
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert)
 {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AudioFile *af = [mobject objectAtIndex:indexPath.row];
    AudioFileDetailViewController *dvController = [[AudioFileDetailViewController alloc] initWithNibName:@"AudioFileDetailViewController" bundle:nil];
    dvController.filename = af.filename;
    dvController.recordDate = af.recordDate;
    dvController.fileURL = af.fileURL;
    dvController.error = recordAudioError;
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

- (void)dealloc
{
    [recordAudioButton release];
    [super dealloc];
}

@end
