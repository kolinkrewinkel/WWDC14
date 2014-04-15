//
//  KKRScrollViewParallaxer.m
//  Kolin Krewinkel
//
//  Created by Kolin Krewinkel on 4/9/14.
//  Copyright (c) 2014 Kolin Krewinkel. All rights reserved.
//

#import "KKRScrollViewParallaxer.h"

@interface KKRScrollViewParallaxer ()

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) id<UIScrollViewDelegate> originalDelegate;

@property (nonatomic, weak) id<KKRScrollViewParallaxerDataSource> dataSource;

@property (nonatomic, strong) NSMutableDictionary *visibleViews;

@end

@implementation KKRScrollViewParallaxer

#pragma mark - Designated Initializer

+ (instancetype)parallaxerForScrollView:(UIScrollView *)scrollView originalDelegate:(id<UIScrollViewDelegate>)delegate dataSource:(id<KKRScrollViewParallaxerDataSource>)dataSource
{
    KKRScrollViewParallaxer *parallaxer = [[[self class] alloc] init];
    parallaxer.dataSource = dataSource;
    parallaxer.scrollView = scrollView;
    parallaxer.originalDelegate = delegate;

    return parallaxer;
}

#pragma mark - Iniitialization

- (id)init
{
    if ((self = [super init]))
    {
        self.visibleViews = [[NSMutableDictionary alloc] init];
    }

    return self;
}

#pragma mark - Setters

- (void)setScrollView:(UIScrollView *)scrollView
{
    if (self.scrollView)
    {
        [self.scrollView removeObserver:self forKeyPath:@"frame"];
    }

    _scrollView = scrollView;

    self.scrollView.delegate = self;

    [self.scrollView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];

    [self layoutScrollView];
}

#pragma mark - Scroll View Management

- (void)layoutScrollView
{
    for (NSInteger idx = [self.dataSource numberOfItemsParallaxedInParallaxer:self] - 1; idx >= 0; idx--)
    {
        UIView *view = [self displayedViewAtIndex:idx];

        CGFloat movementFactor = [self.dataSource movementFractionalForViewAtIndex:idx inParallaxer:self];
        CGRect originalRect = [self.dataSource initialRectForViewAtIndex:idx inParallaxer:self];
        CGRect modifiedRect = CGRectMake(originalRect.origin.x + ((1.f - movementFactor) * self.scrollView.contentOffset.x), originalRect.origin.y + ((1.f - movementFactor) * self.scrollView.contentOffset.y), originalRect.size.width, originalRect.size.height);

        if (CGRectIntersectsRect(CGRectMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y, self.scrollView.frame.size.width, self.scrollView.frame.size.height), modifiedRect))
        {
            if (!view)
            {
                view = [self.dataSource viewAtIndex:idx inParallaxer:self];
                [self.visibleViews setObject:view forKey:@(idx)];

                [self.scrollView insertSubview:view atIndex:1];
            }

            view.frame = modifiedRect;
        }
        else if (view)
        {
            if ([self.dataSource respondsToSelector:@selector(parallaxer:canRemoveViewAtIndex:)] && ![self.dataSource parallaxer:self canRemoveViewAtIndex:idx])
            {
                return;
            }

            if ([self.dataSource respondsToSelector:@selector(parallaxer:didRemoveViewAtIndex:)])
            {
                [self.dataSource parallaxer:self didRemoveViewAtIndex:idx];
            }

            [view removeFromSuperview];
            [self.visibleViews removeObjectForKey:@(idx)];
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self layoutScrollView];

    if ([self.originalDelegate respondsToSelector:@selector(scrollViewDidScroll:)])
    {
        [self.originalDelegate scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([self.originalDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)])
    {
        [self.originalDelegate scrollViewDidEndDecelerating:scrollView];
    }
}

- (UIView *)displayedViewAtIndex:(NSUInteger)index
{
    return self.visibleViews[@(index)];
}

#pragma mark - NSKVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self layoutScrollView];
    });
}

#pragma mark - NSObject

- (void)dealloc
{
    [self.scrollView removeObserver:self forKeyPath:@"frame"];
}

@end
