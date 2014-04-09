//
//  KKRTimelineViewController.m
//  Kolin Krewinkel
//
//  Created by Kolin Krewinkel on 4/8/14.
//  Copyright (c) 2014 Kolin Krewinkel. All rights reserved.
//

#import "KKRTimelineViewController.h"

#import "KKRTimelineManager.h"

#import "KKRScrollViewParallaxer.h"

@interface KKRTimelineViewController ()

@property (nonatomic, strong) KKRScrollViewParallaxer *scrollViewParallaxer;

@end

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

    self.scrollViewParallaxer = [KKRScrollViewParallaxer parallaxerForScrollView:self.scrollView originalDelegate:self dataSource:self];
}

#pragma mark - KKRScrollViewParallaxer

- (NSUInteger)numberOfItemsParallaxedInParallaxer:(KKRScrollViewParallaxer *)parallaxer
{
    return 50;
}

- (UIView *)viewAtIndex:(NSUInteger)index inParallaxer:(KKRScrollViewParallaxer *)parallaxer
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(50.f, (50.f * index) + (10.f * (index - 1)), 50.f, 50.f)];
    view.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.6f];

    return view;
}

- (CGFloat)movementFractionalForViewAtIndex:(NSUInteger)index inParallaxer:(KKRScrollViewParallaxer *)parallaxer
{
    return 0.7f;
}


@end
