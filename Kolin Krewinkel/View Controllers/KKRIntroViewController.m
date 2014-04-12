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

}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
