//
//  MediaPlayerProtocol.h
//  MediaPlayerController
//
//  Created by kinglonghuang on 1/24/14.
//  Copyright (c) 2014 Shenzhen Coship Electronics Co.,ltd. All rights reserved.
//


@class MediaPlayerController;

@protocol MediaPlayerControllerDelegate <NSObject>

- (void)mediaPlayerControllerAskForEnterFullScreen:(MediaPlayerController *)playerController;
- (void)mediaPlayerControllerAskForExitFullScreen:(MediaPlayerController *)playerController;

@end

