//
//  UIView+DSSCustomSizedMethods.h
//  AirplayTest
//
//  Created by dasmer on 2/4/14.
//  Copyright (c) 2014 Columbia University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DSSCustomSizedMethods)
- (CGRect) frameAtXRatio: (CGFloat)xRatio yRatio: (CGFloat)yRatio widthRatio: (CGFloat)widthRatio heightRatio: (CGFloat)heightRatio;

- (CGRect) frameAtCenterXAndYRatio: (CGFloat)yRatio widthRatio: (CGFloat)widthRatio heightRatio: (CGFloat)heightRatio;

- (CGRect) frameAtCenterYAndXRatio: (CGFloat)xRatio widthRatio: (CGFloat)widthRatio heightRatio: (CGFloat)heightRatio;

- (CGRect) frameAtCenterAndWidthRatio: (CGFloat)widthRatio heightRatio: (CGFloat)heightRatio;
@end
