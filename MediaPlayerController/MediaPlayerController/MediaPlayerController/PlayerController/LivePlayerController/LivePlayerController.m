//
//  LivePlayerController.m
//  MediaPlayerController
//
//  Created by lingmin on 14-2-11.
//  Copyright (c) 2014年 Shenzhen Coship Electronics Co.,ltd. All rights reserved.
//

#import "LivePlayerController.h"
#import "LivePlayControlTop.h"
#import "LivePlayControlBar.h"

@implementation LivePlayerController

- (void)initPlayControlBar {
    //Default using the embedded
    self.playControlBar = [[LivePlayControlBar  alloc] initWithFrame:CGRectZero];
    [self.playControlBar setDelegate:self];
    [self.playControlBar setIsPlay:NO];
    [self.view addSubview:self.playControlBar];
}

- (void)initPlayControlTop{
    self.playControlTop = [[LivePlayControlTop alloc]initWithFrame:CGRectZero];
    self.playControlTop.backgroundColor = [UIColor whiteColor];
    [self.playControlTop setDelegate:self];
    [self.view addSubview:self.playControlTop];
}

- (id)initWithMediaResource:(MediaResource *)mediaResource {
    self = [super initWithMediaResource:mediaResource];
    if (self) {
        return self;
    }
    return nil;
}

#pragma mark - Notification Handle

- (void)whenMovieDurationAvailable:(NSNotification *)notification {
    [self.playControlBar updateCurrentPlaybackTime:self.currentPlaybackTime duration:self.duration];
}

- (void)whenMoviePlayerPlaybackStateDidChanged:(NSNotification *)notification {
    NSLog(@"playbackState:%d",self.playbackState);
    BOOL isPlaying = (self.playbackState == MPMoviePlaybackStatePlaying);
    [self.playControlBar setIsPlay:isPlaying];
    if (isPlaying) {
        [self.playControlBar startProgressUpdateTimer];
    }
}

- (void)whenMoviePlayerLoadStateDidChanged:(NSNotification *)notification {
    NSLog(@"loadState:%d",self.loadState);
}

- (void)whenMoviePlayerPlaybackDidFinished:(NSNotification *)notification {
    
}

- (void)whenSystemVolumeChanged:(NSNotification *)notification {
    
}

@end
