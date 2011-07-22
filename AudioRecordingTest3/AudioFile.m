//
//  AudioFile.m
//  AudioRecordingTest3
//
//  Created by Akash Krishnan on 7/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AudioFile.h"


@implementation AudioFile

@synthesize filename;
@synthesize recordDate;
@synthesize fileURL;

-(id)init
{
    return self;
}

-(void)dealloc
{
    [filename release];
    [recordDate release];
    [fileURL release];
    [super dealloc];
}

@end
