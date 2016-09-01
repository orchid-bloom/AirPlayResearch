//
//  PlayControlBar.m
//  MediaPlayerController
//
//  Created by kinglonghuang on 1/24/14.
//  Copyright (c) 2014 Shenzhen Coship Electronics Co.,ltd. All rights reserved.
//

#import "PlayControlBar.h"

@interface PlayControlBar()

@property (nonatomic, strong) NSTimer *progressUpdateTimer;

@end

@implementation PlayControlBar
#pragma mark - LifeCycle

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor grayColor]];
        [self setControlStyle:MPMovieControlStyleEmbedded];
        [self initUIComponents];
        return self;
    }
    return nil;
}
#pragma mark - Override

- (void)progressUpdateInvoke:(NSTimer *)timer {
    
}

- (void)playOrPause:(UIButton *)button {
    [button setSelected:!button.isSelected];
    if (button.isSelected == PlayerState_Play) { //Should Play the movie
        [button setBackgroundColor:[UIColor greenColor]];
        if ([self.delegate respondsToSelector:@selector(playControlBar:operateType:)]) {
            [self.delegate playControlBar:self operateType:PlayControlBarOperate_Play];
        }
    }else if (button.isSelected == PlayerState_Paused) { //Should Pause the movie
        [button setBackgroundColor:[UIColor yellowColor]];
        if ([self.delegate respondsToSelector:@selector(playControlBar:operateType:)]) {
            [self.delegate playControlBar:self operateType:PlayControlBarOperate_Pause];
        }
    }
}

- (void)timeSliderValueDidChanged:(UISlider *)slider {
      [self stopProgressUpdateTimer];
}

- (void)timeSliderAskForSeek:(UISlider *)slider {
}

- (void)flyToTV:(UIButton *)button {
    if([self.delegate respondsToSelector:@selector(playControlBar:operateType:)]){
        [self.delegate playControlBar:self operateType:PlayControlBarOperate_FlyToTV];
    }
}

- (void)enterFullScreen:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(playControlBar:operateType:)]) {
        [self.delegate playControlBar:self operateType:PlayControlBarOperate_EnterFullScreen];
    }
}

- (void)initUIComponents {
    //Common layout
    self.playOrPauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playOrPauseButton setSelected:PlayerState_Paused]; //No stands for paused
    [self.playOrPauseButton setBackgroundColor:[UIColor yellowColor]];
    [self.playOrPauseButton addTarget:self action:@selector(playOrPause:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.playOrPauseButton];
    
    self.timeSlider = [[UISlider alloc] init];
    [self.timeSlider setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
    [self.timeSlider setValue:0.0];
    [self.timeSlider addTarget:self action:@selector(timeSliderValueDidChanged:) forControlEvents:UIControlEventValueChanged];
    [self.timeSlider addTarget:self action:@selector(timeSliderAskForSeek:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
    [self addSubview:self.timeSlider];
    
    self.fullScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.fullScreenButton addTarget:self action:@selector(enterFullScreen:) forControlEvents:UIControlEventTouchUpInside];
    [self.fullScreenButton setBackgroundColor:[UIColor darkGrayColor]];
    [self addSubview:self.fullScreenButton];
    
    self.flyToTVButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.flyToTVButton addTarget:self action:@selector(flyToTV:) forControlEvents:UIControlEventTouchUpInside];
    [self.flyToTVButton setBackgroundColor:[UIColor darkGrayColor]];
    [self addSubview:self.flyToTVButton];
    
    self.currentPlaybackTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.currentPlaybackTimeLabel setFont:[UIFont systemFontOfSize:12]];
    [self.currentPlaybackTimeLabel setBackgroundColor:[UIColor clearColor]];
    [self.currentPlaybackTimeLabel setText:@"00:00:00"];
    [self addSubview:self.currentPlaybackTimeLabel];
    
    self.durationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.durationLabel setFont:[UIFont systemFontOfSize:12]];
    [self.durationLabel setBackgroundColor:[UIColor clearColor]];
    [self.durationLabel setText:@"00:00/00:00"];
    [self addSubview:self.durationLabel];
    
    
    self.playbackTimeDesLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.playbackTimeDesLabel setFont:[UIFont systemFontOfSize:12]];
    [self.playbackTimeDesLabel setBackgroundColor:[UIColor clearColor]];
    [self.playbackTimeDesLabel setText:@"00:00:00/00:00:00"];
    [self addSubview:self.playbackTimeDesLabel];

}

- (void)layoutUIForEmbeddedStyle {
}

- (void)layoutUIForFullScreenStyle {
}

- (void)setControlStyle:(MPMovieControlStyle)controlStyle {
    _controlStyle = controlStyle;
    [self layoutUIWithStyle:controlStyle];
}

#pragma mark - Private

- (void)layoutUIWithStyle:(MPMovieControlStyle)controlStyle {
    switch (controlStyle) {
        case MPMovieControlStyleEmbedded: {
            [self layoutUIForEmbeddedStyle];
            break;
        }
        case MPMovieControlStyleFullscreen: {
            [self layoutUIForFullScreenStyle];
            break;
        }
        default: {
            break;
        }
    }
}
#pragma mark - Helper

- (NSString *)desForDuration:(NSTimeInterval)interval {
    NSString * desStr = @"";
    NSInteger hour = interval / 3600;
    if (hour > 0) {
        if (hour < 10) {
            desStr = [desStr stringByAppendingFormat:@"0%d:",hour];
        }else {
            desStr = [desStr stringByAppendingFormat:@"%d:",hour];
        }
        interval = interval - 3600.0*hour;
    }else {
        desStr = [desStr stringByAppendingFormat:@"%@:",@"00"];
    }
    NSInteger minute = interval / 60;
    if (minute > 0) {
        if (minute < 10) {
            desStr = [desStr stringByAppendingFormat:@"0%d:",minute];
        }else {
            desStr = [desStr stringByAppendingFormat:@"%d:",minute];
        }
        interval = interval - 60.0*minute;
    }else {
        desStr = [desStr stringByAppendingFormat:@"%@:",@"00"];
    }
    
    NSInteger second = interval;
    if (second < 10) {
        desStr = [desStr stringByAppendingFormat:@"0%d",second];
    }else {
        desStr = [desStr stringByAppendingFormat:@"%d",second];
    }
    
    return desStr;
}

#pragma mark - Public

- (void)startProgressUpdateTimer {
    self.progressUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(progressUpdateInvoke:) userInfo:nil repeats:YES];
}

- (void)stopProgressUpdateTimer {
    [self.progressUpdateTimer invalidate];
    self.progressUpdateTimer = nil;
}

- (void)setIsPlay:(BOOL)isPlay {
    if (isPlay) {
        [self.playOrPauseButton setSelected:PlayerState_Play];
        //UI Modification
        [self.playOrPauseButton setBackgroundColor:[UIColor greenColor]];
    }else {
        [self.playOrPauseButton setSelected:PlayerState_Paused];
        //UI Modification
        [self.playOrPauseButton setBackgroundColor:[UIColor yellowColor]];
    }
}

- (void)setTitle:(NSString *)title {
    
}

- (void)updateCurrentPlaybackTime:(NSTimeInterval)currentPlaybackTime duration:(NSTimeInterval)duration {
    self.duration = duration;
}

@end
