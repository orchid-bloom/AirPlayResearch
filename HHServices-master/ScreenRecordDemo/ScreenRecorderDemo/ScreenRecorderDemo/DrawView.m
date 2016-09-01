//
//  DrawView.m
//  ScreenRecorderDemo
//
//  Created by 白冰 on 13-7-25.
//  Copyright (c) 2013年 . All rights reserved.
//

#import "DrawView.h"

#define defaultLineWidth 5.0

@implementation DrawView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES; //Enable it, otherwise we cannot draw anything :(
        previousPoint2 = CGPointZero; //2 points behind
        previousPoint1 = CGPointZero; //1 point behind
        lastPoint = CGPointZero;
        mouseSwiped = NO;
        mouseMoved = 0;
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

CGPoint midPoint(CGPoint p1, CGPoint p2)
{
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}

- (void)updatePoint:(CGPoint)newPoint {
    previousPoint2 = previousPoint1;
    previousPoint1 = lastPoint;
    lastPoint = newPoint;
}

-(void)drawLine:(CGPoint)fPoint toPoint:(CGPoint)tPoint controlPoint:(CGPoint)cPoint
{
    UIGraphicsBeginImageContext(self.frame.size);
	[self.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
	CGContextSetLineWidth(UIGraphicsGetCurrentContext(), defaultLineWidth);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 0.0, 0.5, 1.0);
	CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), fPoint.x, fPoint.y);
    //for drawing curve
	CGContextAddQuadCurveToPoint(UIGraphicsGetCurrentContext(), cPoint.x, cPoint.y, tPoint.x, tPoint.y);
	//CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), tPoint.x, tPoint.y);
	CGContextStrokePath(UIGraphicsGetCurrentContext());
	self.image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
}

-(void)drawCurve:(BOOL)isFinal
{
    CGPoint mid1 = midPoint(previousPoint1, previousPoint2);
    CGPoint mid2 = midPoint(lastPoint, previousPoint1);
    
    //for drawing the beginning line
    if (!mouseSwiped)
    {
        CGPoint midTemp = midPoint(previousPoint2, mid1);
        [self drawLine:previousPoint2 toPoint:mid1 controlPoint:midTemp];
    }
    
    [self drawLine:mid1 toPoint:mid2 controlPoint:previousPoint1];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
	mouseSwiped = NO;
	UITouch *touch = [touches anyObject];
	
	lastPoint = [touch locationInView:self];
    
    previousPoint2 = lastPoint;
    previousPoint1 = lastPoint;
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
	UITouch *touch = [touches anyObject];
	CGPoint currentPoint = [touch locationInView:self];
    
    [self updatePoint:currentPoint];
    
    if (!CGPointEqualToPoint(previousPoint2, CGPointZero))
    {
        [self drawCurve:NO];
    }
    
	mouseMoved++;
	
	if (mouseMoved == 10) {
		mouseMoved = 0;
	}
    
    mouseSwiped = YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    
    [self updatePoint:currentPoint];
	
    //for better performance
    if (!mouseSwiped)
    {
        if (!CGPointEqualToPoint(previousPoint2, CGPointZero))
        {
            [self drawCurve:YES];
        }
    }
    
    //for double tap to clean the image
    if ([touch tapCount]==2)
    {
        self.image = nil;
    }
}

@end
