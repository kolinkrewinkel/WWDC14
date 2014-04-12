//
//  KKRAppDelegate.m
//  Kolin Krewinkel
//
//  Created by Kolin Krewinkel on 4/8/14.
//  Copyright (c) 2014 Kolin Krewinkel. All rights reserved.
//

#import "KKRAppDelegate.h"

#import "KKRIntroPanelViewController.h"
#import "KKRIntroViewController.h"
#import "KKRTimelineViewController.h"

@implementation KKRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = ({
        UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.backgroundColor = [UIColor blackColor];

        window;
    });

    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        KKRIntroPanelViewController *introPanel = ({
            KKRIntroPanelViewController *introPanel = [[KKRIntroPanelViewController alloc] init];
            introPanel.contentViewController = [[KKRTimelineViewController alloc] init];
            introPanel.introViewController = [[KKRIntroViewController alloc] init];

            introPanel;
        });

        self.window.rootViewController = introPanel;
    }

    [self.window makeKeyAndVisible];

    return YES;
}

@end
