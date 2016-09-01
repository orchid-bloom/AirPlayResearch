//
//  MediaPlayerController.m
//  MediaPlayerController
//
//  Created by kinglonghuang on 1/23/14.
//  Copyright (c) 2014 Shenzhen Coship Electronics Co.,ltd. All rights reserved.
//

#import "MediaPlayerController.h"
#import "BasePlayerController.h"
#import "VodPlayerController.h"

@interface MediaPlayerController() <BasePlayerControllerDelegate>

@property (nonatomic, strong) BasePlayerController *innerPlayerController;

@end


@implementation MediaPlayerController

#pragma mark - Private

- (BasePlayerController *)playerWithMediaResource:(MediaResource *)mediaResource {
    switch (mediaResource.type) {
        case MediaResourceType_LiveProgram: {
            break;
        }
        case MediaResourceType_Teleplay: {
            break;
        }
        case MediaResourceType_TVLive: {
            break;
        }
        case MediaResourceType_Vod: {
            return [[VodPlayerController alloc] initWithMediaResource:mediaResource];
            break;
        }
        default:
            break;
    }
    return nil;
}

#pragma mark - LifeCycle

- (UIView *)view {
    return self.innerPlayerController.view;
}

- (void)setControlStyle:(MPMovieControlStyle)controlStyle {
    [self.innerPlayerController setControlStyle:controlStyle];
}

- (MPMovieControlStyle)controlStyle {
    return self.innerPlayerController.controlStyle;
}

#pragma mark - Public

- (id)initWithMediaResource:(MediaResource *)mediaResource {
    self = [super init];
    if (self) {
        self.innerPlayerController = [self playerWithMediaResource:mediaResource];
        [self.innerPlayerController setDelegate:self];
        [self.innerPlayerController setControlStyle:MPMovieControlStyleEmbedded];
        [self.innerPlayerController setAllowsAirPlay:YES];
        return self;
    }
    return nil;
}

#pragma mark - MPMediaPlayback

- (void)prepareToPlay {
    [self.innerPlayerController prepareToPlay];
}

// Returns YES if prepared for playback.

- (BOOL)isPreparedToPlay {
    return self.innerPlayerController.isPreparedToPlay;
}

- (void)play {
    [self.innerPlayerController prepareToPlay];
}

- (void)pause {
    [self.innerPlayerController pause];
}

- (void)stop {
    [self.innerPlayerController stop];
}

- (NSTimeInterval)currentPlaybackTime {
    return [self.innerPlayerController currentPlaybackTime];
}

- (void)setCurrentPlaybackTime:(NSTimeInterval)currentPlaybackTime {
    [self.innerPlayerController setCurrentPlaybackTime:currentPlaybackTime];
}

- (float)currentPlaybackRate {
    return self.innerPlayerController.currentPlaybackRate;
}

- (void)setCurrentPlaybackRate:(float)currentPlaybackRate {
    [self.innerPlayerController setCurrentPlaybackRate:currentPlaybackRate];
}

- (void)beginSeekingForward {
    [self.innerPlayerController beginSeekingForward];
}

- (void)beginSeekingBackward {
    [self.innerPlayerController beginSeekingBackward];
}

- (void)endSeeking {
    [self.innerPlayerController endSeeking];
}

#pragma mark - BasePlayerControllerDelegate

- (void)basePlayerControllerAskForEnterFullScreen:(MPMoviePlayerController *)basePlayerController {
    if ([self.delegate respondsToSelector:@selector(mediaPlayerControllerAskForEnterFullScreen:)]) {
        [self.delegate mediaPlayerControllerAskForEnterFullScreen:self];
    }
}

- (void)basePlayerControllerAskForExitFullScreen:(MPMoviePlayerController *)basePlayerController {
    if ([self.delegate respondsToSelector:@selector(mediaPlayerControllerAskForExitFullScreen:)]) {
        [self.delegate mediaPlayerControllerAskForExitFullScreen:self];
    }
}

@end
