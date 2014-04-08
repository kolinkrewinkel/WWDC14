//
//  KKRTimelineFetcher.m
//  Kolin Krewinkel
//
//  Created by Kolin Krewinkel on 4/8/14.
//  Copyright (c) 2014 Kolin Krewinkel. All rights reserved.
//

#import "KKRTimelineFetcher.h"

@implementation KKRTimelineFetcher

#pragma mark - Singleton

+ (instancetype)sharedFetcher
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

@end
