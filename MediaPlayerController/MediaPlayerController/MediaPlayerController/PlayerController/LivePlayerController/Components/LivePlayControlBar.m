//
//  LivePlayControlBar.m
//  MediaPlayerController
//
//  Created by lingmin on 14-1-27.
//  Copyright (c) 2014年 Shenzhen Coship Electronics Co.,ltd. All rights reserved.
//

#import "LivePlayControlBar.h"

@interface LivePlayControlBar()

@property (nonatomic, strong)UIButton *livingPlayButton;
@property (nonatomic, strong)UIButton *lastMovieButton;
@property (nonatomic, strong)UIButton *nextMovieButton;

@end

@implementation LivePlayControlBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)initUIComponents{
    [super initUIComponents];
    
    self.livingPlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_livingPlayButton setTitle:FKLocalized(@"直播") forState:UIControlStateNormal];
    [_livingPlayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _livingPlayButton.backgroundColor = [UIColor redColor];
    [_livingPlayButton addTarget:self action:@selector(livingPlayAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.lastMovieButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_lastMovieButton setTitle:FKLocalized(@"上一个") forState:UIControlStateNormal];
    [_lastMovieButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _lastMovieButton.backgroundColor = [UIColor redColor];
    [_lastMovieButton addTarget:self action:@selector(lastMovieAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_lastMovieButton];
    
    self.nextMovieButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nextMovieButton setTitle:FKLocalized(@"下一个") forState:UIControlStateNormal];
    [_nextMovieButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _nextMovieButton.backgroundColor = [UIColor redColor];
    [_nextMovieButton addTarget:self action:@selector(nextMovieAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_nextMovieButton];
}

#pragma mark - action

- (void)livingPlayAction:(UIButton*)sender{
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(playControlBar:operateType:)]) {
        [self.delegate playControlBar:self operateType:PlayControlBarOperate_LivingPlay];
    }
}
- (void)lastMovieAction:(UIButton*)sender{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(playControlBar:operateType:)]) {
        [self.delegate playControlBar:self operateType:PlayControlBarOperate_LastMovie];
    }
}
- (void)nextMovieAction:(UIButton*)sender{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(playControlBar:operateType:)]) {
        [self.delegate playControlBar:self operateType:PlayControlBarOperate_NextMovie];
    }
}
#pragma mark private
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

#pragma mark - override

- (void)layoutUIForFullScreenStyle{
    
}
- (void)layoutUIForEmbeddedStyle{
    
}

- (void)timeSliderValueDidChanged:(UISlider *)slider {
    [super timeSliderValueDidChanged:slider];
    [self updateTimeDesLabelWithPlaybackTime:slider.value*self.duration duratio:self.duration];
}

@end
