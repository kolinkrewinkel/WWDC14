//
//  KKRIntroViewController.m
//  Kolin Krewinkel
//
//  Created by Kolin Krewinkel on 4/12/14.
//  Copyright (c) 2014 Kolin Krewinkel. All rights reserved.
//

#import "KKRIntroViewController.h"

#import <FXBlurView/FXBlurView.h>

@interface KKRIntroViewController ()

@property (nonatomic, strong) FXBlurView *blurView;
@property (nonatomic, strong) UIView *dimView;

@end

@implementation KKRIntroViewController

- (void)viewDidLoad
{
    [self setNeedsStatusBarAppearanceUpdate];

    [super viewDidLoad];

    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"self-1.png"]];
    backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:backgroundView];
    [self.view kkr_addContraintsToFillSuperviewToView:backgroundView];

    self.blurView = ({
        FXBlurView *blurView = [[FXBlurView alloc] init];
        blurView.underlyingView = backgroundView;
        blurView.tintColor = [UIColor blackColor];
        blurView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
        [self.view addSubview:blurView];
        [self.view kkr_addContraintsToFillSuperviewToView:blurView];

        blurView;
    });

    self.dimView = ({
        UIView *dimView = [[UIView alloc] init];
        dimView.alpha = 0.4f;
        dimView.backgroundColor = [UIColor blackColor];
        [self.view insertSubview:dimView belowSubview:self.blurView];
        [self.view kkr_addContraintsToFillSuperviewToView:dimView];

        dimView;
    });

    UIView *viewOverlay = [[UIView alloc] init];
    viewOverlay.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.f];
    [self.view addSubview:viewOverlay];
    [self.view kkr_addContraintsToFillSuperviewToView:viewOverlay];

    NSString *nameText = @"Kolin Krewinkel";
    UIFont *nameFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:48.f];

    UILabel *name = ({
        UILabel *name = [[UILabel alloc] initWithFrame:({
            CGSize size = [nameText sizeWithAttributes:@{NSFontAttributeName: nameFont}];
            CGRect rect = CGRectMake(64.f, self.view.bounds.size.height - (64.f + 130.f), size.width, size.height);

            rect;
        })];
        name.font = nameFont;
        name.text = nameText;
        name.textColor = [UIColor whiteColor];
        name.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:name];

        name;
    });

    NSString *titleText = @"Software Developer";
    UIFont *titleFont = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:24.f];

    UILabel *title = ({
        UILabel *title = [[UILabel alloc] initWithFrame:({
            CGSize size = [titleText sizeWithAttributes:@{NSFontAttributeName: titleFont}];
            CGRect rect = CGRectMake(64.f, self.view.bounds.size.height - (64.f + 36.f), size.width, size.height);

            rect;
        })];

        title.font = titleFont;
        title.text = titleText;
        title.textColor = [UIColor whiteColor];
        title.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:title];

        title;
    });

    NSLayoutConstraint *titleLeft = [NSLayoutConstraint constraintWithItem:title attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.f constant:64.f];
    [title kkr_setLeftConstraint:titleLeft];

    NSLayoutConstraint *titleBottom = [NSLayoutConstraint constraintWithItem:title attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.f constant:-64.f];
    [title kkr_setBottomConstraint:titleBottom];

    NSLayoutConstraint *nameLeft = [NSLayoutConstraint constraintWithItem:name attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.f constant:64.f];
    [name kkr_setLeftConstraint:nameLeft];

    NSLayoutConstraint *nameBottom = [NSLayoutConstraint constraintWithItem:name attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:title attribute:NSLayoutAttributeTop multiplier:1.f constant:0.f];
    [name kkr_setBottomConstraint:nameBottom];

    [self.view addConstraints:@[titleLeft, titleBottom, nameLeft, nameBottom]];

    self.transition = [KKRIntroInteractiveTransition interactiveTransitionWithNameLabel:name titleLabel:title backgroundOverlay:viewOverlay];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [UIView animateWithDuration:1.5 animations:^{
        self.blurView.alpha = 0.f;
        
    } completion:^(BOOL finished) {
        [self.blurView removeFromSuperview];
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
