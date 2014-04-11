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
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];

    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, (self.view.frame.size.height * 2.f * (17)));
    self.scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;

    self.view = self.scrollView;

    self.scrollViewParallaxer = [KKRScrollViewParallaxer parallaxerForScrollView:self.scrollView originalDelegate:self dataSource:self];

    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i = 0; i < 34; i++) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(80.f, (i) * self.view.frame.size.height, 100.f, self.view.frame.size.height)];

            CGFloat alpha = (CGFloat)(i + 1)/34.f;
            view.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:alpha];

            NSLog(@"%@", NSStringFromCGRect(view.frame));

            [self.scrollView addSubview:view];
        }
    });
}

#pragma mark - KKRScrollViewParallaxer

- (NSUInteger)numberOfItemsParallaxedInParallaxer:(KKRScrollViewParallaxer *)parallaxer
{
    return 17;
}

- (UIView *)viewAtIndex:(NSUInteger)index inParallaxer:(KKRScrollViewParallaxer *)parallaxer
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = [NSString stringWithFormat:@"%lu", 1998 + index];
    label.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:36.f];
    label.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8f];
    label.transform = CGAffineTransformMakeRotation(-90.f * (M_PI / 180.f));

    return label;
}

- (CGRect)initialRectForViewAtIndex:(NSUInteger)index inParallaxer:(KKRScrollViewParallaxer *)parallaxer
{
    return CGRectMake(16.f, (parallaxer.scrollView.frame.size.height * (index + 1)) - (150.f + 0.f), 40.f, 150.f);
}

- (CGFloat)movementFractionalForViewAtIndex:(NSUInteger)index inParallaxer:(KKRScrollViewParallaxer *)parallaxer
{
    return 0.5f;
}


@end
