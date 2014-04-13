//
//  UIView+KKRConstraintHelpers.h
//  Kolin Krewinkel
//
//  Created by Kolin Krewinkel on 4/12/14.
//  Copyright (c) 2014 Kolin Krewinkel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView (KKRConstraintHelpers)

- (void)kkr_addContraintsToFillSuperviewToView:(UIView *)view padding:(CGFloat)padding;

- (void)kkr_setTopConstraint:(NSLayoutConstraint *)constraint;
- (NSLayoutConstraint *)kkr_topConstraint;

- (void)kkr_setRightConstraint:(NSLayoutConstraint *)constraint;
- (NSLayoutConstraint *)kkr_rightConstraint;

- (void)kkr_setBottomConstraint:(NSLayoutConstraint *)constraint;
- (NSLayoutConstraint *)kkr_bottomConstraint;

- (void)kkr_setLeftConstraint:(NSLayoutConstraint *)constraint;
- (NSLayoutConstraint *)kkr_leftConstraint;

@end
