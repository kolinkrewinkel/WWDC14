//
//  KKRTimelineFetcher.h
//  Kolin Krewinkel
//
//  Created by Kolin Krewinkel on 4/8/14.
//  Copyright (c) 2014 Kolin Krewinkel. All rights reserved.
//

typedef void(^KKRTimelineManagerItemsCompletionManager)(NSError *error, NSOrderedSet *timelineItems);

@interface KKRTimelineManager : NSObject

#pragma mark - Singleton

+ (instancetype)sharedManager;

#pragma mark - Timeline Items

- (void)getTimelineItemsWithCompletionHandler:(KKRTimelineManagerItemsCompletionManager)completionHandler;

@end
