//
//  RootViewController.m
//  AudioRecordingTest2
//
//  Created by Akash Krishnan on 7/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "RecordedFilesDataController.h";

@implementation RootViewController

@synthesize recordAudioButton;
@synthesize recordedFilesDataController;
@synthesize myView;

-(id)initWithStyle:(UITableViewStyle)style
{
    if((self = [super initWithStyle:style]))
    {
        self.recordedFilesDataController = [[RecordedFilesDataController alloc] init];
    }
    
    return self;
}

-(void)loadView
{
    CGRect cgRct = CGRectMake(0, 10, 320, 400);
    myView = [[UIView alloc] initWithFrame:cgRct];
    myView.autoresizesSubviews = YES;
    self.view = myView;
    UITableView * tableView = [[UITableView alloc] initWithFrame:cgRct style:UITableViewStylePlain];
    tableView.editing = YES;
    tableView.dataSource = self;
    tableView.delegate = self;
    
    [self.view addSubview:tableView];
}

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
        [recordAudioButton setTitle:@"Record"];
        [recordAudioActivitySpinner stopAnimating];
        
        [audioRecorder stop];
        
        [recordedFilesDataController addData:@"New Audio Recording Added"];
        
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
                UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Connection Error"
                                                                                        message:@"Unable to connect to the processing server. Please try again later."
                                                                                       delegate:self
                                                                              cancelButtonTitle:@"Close"
                                                                              otherButtonTitles: nil];
                errorAlertView.tag = 3;
                [errorAlertView show];
                [errorAlertView release];
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
    return [recordedFilesDataController countOfList]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectMake(0,0,0,0) reuseIdentifier:@"CellIdentifier"] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if(indexPath.row == 0)
    {
        [cell setText:@"New Item..."];
    }
    else
    {
        [cell setText:[recordedFilesDataController objectInListAtIndex:indexPath.row-1]];
    }
    
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return UITableViewCellEditingStyleInsert;
    }
    else
    {
        return UITableViewCellEditingStyleDelete;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [recordedFilesDataController removeDataAtIndex:indexPath.row-1];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if(editingStyle == UITableViewCellEditingStyleInsert)
    {
        [recordedFilesDataController addData:@"New Row Added"];
        [tableView reloadData];
    }
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
