// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KKREvent.m instead.

#import "_KKREvent.h"

const struct KKREventAttributes KKREventAttributes = {
	.cachedPath = @"cachedPath",
	.url = @"url",
};

const struct KKREventRelationships KKREventRelationships = {
	.product = @"product",
};

const struct KKREventFetchedProperties KKREventFetchedProperties = {
};

@implementation KKREventID
@end

@implementation _KKREvent

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Image" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Image";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Image" inManagedObjectContext:moc_];
}

- (KKREventID*)objectID {
	return (KKREventID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic cachedPath;






@dynamic url;






@dynamic product;

	






@end
