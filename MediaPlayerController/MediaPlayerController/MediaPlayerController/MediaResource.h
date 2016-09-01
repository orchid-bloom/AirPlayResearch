//
//  MediaResource.h
//  MediaPlayerController
//
//  Created by kinglonghuang on 1/23/14.
//  Copyright (c) 2014 Shenzhen Coship Electronics Co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MediaResourceType) {
    MediaResourceType_Vod            = 1,
    MediaResourceType_TVLive         = 2,
    MediaResourceType_LiveProgram    = 3,
    MediaResourceType_Teleplay       = 4
};

@interface MediaResource : NSObject

@property (nonatomic, strong) id content;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, assign) MediaResourceType type;

@end
