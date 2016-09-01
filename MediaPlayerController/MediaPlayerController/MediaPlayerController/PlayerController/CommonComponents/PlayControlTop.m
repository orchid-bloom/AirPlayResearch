//
//  PlayControlTop.m
//  MediaPlayerController
//
//  Created by lingmin on 14-1-27.
//  Copyright (c) 2014年 Shenzhen Coship Electronics Co.,ltd. All rights reserved.
//

#import "PlayControlTop.h"

@implementation PlayControlTop

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUIComponents];
    }
    return self;
}

- (void)initUIComponents {
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton setBackgroundColor:[UIColor redColor]];
    _backButton.frame = CGRectMake(20, 10, 40, 24);
    [_backButton setTitle:FKLocalized(@"返回") forState:UIControlStateNormal];
    [_backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_backButton];

}

#pragma mark  action
- (void)backAction:(id)sender{
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(playControlTop:operateType:)]) {
        [self.delegate playControlTop:self operateType:PlayControlTopOperate_Back];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
