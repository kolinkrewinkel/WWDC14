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

- (void)kkr_addContraintsToFillSuperviewToView:(UIView *)view padding:(CGFloat)padding
{
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraints:({
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.f constant:-padding];

        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.f constant:-padding];

        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.f constant:padding];

        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.f constant:padding];

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

- (void)kkr_setHierarchyIdentifier:(NSString *)string
{
    objc_setAssociatedObject(self, "kkr_hierarchyID", string, OBJC_ASSOCIATION_COPY);
}

- (NSString *)kkr_hierarchyIdentifier
{
    NSMutableString *identifier = [[NSMutableString alloc] initWithString:objc_getAssociatedObject(self, "kkr_hierarchyID")];

    UIView *superview = self.superview;
    while (superview.kkr_hierarchyIdentifier)
    {
        [identifier insertString:[NSString stringWithFormat:@"%@_", superview.kkr_hierarchyIdentifier] atIndex:0];

        superview = superview.superview;
    }

    return identifier;
}

- (UIView *)kkr_relatedViewWithIdentifier:(NSString *)identifier
{
    UIView *uppermost = self;
    NSArray *identifiers = [identifier componentsSeparatedByString:@"_"];

    while (![uppermost.kkr_hierarchyIdentifier isEqualToString:identifiers[0]])
    {
        uppermost = uppermost.superview;
    }

    UIView *view = uppermost;
    for (NSString *ident in [identifiers subarrayWithRange:NSMakeRange(1, identifier.length - 2)])
    {
        view = [[view.subviews filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"kkr_hierarchyIdentifier == %@", ident]] lastObject];
    }

    return view;
}

@end
