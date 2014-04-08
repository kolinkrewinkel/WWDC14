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

#pragma mark - Core Data Stack

- (NSManagedObjectContext *)persistentManagedObjectContext
{
    if (_persistentManagedObjectContext)
    {
        return _persistentManagedObjectContext;
    }

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

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator)
    {
        return _persistentStoreCoordinator;
    }

    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
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

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
