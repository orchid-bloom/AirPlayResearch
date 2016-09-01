//
//  BasePlayerController.m
//  MediaPlayerController
//
//  Created by kinglonghuang on 1/24/14.
//  Copyright (c) 2014 Shenzhen Coship Electronics Co.,ltd. All rights reserved.
//

#import "BasePlayerController.h"

@implementation BasePlayerController

- (id)initWithMediaResource:(MediaResource *)mediaResource {
    self = [super initWithContentURL:mediaResource.url];
    if (self) {
        [self initPlayControlTop];
        [self initPlayControlBar];
        return self;
    }
    return nil;
}

- (id)init{
    self = [super init];
    if (self) {
        UIView *blockView = [[UIView alloc]initWithFrame:CGRectZero];
        blockView.backgroundColor = [UIColor clearColor];
        blockView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:blockView];
        
        self.hiddenSubviews = NO;
        
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification  object:nil];
        [self.view setUserInteractionEnabled:YES];
        [self addGesture];
        
        self.scalingMode = MPMovieScalingModeAspectFill;
        return self;
    }
    return nil;
}

#pragma mark - Override initView

- (void)initPlayControlTop{}
- (void)initPlayControlBar{}

#pragma mark -

- (void)deviceOrientationDidChange:(NSNotification*)notification{
    
    UIDeviceOrientation orientation =[UIDevice currentDevice].orientation;
    if (orientation == UIDeviceOrientationLandscapeLeft||orientation == UIDeviceOrientationLandscapeRight) {
        [self.delegate  basePlayerControllerAskForEnterFullScreen:self];
    }
}

- (void)addGesture{
    //创建一个点击手势对象
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handelSingleTap:)];
    [self.view addGestureRecognizer:singleTap];
    [singleTap setNumberOfTouchesRequired:1];//触摸点个数
    [singleTap setNumberOfTapsRequired:1];//点击次数
}

- (void)handelSingleTap:(UITapGestureRecognizer*)gestureRecognizer{
    
    self.hiddenSubviews = !self.hiddenSubviews;
    
    [[UIApplication sharedApplication] setStatusBarHidden:self.hiddenSubviews];
    
    CGFloat playControlTopY = self.playControlTop.hidden==NO?-self.playControlTop.frame.size.height:0;
    CGFloat playControlBarY = self.playControlBar.hidden==YES?self.view.frame.size.height-self.playControlBar.frame.size.height:self.view.frame.size.height;
    BOOL hidden = self.playControlTop.hidden;
    self.playControlBar.hidden = NO;
    self.playControlTop.hidden = NO;
  
    [UIView animateWithDuration:0.35 animations:^{
        self.playControlTop.frame = CGRectMake(0,playControlTopY,self.playControlTop.frame.size.width, self.playControlTop.frame.size.height);
        self.playControlBar.frame = CGRectMake(0, playControlBarY, self.playControlBar.frame.size.width, self.playControlBar.frame.size.height);
    } completion:^(BOOL finished) {
        if (hidden == NO) {
            self.playControlTop.hidden = YES;
            self.playControlBar.hidden = YES;
        }
        
    }];
    
}

#pragma mark - PlayControlTopDelegate

- (void)playControlTop:(PlayControlTop*)control operateType:(PlayControlTopOperate)operateTyp{
    
    if (operateTyp == PlayControlTopOperate_Back) {
        if ([self.delegate respondsToSelector:@selector(basePlayerControllerAskForExitFullScreen:)]) {
            [self.delegate basePlayerControllerAskForExitFullScreen:self];
        }
    }
}
- (NSTimeInterval)currentPlaybackTimeForPlayControlBar:(PlayControlBar *)playControlBar {
    return self.currentPlaybackTime;
}
- (void)playControlBar:(PlayControlBar *)playCotrolBar operateType:(PlayControlBarOperate)operateType{
    if (operateType == PlayControlBarOperate_EnterFullScreen) {
        if ([self.delegate respondsToSelector:@selector(basePlayerControllerAskForEnterFullScreen:)]) {
            [self.delegate basePlayerControllerAskForEnterFullScreen:self];
        }
    }else if (operateType == PlayControlBarOperate_ExitFullScreen){
        if ([self.delegate respondsToSelector:@selector(basePlayerControllerAskForExitFullScreen:)]) {
            [self.delegate basePlayerControllerAskForExitFullScreen:self];
        }
    }else if(operateType == PlayControlBarOperate_Play){
        [self play];
    }else if(operateType == PlayControlBarOperate_Pause){
        [self pause];
    }else if(operateType == PlayControlBarOperate_FlyToTV){
        
    }
}

- (void)playControlBar:(PlayControlBar *)playCotrolBar askForSetBitRate:(BitRate)bitRate {
}

- (void)playControlBar:(PlayControlBar *)playCotrolBar askForSeekWithPercentage:(CGFloat)percentage {

}

@end
