//
//  KKRTimelineFetcher.h
//  Kolin Krewinkel
//
//  Created by Kolin Krewinkel on 4/8/14.
//  Copyright (c) 2014 Kolin Krewinkel. All rights reserved.
//

#import "KKRTimelineItem.h"

typedef void(^KKRTimelineManagerItemsCompletionManager)(NSError *error, NSArray *timelineItems);

@interface KKRTimelineManager : NSObject

#pragma mark - Singleton

+ (instancetype)sharedManager;

#pragma mark - Timeline Items

- (void)getTimelineItemsWithCompletionHandler:(KKRTimelineManagerItemsCompletionManager)completionHandler;

@end
