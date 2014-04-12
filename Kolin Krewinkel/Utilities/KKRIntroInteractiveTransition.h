//
//  KKRIntroInteractiveTransition.h
//  Kolin Krewinkel
//
//  Created by Kolin Krewinkel on 4/12/14.
//  Copyright (c) 2014 Kolin Krewinkel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKRIntroInteractiveTransition : UIPercentDrivenInteractiveTransition

+ (instancetype)interactiveTransitionWithNameLabel:(UILabel *)nameLabel titleLabel:(UILabel *)titleLabel backgroundOverlay:(UIView *)backgroundOverlay;

@end
