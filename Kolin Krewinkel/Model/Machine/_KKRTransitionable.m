// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KKRTransitionable.m instead.

#import "_KKRTransitionable.h"

const struct KKRTransitionableAttributes KKRTransitionableAttributes = {
	.transitionType = @"transitionType",
};

const struct KKRTransitionableRelationships KKRTransitionableRelationships = {
};

const struct KKRTransitionableFetchedProperties KKRTransitionableFetchedProperties = {
};

@implementation KKRTransitionableID
@end

@implementation _KKRTransitionable

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Transitionable" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Transitionable";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Transitionable" inManagedObjectContext:moc_];
}

- (KKRTransitionableID*)objectID {
	return (KKRTransitionableID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic transitionType;











@end
