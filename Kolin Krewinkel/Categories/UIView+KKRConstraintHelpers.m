//
//  UIView+KKRConstraintHelpers.m
//  Kolin Krewinkel
//
//  Created by Kolin Krewinkel on 4/12/14.
//  Copyright (c) 2014 Kolin Krewinkel. All rights reserved.
//

#import "UIView+KKRConstraintHelpers.h"

#import <objc/runtime.h>

static char *KKRConstraintTopIdentifier = "KKRConstraintTopIdentifier";
static char *KKRConstraintRightIdentifier = "KKRConstraintRightIdentifier";
static char *KKRConstraintBottomIdentifier = "KKRConstraintBottomIdentifier";
static char *KKRConstraintLeftIdentifier = "KKRConstraintLeftIdentifier";

@implementation UIView (KKRConstraintHelpers)

- (void)kkr_addContraintsToFillSuperviewToView:(UIView *)view
{
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraints:({
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.f constant:0.f];

        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.f constant:0.f];

        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.f constant:0.f];

        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.f constant:0.f];

        @[top, left, right, bottom];
    })];
}

- (void)kkr_setTopConstraint:(NSLayoutConstraint *)constraint
{
    objc_setAssociatedObject(self, KKRConstraintTopIdentifier, constraint, OBJC_ASSOCIATION_ASSIGN);
}

- (NSLayoutConstraint *)kkr_topConstraint
{
    return objc_getAssociatedObject(self, KKRConstraintTopIdentifier);
}

- (void)kkr_setRightConstraint:(NSLayoutConstraint *)constraint
{
    objc_setAssociatedObject(self, KKRConstraintRightIdentifier, constraint, OBJC_ASSOCIATION_ASSIGN);
}

- (NSLayoutConstraint *)kkr_rightConstraint
{
    return objc_getAssociatedObject(self, KKRConstraintRightIdentifier);

}

- (void)kkr_setBottomConstraint:(NSLayoutConstraint *)constraint
{
    objc_setAssociatedObject(self, KKRConstraintBottomIdentifier, constraint, OBJC_ASSOCIATION_ASSIGN);
}

- (NSLayoutConstraint *)kkr_bottomConstraint
{
    return objc_getAssociatedObject(self, KKRConstraintBottomIdentifier);

}

- (void)kkr_setLeftConstraint:(NSLayoutConstraint *)constraint
{
    objc_setAssociatedObject(self, KKRConstraintLeftIdentifier, constraint, OBJC_ASSOCIATION_ASSIGN);
}

- (NSLayoutConstraint *)kkr_leftConstraint
{
    return objc_getAssociatedObject(self, KKRConstraintLeftIdentifier);
}

@end
