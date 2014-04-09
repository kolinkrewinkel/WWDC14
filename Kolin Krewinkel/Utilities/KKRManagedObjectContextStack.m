//
//  KKRManagedObjectContextStack.m
//  Kolin Krewinkel
//
//  Created by Kolin Krewinkel on 4/8/14.
//  Copyright (c) 2014 Kolin Krewinkel. All rights reserved.
//

#import "KKRManagedObjectContextStack.h"

@interface KKRManagedObjectContextStack ()

@property (nonatomic, strong) NSManagedObjectContext *mutationManagedObjectContext;
@property (nonatomic, strong) NSManagedObjectContext *interfaceManagedObjectContext;
@property (nonatomic, strong) NSManagedObjectContext *persistentManagedObjectContext;

@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation KKRManagedObjectContextStack

#pragma mark - Singleton

+ (instancetype)defaultStack
{
    static dispatch_once_t onceToken;
    static id defaultStack;

    dispatch_once(&onceToken, ^{
        defaultStack = [[[self class] alloc] init];
    });

    return defaultStack;
}

#pragma mark - Core Data Stack

- (NSManagedObjectContext *)persistentManagedObjectContext
{
    if (_persistentManagedObjectContext)
    {
        return _persistentManagedObjectContext;
    }

    // Parent of both mutation and interface MOCs.
    _persistentManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    _persistentManagedObjectContext.persistentStoreCoordinator = [self persistentStoreCoordinator];

    return _persistentManagedObjectContext;
}

- (NSManagedObjectContext *)mutationManagedObjectContext
{
    if (_mutationManagedObjectContext)
    {
        return _mutationManagedObjectContext;
    }

    // For any changes; fetches will not block.
    _mutationManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    _mutationManagedObjectContext.parentContext = [self persistentManagedObjectContext];

    return _mutationManagedObjectContext;
}

- (NSManagedObjectContext *)interfaceManagedObjectContext
{
    if (_interfaceManagedObjectContext)
    {
        return _interfaceManagedObjectContext;
    }

    // One of two original children from the persistentMOC. For use with anything UI/main thread.
    _interfaceManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _interfaceManagedObjectContext.parentContext = [self persistentManagedObjectContext];

    return _interfaceManagedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel)
    {
        return _managedObjectModel;
    }

    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Kolin_Krewinkel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];

    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator)
    {
        return _persistentStoreCoordinator;
    }

    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    [self addPersistentStoreToCoordinator:_persistentStoreCoordinator retryCount:0];

    return _persistentStoreCoordinator;
}

- (void)addPersistentStoreToCoordinator:(NSPersistentStoreCoordinator *)coordinator retryCount:(NSUInteger)retryCount
{
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Kolin_Krewinkel.sqlite"];
    NSError *error = nil;

    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:@{NSMigratePersistentStoresAutomaticallyOption: @YES, NSInferMappingModelAutomaticallyOption: @YES} error:&error])
    {
        // Only attempt once to resolve the error by clearing.
        if (retryCount > 0)
        {
            NSLog(@"Unresolved error in persistent store coordinator: %@", [error localizedDescription]);
            return;
        }

        // Clear the existing persistent store.
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];

        // Increment and retry now that the file's been cleared.
        retryCount++;
        [self addPersistentStoreToCoordinator:coordinator retryCount:retryCount];
    }
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - External Usage

- (void)performBlock:(KKRManagedObjectContextStackChangeReturningSaveBlock)block
{
    __weak typeof(self) weakSelf = self;

    [self.mutationManagedObjectContext performBlock:^{
        if (block(weakSelf.mutationManagedObjectContext, weakSelf.interfaceManagedObjectContext, weakSelf.persistentManagedObjectContext))
        {
            __block NSError *error = nil;
            [self.mutationManagedObjectContext save:&error];

            if (error)
            {
                NSLog(@"%@", error);

                return;
            }

            [self.persistentManagedObjectContext performBlock:^{
                [self.persistentManagedObjectContext save:&error];

                if (error)
                {
                    NSLog(@"%@", error);

                    return;
                }
            }];
        }
    }];
}

@end
