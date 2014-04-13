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
    self.view.backgroundColor = [UIColor blackColor];

    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.backgroundColor = [UIColor blackColor];

    [self.view addSubview:self.scrollView];

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.scrollView.contentSize.width, 64.f)];
    view.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:view];

    self.scrollViewParallaxer = [KKRScrollViewParallaxer parallaxerForScrollView:self.scrollView originalDelegate:self dataSource:self];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width * 2.f * 17.f, 0.f);
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
        label.text = [NSString stringWithFormat:@"%u", 1998 + index];
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
        return CGRectMake((parallaxer.scrollView.frame.size.width * (index + 1)) - (150.f + 30.f), 16.f, 150.f, 40.f);
    }
    else if (index < 34)
    {
        CGFloat height = 64.f;
        if (index == 33)
        {
            return CGRectMake((index - 17) * self.view.frame.size.width, 0.f, self.view.frame.size.width * 1.5f, height);
        }

        return CGRectMake((index - 17) * self.view.frame.size.width, 0.f, self.view.frame.size.width, height);
    }

    return CGRectZero;
}

- (CGFloat)movementFractionalForViewAtIndex:(NSUInteger)index inParallaxer:(KKRScrollViewParallaxer *)parallaxer
{
    return 0.5f;
}


@end
