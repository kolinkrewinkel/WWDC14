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

- (id)init
{
    if ((self = [super init]))
    {
        self.visibleViews = [[NSMutableDictionary alloc] init];
    }

    return self;
}

- (void)setScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;

    self.scrollView.delegate = self;

    for (NSUInteger idx = 0; idx < [self.dataSource numberOfItemsParallaxedInParallaxer:self]; idx++)
    {
        [self.scrollView addSubview:[self.dataSource viewAtIndex:idx inParallaxer:self]];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    for (NSUInteger idx = 0; idx < [self.dataSource numberOfItemsParallaxedInParallaxer:self]; idx++)
    {
        CGFloat movementFactor = [self.dataSource movementFractionalForViewAtIndex:idx inParallaxer:self];
        UIView *view = [self displayedViewAtIndex:idx];

        if (CGRectIntersectsRect(CGRectMake(self.scrollView.contentOffset.x * movementFactor, self.scrollView.contentOffset.y * movementFactor, self.scrollView.frame.size.width, self.scrollView.frame.size.height), [self.dataSource initialRectForViewAtIndex:idx inParallaxer:self]))
        {

        }
    }
}

- (UIView *)displayedViewAtIndex:(NSUInteger)index
{
    return self.visibleViews[@(index)];
}

@end
