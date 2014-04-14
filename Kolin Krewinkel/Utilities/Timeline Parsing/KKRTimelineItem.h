//
//  KKRTimelineItem.h
//  Kolin Krewinkel
//
//  Created by Kolin Krewinkel on 4/13/14.
//  Copyright (c) 2014 Kolin Krewinkel. All rights reserved.
//

@class KKRTimelineContent;
@interface KKRTimelineItem : NSObject

#pragma mark - Designate Initializer 

+ (instancetype)timelineItemWithJSON:(NSDictionary *)JSON;

#pragma mark - View Construction

- (void)assembleViewHierarchyInContainer:(UIView *)container;

#pragma mark - Properties

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSDate *date;
@property (nonatomic, strong) KKRTimelineContent *content;
@property (nonatomic, copy) NSString *background;

@end
