//
//  KKRIntroViewController.m
//  Kolin Krewinkel
//
//  Created by Kolin Krewinkel on 4/12/14.
//  Copyright (c) 2014 Kolin Krewinkel. All rights reserved.
//

#import "KKRIntroViewController.h"

#import <FXBlurView/FXBlurView.h>
#import <Shimmer/FBShimmeringView.h>

@interface KKRIntroViewController ()

@property (nonatomic, strong) FXBlurView *blurView;
@property (nonatomic, strong) UIView *dimView;
@property (nonatomic, strong) FBShimmeringView *shimmeringContainerView;

@end

@implementation KKRIntroViewController

- (void)viewDidLoad
{
    [self setNeedsStatusBarAppearanceUpdate];

    [super viewDidLoad];

    self.view.clipsToBounds = YES;

    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"self-1.png"]];
    backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:backgroundView];
    [self.view kkr_addContraintsToFillSuperviewToView:backgroundView padding:self.view.bounds.size.height/16.f];

    self.blurView = ({
        FXBlurView *blurView = [[FXBlurView alloc] init];
        blurView.underlyingView = backgroundView;
        blurView.tintColor = [UIColor blackColor];
        blurView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
        [self.view addSubview:blurView];
        [self.view kkr_addContraintsToFillSuperviewToView:blurView padding:0.f];

        blurView;
    });

    self.dimView = ({
        UIView *dimView = [[UIView alloc] init];
        dimView.alpha = 0.4f;
        dimView.backgroundColor = [UIColor blackColor];
        [self.view insertSubview:dimView belowSubview:self.blurView];
        [self.view kkr_addContraintsToFillSuperviewToView:dimView padding:0.f];

        dimView;
    });

    UIView *viewOverlay = [[UIView alloc] init];
    viewOverlay.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.f];
    [self.view addSubview:viewOverlay];
    [self.view kkr_addContraintsToFillSuperviewToView:viewOverlay padding:2.f];

    NSString *nameText = @"Kolin Krewinkel";
    UIFont *nameFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:48.f];

    self.shimmeringContainerView = ({
        FBShimmeringView *view = [[FBShimmeringView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.bounds.size.width, self.view.bounds.size.height)];
        view.shimmering = YES;
        view.shimmeringSpeed = 350.f;
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:view];

        view;
    });

    UIView *shimmerContents = [[UIView alloc] init];

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
        [shimmerContents addSubview:name];

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
        [shimmerContents addSubview:title];

        title;
    });

    self.shimmeringContainerView.contentView = shimmerContents;
    [self.shimmeringContainerView kkr_addContraintsToFillSuperviewToView:shimmerContents padding:0.f];

//    [self.view addConstraints:@[[NSLayoutConstraint constraintWithItem:shimmerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.f constant:-250.f], [NSLayoutConstraint constraintWithItem:shimmerView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.f constant:0.f], [NSLayoutConstraint constraintWithItem:shimmerView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.f constant:10.f]]];

    NSLayoutConstraint *titleLeft = [NSLayoutConstraint constraintWithItem:title attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.f constant:64.f];
    [title kkr_setLeftConstraint:titleLeft];

    NSLayoutConstraint *titleBottom = [NSLayoutConstraint constraintWithItem:title attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.f constant:-64.f];
    [title kkr_setBottomConstraint:titleBottom];

    NSLayoutConstraint *nameLeft = [NSLayoutConstraint constraintWithItem:name attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.f constant:64.f];
    [name kkr_setLeftConstraint:nameLeft];

    NSLayoutConstraint *nameBottom = [NSLayoutConstraint constraintWithItem:name attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationLessThanOrEqual toItem:title attribute:NSLayoutAttributeTop multiplier:1.f constant:0.f];
    [name kkr_setBottomConstraint:nameBottom];

    [self.view addConstraints:@[titleLeft, titleBottom, nameLeft, nameBottom]];

    [self addMotionEffectsToView:title withMaxValue:self.view.bounds.size.height/32.f];
    [self addMotionEffectsToView:name withMaxValue:self.view.bounds.size.height/32.f];
    [self addMotionEffectsToView:backgroundView withMaxValue:self.view.bounds.size.height/16.f];

    self.transition = [KKRIntroInteractiveTransition interactiveTransitionWithNameLabel:name titleLabel:title backgroundOverlay:viewOverlay shimmerView:self.shimmeringContainerView];
}

- (void)addMotionEffectsToView:(UIView *)view withMaxValue:(CGFloat)maxValue
{
    [view addMotionEffect:({
        UIInterpolatingMotionEffect *effect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        effect.maximumRelativeValue = @(maxValue);
        effect.minimumRelativeValue = @(-maxValue);

        effect;
    })];
    [view addMotionEffect:({
        UIInterpolatingMotionEffect *effect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        effect.maximumRelativeValue = @(maxValue);
        effect.minimumRelativeValue = @(-maxValue);

        effect;
    })];}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [UIView animateWithDuration:1.5 animations:^{
        self.blurView.alpha = 0.f;
        
    } completion:^(BOOL finished) {
        [self.blurView removeFromSuperview];
    }];

    [self.transition startInteractiveTransition:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    [self.transition resetTransforms];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
