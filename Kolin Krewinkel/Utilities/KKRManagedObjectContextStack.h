//
//  KKRManagedObjectContextStack.h
//  Kolin Krewinkel
//
//  Created by Kolin Krewinkel on 4/8/14.
//  Copyright (c) 2014 Kolin Krewinkel. All rights reserved.
//

#import "KKRTransitionable.h"
#import "KKREvent.h"
#import "KKRImage.h"

typedef BOOL(^KKRManagedObjectContextStackChangeReturningSaveBlock)(NSManagedObjectContext *mutationContext, NSManagedObjectContext *interfaceContext, NSManagedObjectContext *persistenceContext);

@interface KKRManagedObjectContextStack : NSObject

#pragma mark - Singleton

+ (instancetype)defaultStack;

#pragma mark - The One and Only Way.

- (void)performBlock:(KKRManagedObjectContextStackChangeReturningSaveBlock)block;

@end
