//
//  RecordedFilesDataController.h
//  AudioRecordingTest2
//
//  Created by Akash Krishnan on 7/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RecordedFilesDataController : NSObject
{
    NSMutableArray *recordedFilesList;
}

-(unsigned)countOfList;
-(id)objectInListAtIndex;
-(void)addData:(NSString*)data;
-(void)removeDataAtIndex:(unsigned)theIndex;

@property (nonatomic, copy, readwrite) NSMutableArray *recordedFilesList;

@end
