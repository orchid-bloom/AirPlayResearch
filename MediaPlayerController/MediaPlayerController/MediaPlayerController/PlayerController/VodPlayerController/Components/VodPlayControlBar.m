//
//  PlayControlBar.m
//  MediaPlayerController
//
//  Created by kinglonghuang on 1/24/14.
//  Copyright (c) 2014 Shenzhen Coship Electronics Co.,ltd. All rights reserved.
//

#import "VodPlayControlBar.h"

@interface VodPlayControlBar()



@end

@implementation VodPlayControlBar
#pragma mark - LifeCycle

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        return self;
    }
    return nil;
}
#pragma mark - Private

- (void)updateTimeDesLabelWithPlaybackTime:(NSTimeInterval)currentPlaybackTime duratio:(NSTimeInterval)duration {
    NSString * currentPlaybackTimeDes = [self desForDuration:currentPlaybackTime];
    NSString * durationDes = [self desForDuration:duration];
    if (self.controlStyle == MPMovieControlStyleEmbedded) {
        NSString * playbackTimeDes = [NSString stringWithFormat:@"%@/%@",currentPlaybackTimeDes,durationDes];
        [self.playbackTimeDesLabel setText:playbackTimeDes];
    }else {
        [self.currentPlaybackTimeLabel setText:[NSString stringWithFormat:@"%@",currentPlaybackTimeDes]];
        [self.durationLabel setText:[NSString stringWithFormat:@"%@",durationDes]];
    }
}

- (void)layoutUIForEmbeddedStyle {
    //Clear First
    for (UIView * subView in self.subviews) {
        [subView removeFromSuperview];
    }
    [self addSubview:self.timeSlider];
    [self addSubview:self.playOrPauseButton];
    [self addSubview:self.fullScreenButton];
    [self addSubview:self.playbackTimeDesLabel];
    
    [self.timeSlider setFrame:CGRectMake(60, (self.frame.size.height-30)/2.0, self.frame.size.width-120, 22)];
    [self.playOrPauseButton setFrame:CGRectMake(8, (self.frame.size.height-PlayOrPauseButtonWidth)/2.0, PlayOrPauseButtonWidth, PlayOrPauseButtonWidth)];
    [self.fullScreenButton setFrame:CGRectMake(self.frame.size.width-48, (self.frame.size.height-PlayOrPauseButtonWidth)/2.0, PlayOrPauseButtonWidth, PlayOrPauseButtonWidth)];
    [self.playbackTimeDesLabel setFrame:CGRectMake(60, CGRectGetMaxY(self.timeSlider.frame)+5, 200, 12)];
}

- (void)layoutUIForFullScreenStyle {
    //Clear First
    for (UIView * subView in self.subviews) {
        [subView removeFromSuperview];
    }
    [self addSubview:self.timeSlider];
    [self addSubview:self.playOrPauseButton];
    [self addSubview:self.flyToTVButton];
    [self addSubview:self.currentPlaybackTimeLabel];
    [self addSubview:self.durationLabel];

    [self.timeSlider setFrame:CGRectMake(60, 5, self.frame.size.width-120, 22)];
    [self.currentPlaybackTimeLabel setFrame:CGRectMake(5, 5, 60, 20)];
    [self.durationLabel setFrame:CGRectMake((self.frame.size.width-55), 5, 60, 20)];
    
    [self.flyToTVButton setFrame:CGRectMake(5, CGRectGetMaxY(self.timeSlider.frame)+5, PlayOrPauseButtonWidth, PlayOrPauseButtonWidth)];
    [self.playOrPauseButton setFrame:CGRectMake((self.frame.size.width-PlayOrPauseButtonWidth)/2.0, CGRectGetMaxY(self.timeSlider.frame)+5, PlayOrPauseButtonWidth, PlayOrPauseButtonWidth)];
}


#pragma mark - Override

- (void)progressUpdateInvoke:(NSTimer *)timer {
    [super progressUpdateInvoke:timer];
    NSTimeInterval currenPlaybackTime = [self.delegate currentPlaybackTimeForPlayControlBar:self];
    [self updateCurrentPlaybackTime:currenPlaybackTime duration:self.duration];
}

- (void)playOrPause:(UIButton *)button {
    [super playOrPause:button];
}

- (void)timeSliderValueDidChanged:(UISlider *)slider {
    [self stopProgressUpdateTimer];
    [super timeSliderValueDidChanged:slider];
    [self updateTimeDesLabelWithPlaybackTime:slider.value*self.duration duratio:self.duration];
}

- (void)timeSliderAskForSeek:(UISlider *)slider {
    [super timeSliderAskForSeek:slider];
    [self updateTimeDesLabelWithPlaybackTime:slider.value*self.duration duratio:self.duration];
    if ([self.delegate respondsToSelector:@selector(playControlBar:askForSeekWithPercentage:)]) {
        [self.delegate playControlBar:self askForSeekWithPercentage:slider.value];
    }
}

- (void)enterFullScreen:(UIButton *)button {
    [super enterFullScreen:button];
}

- (void)flyToTV:(UIButton *)button {
    [super flyToTV:button];
}

- (void)initUIComponents {
    [super initUIComponents];
}

#pragma mark - Public

- (void)setIsPlay:(BOOL)isPlay {
    [super setIsPlay:isPlay];
}

- (void)updateCurrentPlaybackTime:(NSTimeInterval)currentPlaybackTime duration:(NSTimeInterval)duration {
    [super updateCurrentPlaybackTime:currentPlaybackTime duration:duration];
    
    if (self.duration) {
        CGFloat sliderValue = currentPlaybackTime/self.duration;
        [self.timeSlider setValue:sliderValue];
    }
    [self updateTimeDesLabelWithPlaybackTime:currentPlaybackTime duratio:duration];
}

@end
