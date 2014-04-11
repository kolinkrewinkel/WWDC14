//
//  KKRTimelineViewController.h
//  Kolin Krewinkel
//
//  Created by Kolin Krewinkel on 4/8/14.
//  Copyright (c) 2014 Kolin Krewinkel. All rights reserved.
//

#import "KKRScrollViewParallaxer.h"

@interface KKRTimelineViewController : UIViewController <KKRScrollViewParallaxerDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@end
