//
//  KKRTimelineContent.m
//  Kolin Krewinkel
//
//  Created by Kolin Krewinkel on 4/13/14.
//  Copyright (c) 2014 Kolin Krewinkel. All rights reserved.
//

#import "KKRTimelineContent.h"

@implementation KKRTimelineContent

+ (instancetype)contentWithJSON:(NSDictionary *)JSON
{
    KKRTimelineContent *content = [[[self class] alloc] init];
    content.type = JSON[@"type"];
    content.position = [KKRTimelineContentPosition positionWithJSON:JSON[@"position"] content:content];
    content.identifier = JSON[@"identifier"];
    content.data = JSON[@"data"];

    NSDictionary *fontDict = JSON[@"font"];
    if (fontDict)
    {
        UIFont *font = [UIFont fontWithName:fontDict[@"name"] size:[fontDict[@"size"] floatValue]];
        if (!font)
        {
            font = [UIFont systemFontOfSize:[fontDict[@"size"] floatValue]];
        }

        NSString *colorString = fontDict[@"color"];
        if (colorString)
        {
            UIColor *color = [UIColor blackColor];
            if ([colorString isEqualToString:@"white"])
            {
                color = [UIColor whiteColor];
            }

            content.textColor = color;
        }

        content.font = font;
    }

    if ([JSON[@"content"] count])
    {
        NSMutableArray *childContents = [[NSMutableArray alloc] init];
        [JSON[@"content"] enumerateObjectsUsingBlock:^(NSDictionary *childNodeDict, NSUInteger idx, BOOL *stop) {
            [childContents addObject:[KKRTimelineContent contentWithJSON:childNodeDict]];
        }];

        content.childContents = childContents;
    }

    NSString *alignment = JSON[@"alignment"];
    if ([alignment isEqualToString:@"left"] || !alignment)
    {
        content.alignment = NSTextAlignmentLeft;
    }
    else if ([alignment isEqualToString:@"right"])
    {
        content.alignment = NSTextAlignmentRight;
    }
    else if ([alignment isEqualToString:@"center"])
    {
        content.alignment = NSTextAlignmentCenter;
    }

    return content;
}

@end

@interface KKRTimelineContentPosition ()

@property (nonatomic, weak) KKRTimelineContent *content;

@end

@implementation KKRTimelineContentPosition

#pragma mark -

+ (instancetype)positionWithJSON:(NSArray *)JSON content:(KKRTimelineContent *)content
{
    KKRTimelineContentPosition *position = [[[self class] alloc] init];
    position.constraints = ({
        NSMutableArray *constraints = [[NSMutableArray alloc] init];
        [JSON enumerateObjectsUsingBlock:^(NSDictionary *constraint, NSUInteger idx, BOOL *stop) {
            [constraints addObject:[KKRTimelineContentPositionConstraint positionConstraintWithJSON:constraint position:position]];
        }];

        constraints;
    });
    position.content = content;

    return position;
}

@end

@interface KKRTimelineContentPositionConstraint ()

@property (nonatomic) NSLayoutAttribute attribute;
@property (nonatomic) CGFloat multiplier;
@property (nonatomic) CGFloat constant;
@property (nonatomic) NSLayoutAttribute relatedAttribute;
@property (nonatomic, copy) NSString *viewRelationship;
@property (nonatomic) NSLayoutRelation relation;

@property (nonatomic, weak) KKRTimelineContentPosition *position;

@end

@implementation KKRTimelineContentPositionConstraint

+ (instancetype)positionConstraintWithJSON:(NSDictionary *)JSON position:(KKRTimelineContentPosition *)position
{
    KKRTimelineContentPositionConstraint *constraint = [[[self class] alloc] init];
    [constraint setAttributeWithString:JSON[@"attribute"]];
    [constraint setRelatedAttributeWithString:JSON[@"rel_attribute"]];

    if (JSON[@"multiplier"])
    {
        constraint.multiplier = [JSON[@"multiplier"] floatValue];
    }

    if (JSON[@"constant"])
    {
        constraint.constant = [JSON[@"constant"] floatValue];
    }

    constraint.position = position;
    constraint.relation = [KKRTimelineContentPositionConstraint relationFromString:JSON[@"relation"]];
    constraint.viewRelationship = JSON[@"toView"];

    return constraint;
}

+ (NSLayoutRelation)relationFromString:(NSString *)string
{
    if ([string isEqualToString:@">="])
    {
        return NSLayoutRelationGreaterThanOrEqual;
    }
    else if ([string isEqualToString:@"<="])
    {
        return NSLayoutRelationLessThanOrEqual;
    }

    return NSLayoutRelationEqual;
}

- (NSLayoutConstraint *)constraintWithView:(UIView *)view
{
    [view kkr_setHierarchyIdentifier:self.position.content.identifier];

    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view attribute:self.attribute relatedBy:self.relation toItem:self.viewRelationship ? [view kkr_relatedViewWithIdentifier:self.viewRelationship] : nil attribute:self.relatedAttribute multiplier:self.multiplier constant:self.constant];

    if (view.frame.size.width > 0.f && self.constant == -1.f)
    {
        constraint.constant = view.frame.size.width;
    }

    return constraint;
}

- (void)setAttributeWithString:(NSString *)string
{
    self.attribute = [self attributeFromString:string];
}

- (void)setRelatedAttributeWithString:(NSString *)string
{
    self.relatedAttribute = [self attributeFromString:string];
}

- (NSLayoutAttribute)attributeFromString:(NSString *)string
{
    if ([string isEqualToString:@"top"])
    {
        return NSLayoutAttributeTop;
    }
    else if ([string isEqualToString:@"bottom"])
    {
        return NSLayoutAttributeBottom;
    }
    else if ([string isEqualToString:@"left"])
    {
        return NSLayoutAttributeLeft;
    }
    else if ([string isEqualToString:@"right"])
    {
        return NSLayoutAttributeRight;
    }
    else if ([string isEqualToString:@"midX"])
    {
        return NSLayoutAttributeCenterX;
    }
    else if ([string isEqualToString:@"midY"])
    {
        return NSLayoutAttributeCenterY;
    }
    else if ([string isEqualToString:@"width"])
    {
        return NSLayoutAttributeWidth;
    }
    else if ([string isEqualToString:@"height"])
    {
        return NSLayoutAttributeHeight;
    }
    else if ([string isEqualToString:@"leading"])
    {
        return NSLayoutAttributeLeading;
    }
    else if ([string isEqualToString:@"baseline"])
    {
        return NSLayoutAttributeBaseline;
    }
    else if ([string isEqualToString:@"trailing"])
    {
        return NSLayoutAttributeTrailing;
    }

    return NSLayoutAttributeNotAnAttribute;
}

@end
