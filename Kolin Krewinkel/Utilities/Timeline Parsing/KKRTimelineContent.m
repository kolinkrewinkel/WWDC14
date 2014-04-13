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
    content.position = [KKRTimelineContentPosition positionWithJSON:JSON[@"position"]];

    if ([JSON[@"content"] count])
    {
        NSMutableArray *childContents = [[NSMutableArray alloc] init];
        [JSON[@"content"] enumerateObjectsUsingBlock:^(NSDictionary *childNodeDict, NSUInteger idx, BOOL *stop) {
            [childContents addObject:[KKRTimelineContent contentWithJSON:childNodeDict]];
        }];

        content.childContents = childContents;
    }

    return content;
}

@end

@implementation KKRTimelineContentPosition

#pragma mark -

+ (instancetype)positionWithJSON:(NSArray *)JSON
{
    KKRTimelineContentPosition *position = [[[self class] alloc] init];
    position.constraints = ({
        NSMutableArray *constraints = [[NSMutableArray alloc] init];
        [JSON enumerateObjectsUsingBlock:^(NSDictionary *constraint, NSUInteger idx, BOOL *stop) {
            [constraints addObject:[KKRTimelineContentPositionConstraint positionConstraintWithJSON:constraint position:position]];
        }];

        constraints;
    });

    return position;
}

@end

@interface KKRTimelineContentPositionConstraint ()

@property (nonatomic) NSLayoutAttribute attribute;
@property (nonatomic) CGFloat multiplier;
@property (nonatomic) CGFloat constant;
@property (nonatomic) NSLayoutAttribute relatedAttribute;
@property (nonatomic, copy) NSString *viewRelationship;

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
    constraint.viewRelationship = JSON[@"toView"];

    return constraint;
}

- (NSLayoutConstraint *)constraintWithView:(UIView *)view
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view attribute:self.attribute relatedBy:NSLayoutRelationEqual toItem:[view kkr_relatedViewWithIdentifier:self.viewRelationship] attribute:self.relatedAttribute multiplier:self.multiplier constant:self.constant];
    [view kkr_setHierarchyIdentifier:self.position.content.identifier];

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

    return NSLayoutAttributeNotAnAttribute;
}

@end
