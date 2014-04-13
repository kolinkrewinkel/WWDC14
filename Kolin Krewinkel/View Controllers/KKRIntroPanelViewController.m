//
//  KKRIntroPanelViewController.m
//  Kolin Krewinkel
//
//  Created by Kolin Krewinkel on 4/12/14.
//  Copyright (c) 2014 Kolin Krewinkel. All rights reserved.
//

#import "KKRIntroPanelViewController.h"

#import "KKRScrollViewParallaxer.h"
#import "KKRIntroViewController.h"

@interface KKRIntroPanelViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) KKRScrollViewParallaxer *parallaxer;

@property (nonatomic) CGFloat dockedPanelWidth;

@end

@implementation KKRIntroPanelViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    self.scrollView = ({
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.directionalLockEnabled = YES;
        scrollView.backgroundColor = [UIColor whiteColor];

        [self.view addSubview:scrollView];
        [self.view kkr_addContraintsToFillSuperviewToView:scrollView padding:0.f];

        scrollView;
    });

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTapped:)];
    [self.scrollView addGestureRecognizer:tapGesture];

    self.parallaxer = ({
        KKRScrollViewParallaxer *parallaxer = [KKRScrollViewParallaxer parallaxerForScrollView:self.scrollView originalDelegate:self dataSource:self];
        
        parallaxer;
    });

    self.dockedPanelWidth = 96.f;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width * 2.f, 0.f);
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    if ([self introViewIsCentered])
    {
        return [self.introViewController preferredStatusBarStyle];
    }

    return [self.contentViewController preferredStatusBarStyle];
}

- (BOOL)introViewIsCentered
{
    return self.scrollView.contentOffset.x == 0.f;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

//    [UIView animateWithDuration:0.35 delay:0.1 usingSpringWithDamping:0.4f initialSpringVelocity:1.f options:UIViewAnimationOptionAllowUserInteraction animations:^{
//        self.scrollView.contentOffset = CGPointMake(self.scrollView.contentSize.width * 0.1f, 0.f);
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.15 delay:0.05 usingSpringWithDamping:0.6f initialSpringVelocity:0.f options:UIViewAnimationOptionAllowUserInteraction animations:^{
//            self.scrollView.contentOffset = CGPointZero;
//        } completion:nil];
//    }];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];

    if ([self introViewIsCentered])
    {
        self.scrollView.contentOffset = CGPointZero;
    }
    else
    {
        self.scrollView.contentOffset = CGPointMake(self.view.bounds.size.width, 0.f);
    }

    self.scrollView.frame = CGRectMake(0.f, 0.f, self.view.bounds.size.width, self.view.bounds.size.height);

    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateTransition];
    });
}

#pragma mark - UIGestureRecognizer

- (void)scrollViewTapped:(UITapGestureRecognizer *)sender
{
    if (![self introViewIsCentered] || ![self.introViewController isKindOfClass:[KKRIntroViewController class]])
    {
        return;
    }

    KKRIntroViewController *introView = (KKRIntroViewController *)self.introViewController;
    [UIView animateKeyframesWithDuration:0.4 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeCubic | UIViewKeyframeAnimationOptionAllowUserInteraction | UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.4f animations:^{
            [introView.transition updateInteractiveTransition:0.1f];
        }];

        [UIView addKeyframeWithRelativeStartTime:0.4 relativeDuration:0.6 animations:^{
            [introView.transition updateInteractiveTransition:0.f];
        }];
    } completion:^(BOOL finished) {

    }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0.1 animations:^{
        [self setNeedsStatusBarAppearanceUpdate];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self updateTransition];

    if (scrollView.contentOffset.x <= 0.f)
    {
        self.introViewController.view.frame = CGRectMake(scrollView.contentOffset.x, 0.f, fabsf(scrollView.contentOffset.x) + scrollView.bounds.size.width, scrollView.bounds.size.height);
    }
    else if ((scrollView.contentOffset.x + scrollView.frame.size.width)/scrollView.contentSize.width >= 1.f)
    {
        CGRect contentRect = self.contentViewController.view.frame;
        CGFloat viewportRemainder = (scrollView.contentOffset.x + scrollView.frame.size.width) - CGRectGetMinX(contentRect);

        self.contentViewController.view.frame = (CGRect){contentRect.origin, CGSizeMake(viewportRemainder, CGRectGetHeight(contentRect))};
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self updateTransition];
}

//- (void)scrollview

- (void)updateTransition
{
    CGFloat progress = self.scrollView.contentOffset.x/(self.scrollView.contentSize.width * .5f);
    if ([self.introViewController isKindOfClass:[KKRIntroViewController class]])
    {
        KKRIntroViewController *introView = (KKRIntroViewController *)self.introViewController;
        [introView.transition updateInteractiveTransition:MIN(progress, 1.f)];
    }
}

#pragma mark - KKRScrollViewParallaxerDataSource

- (NSUInteger)numberOfItemsParallaxedInParallaxer:(KKRScrollViewParallaxer *)parallaxer
{
    return 2;
}

- (UIView *)viewAtIndex:(NSUInteger)index inParallaxer:(KKRScrollViewParallaxer *)parallaxer
{
    if (index == 0)
    {
        [self addChildViewController:self.introViewController];

        return self.introViewController.view;
    }
    else if (index == 1)
    {
        [self addChildViewController:self.contentViewController];

        return self.contentViewController.view;
    }

    return nil;
}

- (CGFloat)movementFractionalForViewAtIndex:(NSUInteger)index inParallaxer:(KKRScrollViewParallaxer *)parallaxer
{
    if (index == 0)
    {
        if (parallaxer.scrollView.contentOffset.x <= 0.f)
        {
            return 0.1f;
        }

        return (self.view.bounds.size.width - self.dockedPanelWidth)/self.view.bounds.size.width;
    }
    else if (index == 1)
    {
        return 0.5f;
    }

    return 1.f;
}

- (CGRect)initialRectForViewAtIndex:(NSUInteger)index inParallaxer:(KKRScrollViewParallaxer *)parallaxer
{
    if (index == 0)
    {
        return CGRectMake(index * self.view.bounds.size.width, 0.f, self.view.bounds.size.width, self.view.bounds.size.height);
    }
    else if (index == 1)
    {
        return CGRectMake(self.view.bounds.size.width * (0.5f + (1.f - ((self.view.bounds.size.width - self.dockedPanelWidth)/self.view.bounds.size.width))), 0.f, (self.view.bounds.size.width - self.dockedPanelWidth), self.view.bounds.size.height);
    }

    return CGRectZero;
}

- (void)parallaxer:(KKRScrollViewParallaxer *)parallaxer didRemoveViewAtIndex:(NSUInteger)index
{
    if (index == 0)
    {
        [self.introViewController removeFromParentViewController];
    }
    else if (index == 1)
    {
        [self.contentViewController removeFromParentViewController];
    }
}

@end
