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
    NSString *fid;
    NSString *filename;
    NSString *recordDate;
    NSURL *fileURL;
    NSError *error;
    
    NSString *emotion;
    NSString *angry;
    NSString *fearful;
    NSString *happy;
    NSString *sad;
}

@property (nonatomic, retain) NSString *fid;
@property (nonatomic, retain) NSString *filename;
@property (nonatomic, retain) NSString *recordDate;
@property (nonatomic, retain) NSURL *fileURL;
@property (nonatomic, retain) NSError *error;

@property (nonatomic, retain) NSString *emotion;
@property (nonatomic, retain) NSString *angry;
@property (nonatomic, retain) NSString *fearful;
@property (nonatomic, retain) NSString *happy;
@property (nonatomic, retain) NSString *sad;

+(void)analyze:(NSURL *)fileURL username:(NSString *)username password:(NSString *)encPassword;

@end
