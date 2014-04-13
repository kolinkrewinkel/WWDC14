//
//  KKRIntroInteractiveTransition.m
//  Kolin Krewinkel
//
//  Created by Kolin Krewinkel on 4/12/14.
//  Copyright (c) 2014 Kolin Krewinkel. All rights reserved.
//

#import "KKRIntroInteractiveTransition.h"

@interface KKRIntroInteractiveTransition ()

@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIView *backgroundOverlay;

@end

@implementation KKRIntroInteractiveTransition

+ (instancetype)interactiveTransitionWithNameLabel:(UILabel *)nameLabel titleLabel:(UILabel *)titleLabel backgroundOverlay:(UIView *)backgroundOverlay
{
    KKRIntroInteractiveTransition *transition = [[[self class] alloc] init];
    transition.nameLabel = nameLabel;
    transition.titleLabel = titleLabel;
    transition.backgroundOverlay = backgroundOverlay;

    [transition updateInteractiveTransition:0.f];

    return transition;
}

- (void)updateInteractiveTransition:(CGFloat)percentComplete
{
    [super updateInteractiveTransition:percentComplete];

    UIView *superview = self.nameLabel.superview;

    if (percentComplete <= .5f)
    {
        CGFloat relCompletion = percentComplete/.5f;

        self.nameLabel.textColor = [UIColor whiteColor];
        self.titleLabel.textColor = [UIColor whiteColor];

        self.nameLabel.alpha = 1.f - relCompletion;
        self.titleLabel.alpha = 1.f - (MIN((relCompletion - .25f)/.75f, 1.f));

        self.nameLabel.transform = CGAffineTransformIdentity;
        self.titleLabel.transform = CGAffineTransformIdentity;

        self.nameLabel.kkr_leftConstraint.constant = 64.f;
        self.titleLabel.kkr_leftConstraint.constant = 64.f;

        self.nameLabel.kkr_bottomConstraint.constant = 0.f;
        self.titleLabel.kkr_bottomConstraint.constant = -64.f;

        self.backgroundOverlay.backgroundColor = [UIColor colorWithWhite:1.f alpha:0.f];
    }
    else
    {
        CGFloat relCompletion = (percentComplete - .5f)/.5f;

        self.nameLabel.textColor = [UIColor blackColor];
        self.titleLabel.textColor = [UIColor blackColor];

        self.nameLabel.alpha = relCompletion;
        self.titleLabel.alpha = relCompletion;

        self.nameLabel.transform = CGAffineTransformMakeRotation(-90.f * (M_PI / 180.f));
        self.titleLabel.transform = CGAffineTransformMakeRotation(-90.f * (M_PI / 180.f));

        self.nameLabel.kkr_leftConstraint.constant = superview.bounds.size.width - (relCompletion * self.nameLabel.bounds.size.height);
        self.titleLabel.kkr_leftConstraint.constant = (superview.bounds.size.width - (relCompletion * self.titleLabel.bounds.size.height)) - 5.f;

        self.titleLabel.kkr_bottomConstraint.constant = -1.f * (64.f + self.nameLabel.bounds.size.width);
        self.nameLabel.kkr_bottomConstraint.constant = -self.titleLabel.kkr_bottomConstraint.constant - (64.f * 2.f);

        self.backgroundOverlay.backgroundColor = [UIColor colorWithWhite:1.f alpha:relCompletion];
    }

    [superview layoutIfNeeded];
}

@end
