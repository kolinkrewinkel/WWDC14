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

    return transition;
}

- (void)updateInteractiveTransition:(CGFloat)percentComplete
{
    [super updateInteractiveTransition:percentComplete];

    CGFloat titleCompletion = MIN(percentComplete/.75f, 1.f);
    CGFloat titleConst = -64.f + ((-64.f * titleCompletion)) - ((self.nameLabel.bounds.size.width) * titleCompletion);

    self.nameLabel.kkr_leftConstraint.constant = 64.f + (MIN(percentComplete/.15f, 1.f) * (self.nameLabel.superview.bounds.size.width - (64.f + self.nameLabel.bounds.size.height)));
    CGFloat relCompletion = (MIN(MAX((percentComplete - .05f), 0.f)/.1f, 1.f));
    self.nameLabel.kkr_bottomConstraint.constant = -titleConst - (64.f + (relCompletion * 64.f));
    self.nameLabel.transform = CGAffineTransformMakeRotation(-90.f * relCompletion * (M_PI / 180.f));

    self.titleLabel.kkr_leftConstraint.constant = 64.f + (titleCompletion * (self.nameLabel.superview.bounds.size.width - (64.f + self.nameLabel.bounds.size.height)));
    self.titleLabel.transform = CGAffineTransformMakeRotation(-90.f * titleCompletion * (M_PI / 180.f));
    self.titleLabel.kkr_bottomConstraint.constant = titleConst + (64.f * .5f);



//    if (percentComplete >= .05f)
    {
    }
//    self.titleLabel.kkr_bottomConstraint.constant = -64.f + (-percentComplete * self.nameLabel.bounds.size.width);

    UIColor *crossColor = [UIColor colorWithWhite:(-percentComplete + 1.f) alpha:1.f];
    self.nameLabel.textColor = crossColor;
    self.titleLabel.textColor = crossColor;

    self.backgroundOverlay.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:percentComplete];

    [self.nameLabel.superview layoutIfNeeded];
//    self.nameLabel.frame = CGRectMake(64.f + (percentComplete * (self.nameLabel.superview.frame.size.width - 64.f)), self.nameLabel.frame.origin.y, self.nameLabel.frame.size.width, self.nameLabel.frame.size.height);
}

@end
