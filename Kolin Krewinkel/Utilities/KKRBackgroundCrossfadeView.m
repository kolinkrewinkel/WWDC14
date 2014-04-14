//
//  KKRBackgroundCrossfadeView.m
//  Kolin Krewinkel
//
//  Created by Kolin Krewinkel on 4/13/14.
//  Copyright (c) 2014 Kolin Krewinkel. All rights reserved.
//

#import "KKRBackgroundCrossfadeView.h"

@interface KKRBackgroundCrossfadeView ()

@property (nonatomic, strong) UIImageView *imageViewPrimary;
@property (nonatomic, strong) UIImageView *imageViewSecondary;

@end

@implementation KKRBackgroundCrossfadeView

- (id)init
{
    if ((self = [super init]))
    {
        CGFloat maxValue = 64.f;

        self.imageViewPrimary = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            [self addSubview:imageView];

            [self kkr_addContraintsToFillSuperviewToView:imageView padding:maxValue];

            imageView;
        });

        self.imageViewSecondary = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            [self insertSubview:imageView aboveSubview:self.imageViewPrimary];

            [self kkr_addContraintsToFillSuperviewToView:imageView padding:maxValue];

            imageView;
        });
        
        [self addMotionEffect:({
            UIInterpolatingMotionEffect *effect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
            effect.maximumRelativeValue = @(maxValue);
            effect.minimumRelativeValue = @(-maxValue);

            effect;
        })];

        [self addMotionEffect:({
            UIInterpolatingMotionEffect *effect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
            effect.maximumRelativeValue = @(maxValue);
            effect.minimumRelativeValue = @(-maxValue);

            effect;
        })];

        self.transition = [KKRBackgroundCrossfadeTransition transitionWithPrimaryView:self.imageViewPrimary secondaryView:self.imageViewSecondary crossfadeView:self];
    }

    return self;
}

- (void)setCurrentImage:(UIImage *)currentImage
{
    _currentImage = currentImage;

    self.imageViewPrimary.image = currentImage;
}

- (void)setNextImage:(UIImage *)nextImage
{
    if (self.imageViewPrimary.image)
    {
        _nextImage = nextImage;

        self.imageViewSecondary.image = self.nextImage;
    }
    else
    {
        self.currentImage = nextImage;
    }
}

- (void)transferImages
{
    self.currentImage = self.nextImage;
    self.nextImage = nil;
}

@end

@interface KKRBackgroundCrossfadeTransition ()

@property (nonatomic, weak) UIView *primaryView;
@property (nonatomic, weak) UIView *secondaryView;

@property (nonatomic, weak) KKRBackgroundCrossfadeView *crossfadeView;

@end

@implementation KKRBackgroundCrossfadeTransition

+ (instancetype)transitionWithPrimaryView:(UIView *)primaryView secondaryView:(UIView *)secondaryView crossfadeView:(KKRBackgroundCrossfadeView *)crossfadeView
{
    KKRBackgroundCrossfadeTransition *transition = [[[self class] alloc] init];
    transition.primaryView = primaryView;
    transition.secondaryView = secondaryView;
    transition.crossfadeView = crossfadeView;

    return transition;
}

- (void)updateInteractiveTransition:(CGFloat)percentComplete
{
    [super updateInteractiveTransition:percentComplete];

    self.primaryView.alpha = 1.f - percentComplete;
    self.secondaryView.alpha = percentComplete;

    if (percentComplete >= 1.f && self.crossfadeView.nextImage)
    {
        [self.crossfadeView transferImages];
    }
}

@end