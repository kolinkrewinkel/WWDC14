//
//  KKRTimelineItem.m
//  Kolin Krewinkel
//
//  Created by Kolin Krewinkel on 4/13/14.
//  Copyright (c) 2014 Kolin Krewinkel. All rights reserved.
//

#import "KKRTimelineItem.h"

#import "KKRTimelineContent.h"

@implementation KKRTimelineItem

+ (instancetype)timelineItemWithJSON:(NSDictionary *)JSON
{
    KKRTimelineItem *item = [[[self class] alloc] init];
    item.name = JSON[@"name"];
    item.date = [[self sharedDateFormatter] dateFromString:JSON[@"date"]];

    return item;
}

+ (NSDateFormatter *)sharedDateFormatter
{
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-mm"];
    });

    return dateFormatter;
}

#pragma mark - View Construction

- (void)assembleViewHierarchyInContainer:(UIView *)container
{
    [container kkr_setHierarchyIdentifier:[self.name lowercaseString]];
    [self handleContents:self.content container:container];
}

- (void)handleContents:(NSArray *)contents container:(UIView *)container
{
    for (KKRTimelineContent *content in self.content)
    {
        UIView *newContainer = nil;
        if ([content.type isEqualToString:@"container"])
        {
            newContainer = [[UIView alloc] init];
            newContainer.backgroundColor = [UIColor redColor];
        }

        for (KKRTimelineContentPositionConstraint *constraint in content.position.constraints)
        {
            [container addConstraint:[constraint constraintWithView:newContainer]];
        }

        if (content.childContents && newContainer)
        {
            [self handleContents:content.childContents container:newContainer];
        }
    }
}

@end
