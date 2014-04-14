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
#import "KKRBackgroundCrossfadeView.h"

@interface KKRTimelineViewController ()

@property (nonatomic, strong) KKRBackgroundCrossfadeView *backgroundView;
@property (nonatomic, strong) KKRScrollViewParallaxer *scrollViewParallaxer;
@property (nonatomic, strong) UIView *yearBackgroundView;

@property (nonatomic, strong) NSArray *timelineItems;

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
    UIView *contentView = [[UIView alloc] initWithFrame:self.view.bounds];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:contentView];
    [self.view kkr_addContraintsToFillSuperviewToView:contentView padding:0.f];

    self.backgroundView = ({
        KKRBackgroundCrossfadeView *backgroundView = [[KKRBackgroundCrossfadeView alloc] init];
        [contentView addSubview:backgroundView];

        [contentView kkr_addContraintsToFillSuperviewToView:backgroundView padding:64.f];

        backgroundView;
    });

    [[KKRTimelineManager sharedManager] getTimelineItemsWithCompletionHandler:^(NSError *error, NSArray *timelineItems) {
        self.timelineItems = timelineItems;

        self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        self.scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = YES;
        self.scrollView.backgroundColor = [UIColor clearColor];

        [contentView addSubview:self.scrollView];
        [contentView kkr_addContraintsToFillSuperviewToView:self.scrollView padding:0.f];

        self.yearBackgroundView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
            view.backgroundColor = [UIColor whiteColor];
            [self.scrollView addSubview:view];

            view;
        });

        self.scrollViewParallaxer = [KKRScrollViewParallaxer parallaxerForScrollView:self.scrollView originalDelegate:self dataSource:self];
    }];
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
    return 18;
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
    else if (index < 18)
    {
        UIView *view = [[UIView alloc] initWithFrame:[self initialRectForViewAtIndex:index inParallaxer:parallaxer]];

        KKRTimelineItem *item = self.timelineItems[index - 17];

        [item assembleViewHierarchyInContainer:view];

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
    else if (index < 18)
    {
        return CGRectMake(((index - 17) * parallaxer.scrollView.frame.size.width), 64.f + 20.f, parallaxer.scrollView.frame.size.width, parallaxer.scrollView.frame.size.height - (64.f + 20.f));
    }

    return CGRectZero;
}

- (CGFloat)movementFractionalForViewAtIndex:(NSUInteger)index inParallaxer:(KKRScrollViewParallaxer *)parallaxer
{
    if (index < 17)
    {
        return 0.5f;
    }
    else if (index < 18)
    {
        return 1.5f;
    }

    return 1.f;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat currImageOffset = [self currentIndex] * scrollView.frame.size.width;
    if ([self currentIndex] <= self.timelineItems.count - 1)
    {
        KKRTimelineItem *currItem = self.timelineItems[[self currentIndex]];
        self.backgroundView.currentImage = [[UIImage imageNamed:[currItem background]] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
    }



    NSInteger offset = 0;

    if (scrollView.contentOffset.x > currImageOffset && (scrollView.contentOffset.x + scrollView.frame.size.width) < scrollView.contentSize.width)
    {
        offset = 1;
    }
    else if (scrollView.contentOffset.x < currImageOffset && scrollView.contentOffset.x > 0.f)
    {
        offset = -1;
    }
    else
    {
        return;
    }

    NSUInteger index = [self currentIndex] + offset;
    if (index < self.timelineItems.count - 1)
    {
        if (offset == 1)
        {
            [self.backgroundView.transition updateInteractiveTransition:(scrollView.contentOffset.x - currImageOffset)/scrollView.frame.size.width];
        }
        else
        {
            [self.backgroundView.transition updateInteractiveTransition:(currImageOffset - scrollView.contentOffset.x)/scrollView.frame.size.width];
        }

        KKRTimelineItem *item = self.timelineItems[index];
        self.backgroundView.nextImage = [[UIImage imageNamed:item.background] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
    }
}

- (NSUInteger)currentIndex
{
    return (NSUInteger)roundf(self.scrollView.contentOffset.x/(self.scrollView.contentSize.width - self.scrollView.frame.size.width));
}

@end
