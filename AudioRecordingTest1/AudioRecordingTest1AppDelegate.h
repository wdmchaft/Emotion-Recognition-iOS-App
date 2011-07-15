//
//  AudioRecordingTest1AppDelegate.h
//  AudioRecordingTest1
//
//  Created by Akash Krishnan on 7/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AudioRecordingTest1ViewController;

@interface AudioRecordingTest1AppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet AudioRecordingTest1ViewController *viewController;

@end
