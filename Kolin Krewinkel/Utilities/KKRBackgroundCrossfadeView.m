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
            imageView.backgroundColor = [UIColor greenColor];

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
    self.imageViewPrimary.backgroundColor = [UIColor clearColor];

    if (currentImage.resizingMode == UIImageResizingModeTile)
    {
        self.imageViewPrimary.contentMode = UIViewContentModeTopLeft;
    }
    else
    {
        self.imageViewPrimary.contentMode = UIViewContentModeScaleAspectFill;
    }
}

- (void)setNextImage:(UIImage *)nextImage
{
    BOOL hasColor = self.imageViewPrimary.backgroundColor != [UIColor clearColor];
    BOOL hasImage = self.imageViewPrimary.image != nil;

    if ((hasImage || hasColor) && nextImage)
    {
        _nextImage = nextImage;

        self.imageViewSecondary.image = self.nextImage;
        self.imageViewSecondary.backgroundColor = [UIColor clearColor];
        if (nextImage.resizingMode == UIImageResizingModeTile)
        {
            self.imageViewSecondary.contentMode = UIViewContentModeScaleAspectFill;
        }
        else
        {
            self.imageViewSecondary.contentMode = UIViewContentModeScaleAspectFill;
        }
    }
    else if (nextImage)
    {
        self.currentImage = nextImage;
    }
    else
    {
        _nextImage = nil;
    }
}

- (void)setNextColor:(UIColor *)nextColor
{
    self.nextImage = nil;

    self.imageViewSecondary.backgroundColor = nextColor;
}

- (void)setCurrentColor:(UIColor *)color
{
    self.currentImage = nil;

    self.imageViewPrimary.backgroundColor = color;
}

- (void)transferImages
{
    UIColor *nextColor = self.imageViewSecondary.backgroundColor;
    if (nextColor == [UIColor clearColor])
    {
        nextColor = nil;
    }

    if (!self.nextImage && !nextColor)
    {
        return;
    }

    self.currentImage = self.nextImage;
    if (nextColor)
    {
        [self setCurrentColor:self.imageViewSecondary.backgroundColor];
    }

    self.imageViewPrimary.alpha = 1.f;

    self.nextImage = nil;
    self.imageViewSecondary.alpha = 0.f;
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
    NSLog(@"Primary view alpha: %f, Secondary view alpha: %f, %@", self.primaryView.alpha, self.secondaryView.alpha, self.secondaryView);
    [self.secondaryView.superview bringSubviewToFront:self.secondaryView];

    if (percentComplete >= .99f && self.crossfadeView.nextImage)
    {
        [self.crossfadeView transferImages];
    }
}

@end