//
//  PlayControlBar.h
//  MediaPlayerController
//
//  Created by kinglonghuang on 1/24/14.
//  Copyright (c) 2014 Shenzhen Coship Electronics Co.,ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MPMoviePlayerController.h>

typedef NS_ENUM(NSInteger, BitRate) {
    BitRate_Demo = 140
};

typedef NS_ENUM(NSInteger, PlayerState) {
    PlayerState_Paused  = 0,
    PlayerState_Play    = 1
};

 typedef enum {
     PlayControlBarOperate_LivingPlay = 0,
     PlayControlBarOperate_Play,
     PlayControlBarOperate_Pause,
     PlayControlBarOperate_EnterFullScreen,
     PlayControlBarOperate_ExitFullScreen,
     PlayControlBarOperate_FlyToTV,
     PlayControlBarOperate_LastMovie,
     PlayControlBarOperate_NextMovie     
}PlayControlBarOperate;

#define PlayOrPauseButtonWidth      40

@protocol PlayControlBarDelegate;

@interface PlayControlBar : UIView

@property (nonatomic, assign) id <PlayControlBarDelegate> delegate;
@property (nonatomic, assign) MPMovieControlStyle controlStyle;
@property (nonatomic, strong) UISlider *timeSlider;
@property (nonatomic, strong) UIButton *playOrPauseButton;
@property (nonatomic, strong) UIButton *fullScreenButton;
@property (nonatomic, strong) UIButton *flyToTVButton;
@property (nonatomic, assign) NSTimeInterval duration;

@property (nonatomic, strong) UILabel *currentPlaybackTimeLabel;
@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, strong) UILabel *playbackTimeDesLabel;


//Helper
- (NSString *)desForDuration:(NSTimeInterval)interval;

//Public
- (void)startProgressUpdateTimer;
- (void)stopProgressUpdateTimer;
- (void)setIsPlay:(BOOL)isPlay;
- (void)setTitle:(NSString *)title;
- (void)updateCurrentPlaybackTime:(NSTimeInterval)currentPlaybackTime duration:(NSTimeInterval)duration;

//Override
- (void)layoutUIForEmbeddedStyle;
- (void)layoutUIForFullScreenStyle;
- (void)progressUpdateInvoke:(NSTimer *)timer;
- (void)playOrPause:(UIButton *)button;
- (void)timeSliderValueDidChanged:(UISlider *)slider;
- (void)timeSliderAskForSeek:(UISlider *)slider;
- (void)enterFullScreen:(UIButton *)button;
- (void)flyToTV:(UIButton *)button;
- (void)initUIComponents;

@end

@protocol PlayControlBarDelegate <NSObject>

//Common
- (NSTimeInterval)currentPlaybackTimeForPlayControlBar:(PlayControlBar *)playControlBar;

- (void)playControlBar:(PlayControlBar *)playCotrolBar askForSetBitRate:(BitRate)bitRate;

//这里建议这样用 避免委托方法太多 以及 按钮在不用的时候 也不用去掉对应的委托方法
- (void)playControlBar:(PlayControlBar *)playCotrolBar operateType:(PlayControlBarOperate)operateType;

//Vod
- (void)playControlBar:(PlayControlBar *)playCotrolBar askForSeekWithPercentage:(CGFloat)percentage;

@end
