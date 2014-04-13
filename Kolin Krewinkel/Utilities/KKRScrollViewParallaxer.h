//
//  KKRScrollViewParallaxer.h
//  Kolin Krewinkel
//
//  Created by Kolin Krewinkel on 4/9/14.
//  Copyright (c) 2014 Kolin Krewinkel. All rights reserved.
//

@protocol KKRScrollViewParallaxerDataSource;

@interface KKRScrollViewParallaxer : NSObject <UIScrollViewDelegate>

#pragma mark - Properties

@property (nonatomic, weak, readonly) UIScrollView *scrollView;
@property (nonatomic, weak, readonly) id<UIScrollViewDelegate> originalDelegate;

@property (nonatomic, weak, readonly) id<KKRScrollViewParallaxerDataSource> dataSource;

#pragma mark - Designated Initializer

+ (instancetype)parallaxerForScrollView:(UIScrollView *)scrollView originalDelegate:(id<UIScrollViewDelegate>)delegate dataSource:(id <KKRScrollViewParallaxerDataSource>)dataSource;

@end

#pragma mark - Data Source Protocol

@protocol KKRScrollViewParallaxerDataSource <NSObject>

- (NSUInteger)numberOfItemsParallaxedInParallaxer:(KKRScrollViewParallaxer *)parallaxer;
- (UIView *)viewAtIndex:(NSUInteger)index inParallaxer:(KKRScrollViewParallaxer *)parallaxer;
- (CGFloat)movementFractionalForViewAtIndex:(NSUInteger)index inParallaxer:(KKRScrollViewParallaxer *)parallaxer;
- (CGRect)initialRectForViewAtIndex:(NSUInteger)index inParallaxer:(KKRScrollViewParallaxer *)parallaxer;
- (void)parallaxer:(KKRScrollViewParallaxer *)parallaxer didRemoveViewAtIndex:(NSUInteger)index;

@end
