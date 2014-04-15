//
//  KKRTimelineFetcher.m
//  Kolin Krewinkel
//
//  Created by Kolin Krewinkel on 4/8/14.
//  Copyright (c) 2014 Kolin Krewinkel. All rights reserved.
//

#import "KKRTimelineManager.h"

@interface KKRTimelineManager ()

#pragma mark - Internal Networking



@end

@implementation KKRTimelineManager

#pragma mark - Singleton

+ (instancetype)sharedManager
{
    static id sharedFetcher;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedFetcher = [[[self class] alloc] init];
    });

    return sharedFetcher;
}

#pragma mark - Initialization

- (id)init
{
    if ((self = [super init]))
    {
        
    }

    return self;
}

#pragma mark - Convenience

- (NSString *)JSONContentPath
{
    return [[NSBundle mainBundle] pathForResource:@"content" ofType:@"json"];
}

#pragma mark - Fetching

- (void)getTimelineItemsWithCompletionHandler:(KKRTimelineManagerItemsCompletionManager)completionHandler
{
    NSError *error = nil;
    NSArray *content = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:[self JSONContentPath]] options:NSJSONReadingAllowFragments error:&error];

    if (error)
    {
        NSLog(@"%@", error);
        completionHandler(error, nil);
        return;
    }

    completionHandler(nil, ({
        __block NSMutableArray *timelineItems = [[NSMutableArray alloc] initWithCapacity:content.count];
        [content enumerateObjectsUsingBlock:^(NSDictionary *JSONItem, NSUInteger idx, BOOL *stop) {
            [timelineItems addObject:[KKRTimelineItem timelineItemWithJSON:JSONItem]];
        }];

        timelineItems;
    }));
}

@end
