// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KKRImage.h instead.

#import <CoreData/CoreData.h>
#import "KKRTransitionable.h"

extern const struct KKRImageAttributes {
	__unsafe_unretained NSString *cachedPath;
	__unsafe_unretained NSString *url;
} KKRImageAttributes;

extern const struct KKRImageRelationships {
	__unsafe_unretained NSString *product;
} KKRImageRelationships;

extern const struct KKRImageFetchedProperties {
} KKRImageFetchedProperties;

@class KKRProduct;




@interface KKRImageID : NSManagedObjectID {}
@end

@interface _KKRImage : KKRTransitionable {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (KKRImageID*)objectID;





@property (nonatomic, strong) NSString* cachedPath;



//- (BOOL)validateCachedPath:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* url;



//- (BOOL)validateUrl:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) KKRProduct *product;

//- (BOOL)validateProduct:(id*)value_ error:(NSError**)error_;





@end

@interface _KKRImage (CoreDataGeneratedAccessors)

@end

@interface _KKRImage (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveCachedPath;
- (void)setPrimitiveCachedPath:(NSString*)value;




- (NSString*)primitiveUrl;
- (void)setPrimitiveUrl:(NSString*)value;





- (KKRProduct*)primitiveProduct;
- (void)setPrimitiveProduct:(KKRProduct*)value;


@end
