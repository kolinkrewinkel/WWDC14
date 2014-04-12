//
//  KKRIntroPanelViewController.h
//  Kolin Krewinkel
//
//  Created by Kolin Krewinkel on 4/12/14.
//  Copyright (c) 2014 Kolin Krewinkel. All rights reserved.
//

#import "KKRScrollViewParallaxer.h"

@interface KKRIntroPanelViewController : UIViewController <KKRScrollViewParallaxerDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet UIViewController *introViewController;
@property (nonatomic, strong) IBOutlet UIViewController *contentViewController;

@end
