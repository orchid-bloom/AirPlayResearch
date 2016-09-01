//
//  PlayControlTop.h
//  MediaPlayerController
//
//  Created by lingmin on 14-1-27.
//  Copyright (c) 2014年 Shenzhen Coship Electronics Co.,ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef   enum{
    PlayControlTopOperate_Back = 0,
    PlayControlTopOperate_Share,
    PlayControlTopOperate_MovieList
    
}PlayControlTopOperate;

@protocol PlayControlTopDelegate;

@interface PlayControlTop : UIView

@property (nonatomic, assign) id <PlayControlTopDelegate> delegate;
@property (nonatomic, strong)UIButton *backButton;
//override
- (void)initUIComponents;

@end

@protocol PlayControlTopDelegate <NSObject>

- (void)playControlTop:(PlayControlTop*)control operateType:(PlayControlTopOperate)operateType;

@end