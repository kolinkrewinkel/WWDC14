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

    self.scrollView = ({
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.directionalLockEnabled = YES;

        [self.view addSubview:scrollView];
        [self.view kkr_addContraintsToFillSuperviewToView:scrollView padding:0.f];

        scrollView;
    });

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

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];

    CGFloat oldWidth = self.scrollView.contentSize.width;
    CGFloat newWidth = self.view.bounds.size.width * 2.f;
    self.scrollView.contentSize = CGSizeMake(newWidth, 0.f);

    CGFloat percentage = (self.scrollView.contentOffset.x/(oldWidth/2));
    self.scrollView.contentOffset = CGPointMake(newWidth * percentage, 0.f);
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
