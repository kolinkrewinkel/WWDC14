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
    _scrollView = scrollView;

    self.scrollView.delegate = self;

    [self layoutScrollView];
}

#pragma mark - Scroll View Management

- (void)layoutScrollView
{
    for (NSUInteger idx = 0; idx < [self.dataSource numberOfItemsParallaxedInParallaxer:self]; idx++)
    {
        UIView *view = [self displayedViewAtIndex:idx];

        CGFloat movementFactor = [self.dataSource movementFractionalForViewAtIndex:idx inParallaxer:self];
        CGRect originalRect = [self.dataSource initialRectForViewAtIndex:idx inParallaxer:self];
        CGRect modifiedRect = CGRectMake(0.f, originalRect.origin.y + ((1.f - movementFactor) * self.scrollView.contentOffset.y), originalRect.size.width, originalRect.size.height);

        if (CGRectIntersectsRect(CGRectMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y, self.scrollView.frame.size.width, self.scrollView.frame.size.height), modifiedRect))
        {
            if (!view)
            {
                view = [self.dataSource viewAtIndex:idx inParallaxer:self];
                [self.visibleViews setObject:view forKey:@(idx)];

                [self.scrollView addSubview:view];
            }

            view.frame = modifiedRect;
        }
        else if (view)
        {
            [view removeFromSuperview];

            [self.visibleViews removeObjectForKey:@(idx)];
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self layoutScrollView];
}

- (UIView *)displayedViewAtIndex:(NSUInteger)index
{
    return self.visibleViews[@(index)];
}

@end
