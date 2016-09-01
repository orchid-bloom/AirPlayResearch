//
//  VodPlayerController.h
//  MediaPlayerController
//
//  Created by kinglonghuang on 1/23/14.
//  Copyright (c) 2014 Shenzhen Coship Electronics Co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MPMoviePlayerController.h>
#import "VodPlayControlTop.h"
#import "VodPlayControlBar.h"
#import "BasePlayerController.h"

@interface VodPlayerController : BasePlayerController <PlayControlBarDelegate,PlayControlTopDelegate>

@end