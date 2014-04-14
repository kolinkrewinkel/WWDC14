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
    item.background = JSON[@"background"];
    item.content = [KKRTimelineContent contentWithJSON:JSON[@"content"]];

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
    UIView *newContainer = [[UIView alloc] initWithFrame:container.bounds];
    newContainer.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [container addSubview:newContainer];
    [newContainer kkr_setHierarchyIdentifier:[self.name lowercaseString]];

    [self handleContents:@[self.content] container:newContainer];
}

- (void)handleContents:(NSArray *)contents container:(UIView *)container
{
    for (KKRTimelineContent *content in contents)
    {
        UIView *newContainer = nil;
        if ([content.type isEqualToString:@"container"])
        {
            newContainer = [[UIView alloc] initWithFrame:container.bounds];
        }
        else if ([content.type isEqualToString:@"text"])
        {
            NSString *text = content.data;
            UIFont *font = content.font;
            CGSize size = [text sizeWithAttributes:@{NSFontAttributeName: font}];

            UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){CGPointZero, size}];
            label.text = text;
            label.font = font;
            newContainer = label;
        }

        if (!newContainer)
        {
            continue;
        }

        [newContainer kkr_setHierarchyIdentifier:content.identifier];
        [container addSubview:newContainer];

        for (KKRTimelineContentPositionConstraint *constraint in content.position.constraints)
        {
            [container addConstraint:[constraint constraintWithView:newContainer]];
        }

        NSLog(@"%@", container.constraints);

        newContainer.translatesAutoresizingMaskIntoConstraints = NO;

        [container updateConstraints];

        if (content.childContents && newContainer)
        {
            [self handleContents:content.childContents container:newContainer];
        }
    }
}

@end
