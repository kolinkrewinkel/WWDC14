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

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.scrollView = ({
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        scrollView.contentSize = CGSizeMake(self.view.bounds.size.width * 2.f, self.view.bounds.size.height);
        scrollView.backgroundColor = [UIColor greenColor];
        scrollView.pagingEnabled = YES;
       [self.view addSubview:scrollView];

        scrollView;
    });

    self.parallaxer = ({
        KKRScrollViewParallaxer *parallaxer = [KKRScrollViewParallaxer parallaxerForScrollView:self.scrollView originalDelegate:self dataSource:self];
        
        parallaxer;
    });

    if (self.introViewController && self.contentViewController)
    {
        [self addChildViewController:self.introViewController];
        [self.scrollView addSubview:self.introViewController.view];

        [self addChildViewController:self.contentViewController];
        [self.scrollView addSubview:self.contentViewController.view];
    }
}

#pragma mark - KKRScrollViewParallaxerDataSource



@end
