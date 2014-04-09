//
//  KKRTimelineViewController.m
//  Kolin Krewinkel
//
//  Created by Kolin Krewinkel on 4/8/14.
//  Copyright (c) 2014 Kolin Krewinkel. All rights reserved.
//

#import "KKRTimelineViewController.h"

#import "KKRTimelineManager.h"

@implementation KKRTimelineViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setUpInterface];
//    [KKRTimelineManager sharedManager] fet
}

- (void)setUpInterface
{
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 5000.f);
    self.scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;

    self.view = self.scrollView;
}

@end
