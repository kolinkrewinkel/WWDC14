// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KKREvent.h instead.

#import <CoreData/CoreData.h>
#import "KKRTransitionable.h"

extern const struct KKREventAttributes {
	__unsafe_unretained NSString *cachedPath;
	__unsafe_unretained NSString *url;
} KKREventAttributes;

extern const struct KKREventRelationships {
	__unsafe_unretained NSString *product;
} KKREventRelationships;

extern const struct KKREventFetchedProperties {
} KKREventFetchedProperties;

@class KKRProduct;




@interface KKREventID : NSManagedObjectID {}
@end

@interface _KKREvent : KKRTransitionable {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (KKREventID*)objectID;





@property (nonatomic, strong) NSString* cachedPath;



//- (BOOL)validateCachedPath:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* url;



//- (BOOL)validateUrl:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) KKRProduct *product;

//- (BOOL)validateProduct:(id*)value_ error:(NSError**)error_;





@end

@interface _KKREvent (CoreDataGeneratedAccessors)

@end

@interface _KKREvent (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveCachedPath;
- (void)setPrimitiveCachedPath:(NSString*)value;




- (NSString*)primitiveUrl;
- (void)setPrimitiveUrl:(NSString*)value;





- (KKRProduct*)primitiveProduct;
- (void)setPrimitiveProduct:(KKRProduct*)value;


@end
