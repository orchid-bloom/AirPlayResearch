//
//  UIView+DSSCustomSizedMethods.m
//  AirplayTest
//
//  Created by dasmer on 2/4/14.
//  Copyright (c) 2014 Columbia University. All rights reserved.
//

#import "UIView+DSSCustomSizedMethods.h"

@implementation UIView (DSSCustomSizedMethods)

const CGFloat MaxAllowableRatio = 1.0f;
- (CGRect) frameAtXRatio: (CGFloat)xRatio yRatio: (CGFloat)yRatio widthRatio: (CGFloat)widthRatio heightRatio: (CGFloat)heightRatio{
    if (xRatio + widthRatio <= MaxAllowableRatio && yRatio + widthRatio <= MaxAllowableRatio){
        CGFloat selfWidth = CGRectGetWidth(self.bounds);
        CGFloat selfHeight = CGRectGetHeight(self.bounds);
        CGFloat width = widthRatio * selfWidth;
        CGFloat height = heightRatio * selfHeight;
        CGFloat x = xRatio * selfWidth;
        CGFloat y = yRatio * selfHeight;
        return CGRectMake(x, y, width, height);
    }
    return CGRectMake(0, 0, 0, 0);
}

- (CGRect) frameAtCenterXAndYRatio: (CGFloat)yRatio widthRatio: (CGFloat)widthRatio heightRatio: (CGFloat)heightRatio{
    if (widthRatio <= MaxAllowableRatio && yRatio + widthRatio <= MaxAllowableRatio){
        CGFloat selfWidth = CGRectGetWidth(self.bounds);
        CGFloat selfHeight = CGRectGetHeight(self.bounds);
        CGFloat width = widthRatio * selfWidth;
        CGFloat height = heightRatio * selfHeight;
        CGFloat x = selfWidth/2 - width/2;
        CGFloat y = yRatio * selfHeight;
        return CGRectMake(x, y, width, height);
    }
    return CGRectMake(0, 0, 0, 0);
}

- (CGRect) frameAtCenterYAndXRatio: (CGFloat)xRatio widthRatio: (CGFloat)widthRatio heightRatio: (CGFloat)heightRatio{
    if (xRatio + widthRatio <= MaxAllowableRatio && widthRatio <= MaxAllowableRatio){
        CGFloat selfWidth = CGRectGetWidth(self.bounds);
        CGFloat selfHeight = CGRectGetHeight(self.bounds);
        CGFloat x = xRatio * selfWidth;
        CGFloat width = widthRatio * selfWidth;
        CGFloat height = heightRatio * selfHeight;
        CGFloat y = selfHeight/2 - height/2;
        return CGRectMake(x, y, width, height);
    }
    return CGRectMake(0, 0, 0, 0);
}

- (CGRect) frameAtCenterAndWidthRatio: (CGFloat)widthRatio heightRatio: (CGFloat)heightRatio{
    if (widthRatio <= MaxAllowableRatio && heightRatio <= MaxAllowableRatio){
        CGFloat selfWidth = CGRectGetWidth(self.bounds);
        CGFloat selfHeight = CGRectGetHeight(self.bounds);
        CGFloat width = widthRatio * selfWidth;
        CGFloat height = heightRatio * selfHeight;
        CGFloat x = selfWidth/2 - width/2;
        CGFloat y = selfHeight/2 - height/2;
        NSLog(@"width = %f and selfWidth = %f",width, selfWidth);
        return CGRectMake(x, y, width, height);
    }
    return CGRectMake(0, 0, 0, 0);
}

@end
