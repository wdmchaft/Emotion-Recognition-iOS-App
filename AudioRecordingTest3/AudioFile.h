//
//  AudioFile.h
//  AudioRecordingTest3
//
//  Created by Akash Krishnan on 7/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AudioFile : NSObject
{
    NSString *filename;
    NSString *recordDate;
    NSURL *fileURL;
}

@property (nonatomic, copy, readwrite) NSString *filename;
@property (nonatomic, copy, readwrite) NSString *recordDate;
@property (nonatomic, copy, readwrite) NSURL *fileURL;

@end
