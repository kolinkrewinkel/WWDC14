//
//  KKRIntroInteractiveTransition.m
//  Kolin Krewinkel
//
//  Created by Kolin Krewinkel on 4/12/14.
//  Copyright (c) 2014 Kolin Krewinkel. All rights reserved.
//

#import "KKRIntroInteractiveTransition.h"

#import <Shimmer/FBShimmeringView.h>

@interface KKRIntroInteractiveTransition ()

@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIView *backgroundOverlay;
@property (nonatomic, weak) FBShimmeringView *shimmerView;
@property (nonatomic) BOOL canUpdate;

@end

@implementation KKRIntroInteractiveTransition

+ (instancetype)interactiveTransitionWithNameLabel:(UILabel *)nameLabel titleLabel:(UILabel *)titleLabel backgroundOverlay:(UIView *)backgroundOverlay shimmerView:(FBShimmeringView *)shimmerView
{
    KKRIntroInteractiveTransition *transition = [[[self class] alloc] init];
    transition.nameLabel = nameLabel;
    transition.titleLabel = titleLabel;
    transition.backgroundOverlay = backgroundOverlay;
    transition.shimmerView = shimmerView;
    transition.canUpdate = YES;

    [transition updateInteractiveTransition:0.f];

    return transition;
}

- (void)updateInteractiveTransition:(CGFloat)percentComplete
{
    [super updateInteractiveTransition:percentComplete];

    if (!self.canUpdate)
    {
        return;
    }

    UIView *superview = self.nameLabel.superview;

    if (percentComplete <= .5f)
    {
        CGFloat relCompletion = percentComplete/.5f;

        self.nameLabel.textColor = [UIColor whiteColor];
        self.titleLabel.textColor = [UIColor whiteColor];

        self.nameLabel.alpha = 1.f - relCompletion;
        self.titleLabel.alpha = 1.f - (MIN((relCompletion - .25f)/.75f, 1.f));

        self.nameLabel.kkr_leftConstraint.constant = 64.f - (relCompletion * 64.f * 2.f);
        self.titleLabel.kkr_leftConstraint.constant = 64.f - (relCompletion * 64.f * 2.f);

        self.backgroundOverlay.backgroundColor = [UIColor colorWithWhite:1.f alpha:0.f];

        self.nameLabel.layer.anchorPoint = CGPointMake(0.5f, 0.5f);
        self.titleLabel.layer.anchorPoint = CGPointMake(0.5f, 0.5f);

        [self.nameLabel.layer setAffineTransform:CGAffineTransformIdentity];
        [self.titleLabel.layer setAffineTransform:CGAffineTransformIdentity];

        if (self.nameLabel.kkr_bottomConstraint.constant == self.nameLabel.bounds.size.width)
        {
            self.nameLabel.kkr_bottomConstraint.constant = 0.f;
        }

        if (self.titleLabel.kkr_bottomConstraint.constant == -(self.nameLabel.bounds.size.width + self.titleLabel.bounds.size.width) + self.nameLabel.bounds.size.height)
        {
            self.titleLabel.kkr_bottomConstraint.constant = -64.f;
        }
    }
    else
    {
        CGFloat relCompletion = (percentComplete - .5f)/.5f;

        self.nameLabel.textColor = [UIColor blackColor];
        self.titleLabel.textColor = [UIColor blackColor];

        self.nameLabel.alpha = relCompletion;
        self.titleLabel.alpha = relCompletion;

        self.nameLabel.layer.anchorPoint = CGPointZero;
        self.titleLabel.layer.anchorPoint = CGPointZero;

        [self.nameLabel.layer setAffineTransform:CGAffineTransformMakeRotation(-90.f * (M_PI / 180.f))];
        [self.titleLabel.layer setAffineTransform:CGAffineTransformMakeRotation(-90.f * (M_PI / 180.f))];

        self.nameLabel.kkr_leftConstraint.constant = (superview.bounds.size.width - (96.f * relCompletion)) + ((96.f/2.f) - (self.nameLabel.bounds.size.height));
        self.titleLabel.kkr_leftConstraint.constant = (superview.bounds.size.width - (96.f * relCompletion)) + ((96.f/2.f) - (self.titleLabel.bounds.size.height)) + 2.f;

        self.titleLabel.kkr_bottomConstraint.constant = -(self.nameLabel.bounds.size.width + self.titleLabel.bounds.size.width) + self.nameLabel.bounds.size.height;
        self.nameLabel.kkr_bottomConstraint.constant = self.nameLabel.bounds.size.width;

        self.backgroundOverlay.backgroundColor = [UIColor colorWithWhite:1.f alpha:relCompletion];
    }

    self.shimmerView.shimmering = (percentComplete <= .1f);

    [superview layoutIfNeeded];
}

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    [super startInteractiveTransition:transitionContext];

    self.canUpdate = YES;
}

- (void)resetTransforms
{
    [self finishInteractiveTransition];
    self.canUpdate = NO;

    [self.nameLabel.layer setAffineTransform:CGAffineTransformIdentity];
    [self.titleLabel.layer setAffineTransform:CGAffineTransformIdentity];

    self.nameLabel.kkr_leftConstraint.constant = 64.f;
    self.titleLabel.kkr_leftConstraint.constant = 64.f;

    self.nameLabel.kkr_bottomConstraint.constant = 0.f;
    self.titleLabel.kkr_bottomConstraint.constant = -64.f;
}

@end
