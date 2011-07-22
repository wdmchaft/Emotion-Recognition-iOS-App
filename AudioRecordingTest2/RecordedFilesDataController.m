//
//  RecordedFilesDataController.m
//  AudioRecordingTest2
//
//  Created by Akash Krishnan on 7/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RecordedFilesDataController.h"

@implementation RecordedFilesDataController

@synthesize recordedFilesList;

-(id)init
{
    if((self = [super init]))
    {
        NSMutableArray *localList = [[NSMutableArray alloc] init];
        self.recordedFilesList = localList;
        [localList release];
        
        [self addData:@"Item 1"];
        [self addData:@"Item 2"];
    }
    return self;
}

-(unsigned)countOfList
{
    return [recordedFilesList count];
}

-(id)obejctInListAtIndex:(unsigned)theIndex
{
    return [recordedFilesList objectAtIndex:theIndex];
}

-(void)addData:(NSString*)data
{
    [recordedFilesList addObject:data];
}

-(void)removeDataAtIndex:(unsigned)theIndex
{
    [recordedFilesList removeObjectAtIndex:theIndex];
}

-(void)setList:(NSMutableArray*)newList
{
    if(recordedFilesList != newList)
    {
        [recordedFilesList release];
        recordedFilesList = [newList mutableCopy];
    }
}

-(void)dealloc
{
    [recordedFilesList release];
    [super dealloc];
}

@end
