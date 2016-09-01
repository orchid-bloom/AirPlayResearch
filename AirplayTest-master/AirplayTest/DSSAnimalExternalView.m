//
//  DSSAnimalExternalView.m
//  AirplayTest
//
//  Created by dasmer on 2/4/14.
//  Copyright (c) 2014 Columbia University. All rights reserved.
//

#import "DSSAnimalExternalView.h"
#import "UIView+DSSCustomSizedMethods.h"


@interface DSSAnimalExternalView ()

@property (strong,nonatomic) UIImageView *animalImageView;

@end

@implementation DSSAnimalExternalView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _animalImageView = [[UIImageView alloc] initWithFrame:[self frameAtCenterAndWidthRatio:0.3 heightRatio:0.3]];
        [self addSubview:_animalImageView];
        NSLog(@"externalAnimalImageViewSet");
    }
    return self;
}

- (void)showDog{
    [self.animalImageView setImage:[UIImage imageNamed:@"dog"]];
}

- (void)showCat{
    [self.animalImageView setImage:[UIImage imageNamed:@"cat"]];
}

- (void)showFish{
    [self.animalImageView setImage:[UIImage imageNamed:@"fish"]];
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
