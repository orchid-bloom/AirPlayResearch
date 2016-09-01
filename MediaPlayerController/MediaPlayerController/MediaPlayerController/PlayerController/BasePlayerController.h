//
//  BasePlayerController.h
//  MediaPlayerController
//
//  Created by kinglonghuang on 1/24/14.
//  Copyright (c) 2014 Shenzhen Coship Electronics Co.,ltd. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import "MediaPlayerProtocol.h"
#import "MediaResource.h"
#import "PlayControlTop.h"
#import "PlayControlBar.h"

@protocol BasePlayerControllerDelegate;

@interface BasePlayerController : MPMoviePlayerController<PlayControlTopDelegate,PlayControlBarDelegate>

@property (nonatomic, strong) PlayControlTop *playControlTop;
@property (nonatomic, strong) PlayControlBar *playControlBar;
@property (nonatomic, assign) BOOL hiddenSubviews;
@property (nonatomic, assign) id <BasePlayerControllerDelegate> delegate;

- (id)initWithMediaResource:(MediaResource *)mediaResource;

//super
- (void)handelSingleTap:(UITapGestureRecognizer*)gestureRecognizer;

@end

@protocol BasePlayerControllerDelegate <NSObject>

//base player stands for Vod player, Live program player, TVLive player ...
- (void)basePlayerControllerAskForEnterFullScreen:(MPMoviePlayerController *)basePlayerController;
- (void)basePlayerControllerAskForExitFullScreen:(MPMoviePlayerController *)basePlayerController;

@end