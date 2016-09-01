//
//  DrawView.h
//  ScreenRecorderDemo
//
//  Created by 白冰 on 13-7-25.
//  Copyright (c) 2013年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawView : UIImageView
{
    //for drawing curve
    CGPoint previousPoint2; //2 points behind
    CGPoint previousPoint1; //1 point behind
    CGPoint lastPoint;
	BOOL mouseSwiped;
	int mouseMoved;
}

@end