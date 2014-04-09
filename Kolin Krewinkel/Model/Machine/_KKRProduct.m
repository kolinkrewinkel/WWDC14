// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KKRProduct.m instead.

#import "_KKRProduct.h"

const struct KKRProductAttributes KKRProductAttributes = {
	.subtitle = @"subtitle",
	.textDescription = @"textDescription",
	.timestamp = @"timestamp",
	.title = @"title",
};

const struct KKRProductRelationships KKRProductRelationships = {
	.images = @"images",
};

const struct KKRProductFetchedProperties KKRProductFetchedProperties = {
};

@implementation KKRProductID
@end

@implementation _KKRProduct

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Event";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Event" inManagedObjectContext:moc_];
}

- (KKRProductID*)objectID {
	return (KKRProductID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic subtitle;






@dynamic textDescription;






@dynamic timestamp;






@dynamic title;






@dynamic images;

	
- (NSMutableOrderedSet*)imagesSet {
	[self willAccessValueForKey:@"images"];
  
	NSMutableOrderedSet *result = (NSMutableOrderedSet*)[self mutableOrderedSetValueForKey:@"images"];
  
	[self didAccessValueForKey:@"images"];
	return result;
}
	






@end
