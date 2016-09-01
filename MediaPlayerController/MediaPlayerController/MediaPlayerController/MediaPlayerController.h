//
//  MediaPlayerController.h
//  MediaPlayerController
//
//  Created by kinglonghuang on 1/23/14.
//  Copyright (c) 2014 Shenzhen Coship Electronics Co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MPMoviePlayerController.h>
#import "MediaResource.h"
#import "MediaPlayerProtocol.h"

@interface MediaPlayerController : NSObject <MPMediaPlayback>

@property (nonatomic, assign) id <MediaPlayerControllerDelegate> delegate;
@property (nonatomic, readonly) UIView *view;
@property(nonatomic) MPMovieControlStyle controlStyle;

- (id)initWithMediaResource:(MediaResource *)mediaResource;

@end


