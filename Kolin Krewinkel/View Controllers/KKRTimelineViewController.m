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

#import <FXBlurView/FXBlurView.h>

@interface KKRTimelineViewController ()

@property (nonatomic, strong) KKRScrollViewParallaxer *scrollViewParallaxer;

@property (nonatomic, strong) UIView *yearBackgroundView;

@end

@implementation KKRTimelineViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setUpInterface];
}

- (void)setUpInterface
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = YES;
    self.scrollView.autoresizesSubviews = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.scrollView.backgroundColor = [UIColor darkGrayColor];

    [self.view addSubview:self.scrollView];

    self.yearBackgroundView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview:view];

        view;
    });

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 300.f, 30.f)];
    view.backgroundColor = [UIColor redColor];
    [self.scrollView addSubview:view];

    self.scrollViewParallaxer = [KKRScrollViewParallaxer parallaxerForScrollView:self.scrollView originalDelegate:self dataSource:self];
}

- (void)viewDidLayoutSubviews
{
    CGPoint previousOffset = self.scrollView.contentOffset;
    CGFloat prevOffsetX = 0.f;

    if (self.scrollView.contentSize.width > 0.f)
    {
        prevOffsetX = previousOffset.x/self.scrollView.contentSize.width;
    }

    [super viewDidLayoutSubviews];

    self.yearBackgroundView.frame = CGRectMake(-5.f, 0.f, self.scrollView.contentSize.width + 10.f, 64.f + (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) ? [UIApplication sharedApplication].statusBarFrame.size.height : [UIApplication sharedApplication].statusBarFrame.size.width));

    self.scrollView.frame = self.view.bounds;
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width * 2.f * 17.f, 0.f);
    self.scrollView.contentOffset = CGPointMake(prevOffsetX * self.scrollView.contentSize.width, 0.f);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

#pragma mark - KKRScrollViewParallaxer

- (NSUInteger)numberOfItemsParallaxedInParallaxer:(KKRScrollViewParallaxer *)parallaxer
{
    return 17;
}

- (UIView *)viewAtIndex:(NSUInteger)index inParallaxer:(KKRScrollViewParallaxer *)parallaxer
{
    if (index < 17)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = [NSString stringWithFormat:@"%lu", 1998 + index];
        label.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:36.f];
        label.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.8f];

        return label;
    }
    else if (index < 34)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor whiteColor];

        return view;
    }

    return nil;
}

- (CGRect)initialRectForViewAtIndex:(NSUInteger)index inParallaxer:(KKRScrollViewParallaxer *)parallaxer
{
    if (index < 17)
    {
        return CGRectMake((index * parallaxer.scrollView.frame.size.width) + 2.f, 20.f + 16.f, 400.f, 40.f);
    }

    return CGRectZero;
}

- (CGFloat)movementFractionalForViewAtIndex:(NSUInteger)index inParallaxer:(KKRScrollViewParallaxer *)parallaxer
{
    return 0.5f;
}


@end
