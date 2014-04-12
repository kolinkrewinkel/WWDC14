//
//  KKRIntroPanelViewController.m
//  Kolin Krewinkel
//
//  Created by Kolin Krewinkel on 4/12/14.
//  Copyright (c) 2014 Kolin Krewinkel. All rights reserved.
//

#import "KKRIntroPanelViewController.h"

#import "KKRScrollViewParallaxer.h"

@interface KKRIntroPanelViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) KKRScrollViewParallaxer *parallaxer;

@end

@implementation KKRIntroPanelViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.scrollView = ({
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 2.f, 0.f);
        scrollView.pagingEnabled = YES;

        [self.view addSubview:scrollView];
        [self.view kkr_addContraintsToFillSuperviewToView:scrollView];

        scrollView;
    });

    self.parallaxer = ({
        KKRScrollViewParallaxer *parallaxer = [KKRScrollViewParallaxer parallaxerForScrollView:self.scrollView originalDelegate:self dataSource:self];
        
        parallaxer;
    });

    if (self.introViewController && self.contentViewController)
    {
        [self addChildViewController:self.introViewController];

        [self addChildViewController:self.contentViewController];
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];

    CGFloat oldWidth = self.scrollView.contentSize.width;
    CGFloat newWidth = self.view.bounds.size.width * 2.f;
    self.scrollView.contentSize = CGSizeMake(newWidth, 0.f);

    CGFloat percentage = (self.scrollView.contentOffset.x/(oldWidth/2));
    NSLog(@"%f", percentage);
    self.scrollView.contentOffset = CGPointMake(newWidth * percentage, 0.f);
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
        return self.introViewController.view;
    }
    else if (index == 1)
    {
        return self.contentViewController.view;
    }

    return nil;
}

- (CGFloat)movementFractionalForViewAtIndex:(NSUInteger)index inParallaxer:(KKRScrollViewParallaxer *)parallaxer
{
    if (index == 0)
    {
        return 0.9f;
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
        return CGRectMake(self.view.bounds.size.width * .6f, 0.f, self.view.bounds.size.width, self.view.bounds.size.height);
    }

    return CGRectZero;
}

@end
