//
//  KKRIntroViewController.m
//  Kolin Krewinkel
//
//  Created by Kolin Krewinkel on 4/12/14.
//  Copyright (c) 2014 Kolin Krewinkel. All rights reserved.
//

#import "KKRIntroViewController.h"

@implementation KKRIntroViewController

- (void)viewDidLoad
{
    [self setNeedsStatusBarAppearanceUpdate];

    [super viewDidLoad];

    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"self-1.png"]];
    backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:backgroundView];
    [self.view kkr_addContraintsToFillSuperviewToView:backgroundView];

    UIView *overlayView = [[UIView alloc] init];
    overlayView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    [self.view addSubview:overlayView];
    [self.view kkr_addContraintsToFillSuperviewToView:overlayView];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
