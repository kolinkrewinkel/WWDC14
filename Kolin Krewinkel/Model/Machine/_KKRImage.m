// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KKRImage.m instead.

#import "_KKRImage.h"

const struct KKRImageAttributes KKRImageAttributes = {
	.cachedPath = @"cachedPath",
	.url = @"url",
};

const struct KKRImageRelationships KKRImageRelationships = {
	.product = @"product",
};

const struct KKRImageFetchedProperties KKRImageFetchedProperties = {
};

@implementation KKRImageID
@end

@implementation _KKRImage

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

- (KKRImageID*)objectID {
	return (KKRImageID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic cachedPath;






@dynamic url;






@dynamic product;

	






@end
