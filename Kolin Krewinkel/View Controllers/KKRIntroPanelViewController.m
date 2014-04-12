//
//  KKRIntroPanelViewController.m
//  Kolin Krewinkel
//
//  Created by Kolin Krewinkel on 4/12/14.
//  Copyright (c) 2014 Kolin Krewinkel. All rights reserved.
//

#import "KKRIntroPanelViewController.h"

@interface KKRIntroPanelViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;

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

    if (self.introViewController && self.contentViewController)
    {


    }
}

@end
