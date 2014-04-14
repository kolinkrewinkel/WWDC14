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
    item.content = [KKRTimelineContent contentWithJSON:JSON[@"content"]];


    if (JSON[@"background"])
    {
        item.background = JSON[@"background"];
        if ([JSON[@"background-mode"] isEqualToString:@"tile"])
        {
            item.backgroundResizingMode = UIImageResizingModeTile;
        }
        else
        {
            item.backgroundResizingMode = UIImageResizingModeStretch;
        }
    }
    else
    {
        NSString *bgColor = JSON[@"background-color"];
        if ([bgColor isEqualToString:@"white"])
        {
            item.backgroundColor = [UIColor whiteColor];
        }
        else if ([bgColor isEqualToString:@"black"])
        {
            item.backgroundColor = [UIColor blackColor];
        }
    }

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
    newContainer.clipsToBounds = YES;
    newContainer.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [container addSubview:newContainer];
    [newContainer kkr_setHierarchyIdentifier:[self.name lowercaseString]];

    UIImageView *background = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:self.background] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:self.backgroundResizingMode]];
    if (self.backgroundColor)
    {
        background.backgroundColor = self.backgroundColor;
    }

    [newContainer addSubview:background];

    CGFloat maxValue = 64.f;
    [newContainer kkr_addContraintsToFillSuperviewToView:background padding:maxValue];

    [background addMotionEffect:({
        UIInterpolatingMotionEffect *effect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        effect.maximumRelativeValue = @(maxValue);
        effect.minimumRelativeValue = @(-maxValue);

        effect;
    })];

    [background addMotionEffect:({
        UIInterpolatingMotionEffect *effect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        effect.maximumRelativeValue = @(maxValue);
        effect.minimumRelativeValue = @(-maxValue);

        effect;
    })];

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
            if ([content.identifier isEqualToString:@"title"])
            {
                label.adjustsFontSizeToFitWidth = YES;
            }
            else
            {
                label.numberOfLines = 0;
                label.alpha = 0.7f;
            }

            label.font = font;

            if (content.textColor)
            {
                label.textColor = content.textColor;
            }

            label.textAlignment = content.alignment;

            newContainer = label;
        }
        else if ([content.type isEqualToString:@"image"])
        {
            UIImage *image = [UIImage imageNamed:content.data];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            newContainer = imageView;
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

        newContainer.translatesAutoresizingMaskIntoConstraints = NO;

        [container updateConstraints];

        if (content.childContents && newContainer)
        {
            [self handleContents:content.childContents container:newContainer];
        }
    }
}

@end
