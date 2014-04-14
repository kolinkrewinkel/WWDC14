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

@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) KKRScrollViewParallaxer *scrollViewParallaxer;
@property (nonatomic, strong) UIView *yearBackgroundView;

@property (nonatomic, strong) NSArray *timelineItems;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic) NSUInteger currentIndex;

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
    self.contentView = ({
        UIView *contentView = [[UIView alloc] initWithFrame:self.view.bounds];
        contentView.translatesAutoresizingMaskIntoConstraints = NO;
        contentView.clipsToBounds = NO;
        [self.view addSubview:contentView];
        [self.view kkr_addContraintsToFillSuperviewToView:contentView padding:0.f];

        contentView;
    });

    self.backgroundView = ({
        UIImageView *backgroundView = [[UIImageView alloc] init];
        [self.contentView addSubview:backgroundView];

        [self.contentView kkr_addContraintsToFillSuperviewToView:backgroundView padding:64.f];

        backgroundView;
    });

    [[KKRTimelineManager sharedManager] getTimelineItemsWithCompletionHandler:^(NSError *error, NSArray *timelineItems) {
        self.timelineItems = timelineItems;

        self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        self.scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = YES;
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.scrollView.clipsToBounds = YES;
        self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;

        [self.contentView addSubview:self.scrollView];
        [self.contentView kkr_addContraintsToFillSuperviewToView:self.scrollView padding:0.f];

        self.yearBackgroundView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
            view.backgroundColor = [UIColor whiteColor];
            view.translatesAutoresizingMaskIntoConstraints = NO;
            view.autoresizingMask = UIViewAutoresizingNone;
            [self.contentView addSubview:view];

            view;
        });

        self.scrollViewParallaxer = [KKRScrollViewParallaxer parallaxerForScrollView:self.scrollView originalDelegate:self dataSource:self];
        [self updateBackgroundView];
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

    self.yearBackgroundView.frame = CGRectMake(-200.f, 0.f, self.contentView.frame.size.width + 400.f, 64.f + (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) ? [UIApplication sharedApplication].statusBarFrame.size.height : [UIApplication sharedApplication].statusBarFrame.size.width));

    self.scrollView.frame = self.view.bounds;
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width * [self.timelineItems count], 0.f);
    self.scrollView.contentOffset = CGPointMake(prevOffsetX * self.scrollView.contentSize.width, 0.f);

    [self.contentView bringSubviewToFront:self.scrollView];
}

#pragma mark - KKRScrollViewParallaxer

- (NSUInteger)numberOfItemsParallaxedInParallaxer:(KKRScrollViewParallaxer *)parallaxer
{
    return self.timelineItems.count * 2;
}

- (UIView *)viewAtIndex:(NSUInteger)index inParallaxer:(KKRScrollViewParallaxer *)parallaxer
{
    if (index < self.timelineItems.count)
    {
        KKRTimelineItem *item = self.timelineItems[index];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:item.date];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = [NSString stringWithFormat:@"%li", (long)[components year]];
        label.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:36.f];
        label.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.8f];
        label.tag = index;
        label.textAlignment = NSTextAlignmentRight;

        return label;
    }
    else if (index <= self.timelineItems.count * 2)
    {
        NSUInteger relIndex = index - self.timelineItems.count;
        KKRTimelineItem *item = self.timelineItems[relIndex];

        UIView *view = [[UIView alloc] initWithFrame:[self initialRectForViewAtIndex:relIndex inParallaxer:parallaxer]];
        [item assembleViewHierarchyInContainer:view];

        return view;
    }

    return nil;
}

- (CGRect)initialRectForViewAtIndex:(NSUInteger)index inParallaxer:(KKRScrollViewParallaxer *)parallaxer
{
    if (index < self.timelineItems.count)
    {
        return CGRectMake(((index + 1) * parallaxer.scrollView.frame.size.width) - 405.f, 20.f + 16.f, 400.f, 40.f);
    }
    else if (index < self.timelineItems.count * 2)
    {
        return CGRectMake(((index - self.timelineItems.count) * parallaxer.scrollView.frame.size.width), 64.f + 20.f, parallaxer.scrollView.frame.size.width, parallaxer.scrollView.frame.size.height - (64.f + 20.f));
    }

    return CGRectZero;
}

- (CGFloat)movementFractionalForViewAtIndex:(NSUInteger)index inParallaxer:(KKRScrollViewParallaxer *)parallaxer
{
    if (index < self.timelineItems.count)
    {
        return 1.f;
    }

    return 1.f;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    [self.contentView bringSubviewToFront:self.yearBackgroundView];
//
//    for (int i = 0; i < [self numberOfItemsParallaxedInParallaxer:self.scrollViewParallaxer]; i++) {
//        UIView *view = [self.scrollView viewWithTag:i];
//        if (!view)
//        {
//            continue;
//        }
//
//        [self.scrollView bringSubviewToFront:view];
//    }
}

- (void)updateBackgroundView
{
//    UIScrollView *scrollView = self.scrollView;
//    CGFloat currImageOffset = [self currentIndex] * scrollView.frame.size.width;
//    if ([self currentIndex] <= self.timelineItems.count - 1)
//    {
//        KKRTimelineItem *currItem = self.timelineItems[[self currentIndex]];
//        if (currItem.backgroundColor)
//        {
//            [self.backgroundView setCurrentColor:currItem.backgroundColor];
//        }
//        else
//        {
//            self.backgroundView.currentImage = [[UIImage imageNamed:[currItem background]] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:currItem.backgroundResizingMode];
//        }
//    }
//
//    NSInteger offset = 0;
//
//    if (scrollView.contentOffset.x > currImageOffset && (scrollView.contentOffset.x + scrollView.frame.size.width) < scrollView.contentSize.width)
//    {
//        offset = 1;
//    }
//    else if (scrollView.contentOffset.x < currImageOffset && scrollView.contentOffset.x > 0.f)
//    {
//        offset = -1;
//    }
//    else
//    {
//        return;
//    }
//
//    NSUInteger index = [self currentIndex] + offset;
//    if (index < self.timelineItems.count)
//    {
//        if (offset == 1)
//        {
//            [self.backgroundView.transition updateInteractiveTransition:(scrollView.contentOffset.x - currImageOffset)/scrollView.frame.size.width];
//        }
//        else
//        {
//            [self.backgroundView.transition updateInteractiveTransition:(currImageOffset - scrollView.contentOffset.x)/scrollView.frame.size.width];
//        }
//
//        if (self.scrollView.isDecelerating)
//        {
//            return;
//        }
//
//        KKRTimelineItem *item = self.timelineItems[index];
//
//        if (item.backgroundColor)
//        {
//            [self.backgroundView setNextColor:item.backgroundColor];
//        }
//        else
//        {
//            if (item.backgroundResizingMode == UIImageResizingModeTile)
//            {
//                NSLog(@"setting next image for item: %@", item.name);
//                self.backgroundView.nextImage = [[UIImage imageNamed:item.background] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:item.backgroundResizingMode];
//            }
//            else
//            {
//                UIImage *image = [[UIImage imageNamed:item.background] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:item.backgroundResizingMode];
//                self.backgroundView.nextImage = image;
//            }
//        }
//    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.currentIndex = self.scrollView.contentOffset.x/self.scrollView.frame.size.width;
//
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.2;
//
//    KKRTimelineItem *item = self.timelineItems[self.currentIndex];
//    if (item.backgroundColor)
//    {
//        self.backgroundView.backgroundColor = item.backgroundColor;
//        self.backgroundView.image = nil;
//    }
//    else
//    {
//        self.backgroundView.backgroundColor = [UIColor clearColor];
//        self.backgroundView.image = [[UIImage imageNamed:item.background] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:item.backgroundResizingMode];
//    }
//
//    [self.backgroundView.layer addAnimation:transition forKey:nil];
}

@end
