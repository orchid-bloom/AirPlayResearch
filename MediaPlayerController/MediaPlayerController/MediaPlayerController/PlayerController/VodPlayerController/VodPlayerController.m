//
//  VodPlayerController.m
//  MediaPlayerController
//
//  Created by kinglonghuang on 1/23/14.
//  Copyright (c) 2014 Shenzhen Coship Electronics Co.,ltd. All rights reserved.
//

#import "VodPlayerController.h"
#import "MediaResource.h"

@interface VodPlayerController()


@end

@implementation VodPlayerController

#pragma mark - Private

- (void)initPlayControlBar {
    //Default using the embedded
    self.playControlBar = [[VodPlayControlBar alloc] initWithFrame:CGRectZero];
    [self.playControlBar setDelegate:self];
    [self.playControlBar setIsPlay:NO];
    [self.view addSubview:self.playControlBar];
}

- (void)initPlayControlTop{
    self.playControlTop = [[VodPlayControlTop alloc]initWithFrame:CGRectZero];
    self.playControlTop.backgroundColor = [UIColor whiteColor];
    [self.playControlTop setDelegate:self];
    [self.view addSubview:self.playControlTop];
}

- (void)addObserver {
    NSNotificationCenter * defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(whenMovieDurationAvailable:)
                          name:MPMovieDurationAvailableNotification
                        object:nil];
	[defaultCenter addObserver:self
                      selector:@selector(whenMoviePlayerPlaybackStateDidChanged:)
                          name:MPMoviePlayerPlaybackStateDidChangeNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(whenMoviePlayerLoadStateDidChanged:)
                          name:MPMoviePlayerLoadStateDidChangeNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(whenMoviePlayerPlaybackDidFinished:)
                          name:MPMoviePlayerPlaybackDidFinishNotification object:nil];

	MPMusicPlayerController *mpc = [MPMusicPlayerController applicationMusicPlayer];
	if(mpc){
		[defaultCenter addObserver:self
                          selector:@selector(whenSystemVolumeChanged:)
                              name:MPMusicPlayerControllerVolumeDidChangeNotification
                            object:nil];
		[mpc beginGeneratingPlaybackNotifications];
	}
}

#pragma mark - ProgressUpdate

- (void)progressUpdateInvoke:(NSTimer *)timer {
    [self.playControlBar updateCurrentPlaybackTime:self.currentPlaybackTime duration:self.duration];
}

#pragma mark - Public

- (id)initWithMediaResource:(MediaResource *)mediaResource {
    self = [super initWithMediaResource:mediaResource];
    if (self) {
        [self addObserver];
        return self;
    }
    return nil;
}

#pragma mark - Override

- (void)layoutUIWithControlStyle:(MPMovieControlStyle)controlStyle {
    if (controlStyle == MPMovieControlStyleEmbedded) {
        [self.playControlTop setFrame:CGRectZero];
        [self.playControlBar setFrame:CGRectMake(0, self.view.frame.size.height-55, self.view.frame.size.width, 55)];
    }else if (controlStyle == MPMovieControlStyleFullscreen) {
        [self.playControlTop setFrame:CGRectMake(0,20,self.view.frame.size.width,44)];
        [self.playControlBar setFrame:CGRectMake(0, self.view.frame.size.height-75, self.view.frame.size.width, 75)];
    }else if (controlStyle == MPMovieControlStyleNone) {
        [self.playControlBar setFrame:CGRectZero];
    }
    [self.playControlTop setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin];
    [self.playControlBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin];
    [self.playControlBar setControlStyle:controlStyle];
}

- (void)setControlStyle:(MPMovieControlStyle)controlStyle {
    //Hide the default controls reagrdness of the user style
    [super setControlStyle:MPMovieControlStyleNone];
    [self layoutUIWithControlStyle:controlStyle];
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

#pragma mark - PlayControlTopDelegate

- (void)playControlTop:(PlayControlTop*)control operateType:(PlayControlTopOperate)operateTyp{
    [super playControlTop:control operateType:operateTyp];
}

#pragma mark - PlayControlBarDelegate

- (NSTimeInterval)currentPlaybackTimeForPlayControlBar:(PlayControlBar *)playControlBar {
    return self.currentPlaybackTime;
}
- (void)playControlBar:(PlayControlBar *)playCotrolBar operateType:(PlayControlBarOperate)operateType{
    [super playControlBar:playCotrolBar operateType:operateType];
}

- (void)playControlBar:(VodPlayControlBar *)playCotrolBar askForSetBitRate:(BitRate)bitRate {
    [super playControlBar:playCotrolBar askForSetBitRate:bitRate];
}

- (void)playControlBar:(VodPlayControlBar *)playCotrolBar askForSeekWithPercentage:(CGFloat)percentage {
    [self setCurrentPlaybackTime:self.duration * percentage];
    [self prepareToPlay];
}

@end
