//
//  LZXViewController.h
//  ScreenRecorderDemo
//
//  Created by 白冰 on 13-7-25.
//  Copyright (c) 2013年 . All rights reserved.
//


#import <UIKit/UIKit.h>

@class DrawView;
@class ScreenRecorder;

@interface LZXViewController : UIViewController
{
    DrawView *myDrawView;
    ScreenRecorder *myScreenRecorder;
    UIWebView *movieShow;
	BOOL isReload;
}

@end
