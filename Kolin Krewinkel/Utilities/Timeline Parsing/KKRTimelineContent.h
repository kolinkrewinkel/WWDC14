//
//  KKRTimelineContent.h
//  Kolin Krewinkel
//
//  Created by Kolin Krewinkel on 4/13/14.
//  Copyright (c) 2014 Kolin Krewinkel. All rights reserved.
//


@class KKRTimelineContentPosition;
@interface KKRTimelineContent : NSObject

#pragma mark - Designated Initializer

+ (instancetype)contentWithJSON:(NSDictionary *)JSON;

#pragma mark - 

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) KKRTimelineContentPosition *position;
@property (nonatomic, strong) NSArray *childContents;
@property (nonatomic, strong) NSString *identifier;

@end

@interface KKRTimelineContentPosition : NSObject

#pragma mark -

+ (instancetype)positionWithJSON:(NSArray *)JSON;

#pragma mark - Properties

@property (nonatomic, strong) NSArray *constraints;
@property (nonatomic, weak, readonly) KKRTimelineContent *content;

@end

@interface KKRTimelineContentPositionConstraint : NSObject

+ (instancetype)positionConstraintWithJSON:(NSDictionary *)JSON position:(KKRTimelineContentPosition *)position;

- (NSLayoutConstraint *)constraintWithView:(UIView *)view;

@property (nonatomic, weak, readonly) KKRTimelineContentPosition *position;

@end
