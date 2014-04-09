// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KKRProduct.m instead.

#import "_KKRProduct.h"

const struct KKRProductAttributes KKRProductAttributes = {
	.subtitle = @"subtitle",
	.textDescription = @"textDescription",
	.title = @"title",
	.year = @"year",
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
	return [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Product";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Product" inManagedObjectContext:moc_];
}

- (KKRProductID*)objectID {
	return (KKRProductID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"yearValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"year"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic subtitle;






@dynamic textDescription;






@dynamic title;






@dynamic year;



- (int64_t)yearValue {
	NSNumber *result = [self year];
	return [result longLongValue];
}

- (void)setYearValue:(int64_t)value_ {
	[self setYear:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveYearValue {
	NSNumber *result = [self primitiveYear];
	return [result longLongValue];
}

- (void)setPrimitiveYearValue:(int64_t)value_ {
	[self setPrimitiveYear:[NSNumber numberWithLongLong:value_]];
}





@dynamic images;

	
- (NSMutableOrderedSet*)imagesSet {
	[self willAccessValueForKey:@"images"];
  
	NSMutableOrderedSet *result = (NSMutableOrderedSet*)[self mutableOrderedSetValueForKey:@"images"];
  
	[self didAccessValueForKey:@"images"];
	return result;
}
	






@end
