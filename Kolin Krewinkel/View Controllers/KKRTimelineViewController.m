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
    self.view.backgroundColor = [UIColor whiteColor];

    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, (self.view.frame.size.height * 2.f * (17)));
    self.scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    self.scrollView.pagingEnabled = YES;

    [self.view addSubview:self.scrollView];

    self.scrollViewParallaxer = [KKRScrollViewParallaxer parallaxerForScrollView:self.scrollView originalDelegate:self dataSource:self];

    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i = 0; i < 34; i++) {
//            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(150.f, (i * self.view.frame.size.height), 90.f, self.view.frame.size.height)];
//            CGFloat alpha = (CGFloat)(i + 1)/34;
//            view.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:alpha];
//
//            [self.scrollView addSubview:view];
        }
    });
}

#pragma mark - KKRScrollViewParallaxer

- (NSUInteger)numberOfItemsParallaxedInParallaxer:(KKRScrollViewParallaxer *)parallaxer
{
    return 34;
}

- (UIView *)viewAtIndex:(NSUInteger)index inParallaxer:(KKRScrollViewParallaxer *)parallaxer
{
    if (index < 17)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = [NSString stringWithFormat:@"%lu", 1998 + index];
        label.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:36.f];
        label.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.8f];
        label.transform = CGAffineTransformMakeRotation(-90.f * (M_PI / 180.f));

        return label;
    }
    else if (index < 34)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        CGFloat alpha = (CGFloat)((index - 17) + 1)/17;
        view.alpha = 0.4f;

        return view;
    }

    return nil;
}

- (CGRect)initialRectForViewAtIndex:(NSUInteger)index inParallaxer:(KKRScrollViewParallaxer *)parallaxer
{
    if (index < 17)
    {
        return CGRectMake(16.f, (parallaxer.scrollView.frame.size.height * (index + 1)) - (150.f + 4.f), 40.f, 150.f);
    }
    else if (index < 34)
    {
        CGFloat width = 64.f;
        if (index == 33)
        {
            return CGRectMake(0.f, (index - 17) * self.view.frame.size.height, width, self.view.frame.size.height * 1.5f);
        }

        return CGRectMake(0.f, (index - 17) * self.view.frame.size.height, width, self.view.frame.size.height);
    }

    return CGRectZero;
}

- (CGFloat)movementFractionalForViewAtIndex:(NSUInteger)index inParallaxer:(KKRScrollViewParallaxer *)parallaxer
{
    return 0.5f;
}


@end
