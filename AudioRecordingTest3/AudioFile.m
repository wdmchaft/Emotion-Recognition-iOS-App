//
//  AudioFile.m
//  AudioRecordingTest3
//
//  Created by Akash Krishnan on 7/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AudioFile.h"
#import "ASIFormDataRequest.h"

@implementation AudioFile

@synthesize fid;
@synthesize filename;
@synthesize recordDate;
@synthesize fileURL;
@synthesize error;

@synthesize emotion;
@synthesize angry;
@synthesize fearful;
@synthesize happy;
@synthesize sad;

+(void)analyze:(NSURL *)fileURL username:(NSString *)username password:(NSString *)encPassword
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://aakay.net/EmotionRecognition/iOS/?r=f&u=%@&p=%@&l=%@", username, encPassword, @"Untitled+Audio+File", [[fileURL absoluteString] stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"]]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostFormat:ASIMultipartFormDataPostFormat];
    //[request setUploadProgressDelegate:theProgressView];
    [request setFile:[fileURL relativePath] forKey:@"file"];
    [request startAsynchronous];
}

-(id)init
{
    return self;
}

-(void)dealloc
{
    [fid release];
    [filename release];
    [recordDate release];
    [fileURL release];
    [error release];
    
    [emotion release];
    [angry release];
    [fearful release];
    [happy release];
    [sad release];
    
    [super dealloc];
}

@end
