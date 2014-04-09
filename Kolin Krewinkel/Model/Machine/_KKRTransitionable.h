// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KKRTransitionable.h instead.

#import <CoreData/CoreData.h>


extern const struct KKRTransitionableAttributes {
	__unsafe_unretained NSString *transitionType;
} KKRTransitionableAttributes;

extern const struct KKRTransitionableRelationships {
} KKRTransitionableRelationships;

extern const struct KKRTransitionableFetchedProperties {
} KKRTransitionableFetchedProperties;




@interface KKRTransitionableID : NSManagedObjectID {}
@end

@interface _KKRTransitionable : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (KKRTransitionableID*)objectID;





@property (nonatomic, strong) NSString* transitionType;



//- (BOOL)validateTransitionType:(id*)value_ error:(NSError**)error_;






@end

@interface _KKRTransitionable (CoreDataGeneratedAccessors)

@end

@interface _KKRTransitionable (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveTransitionType;
- (void)setPrimitiveTransitionType:(NSString*)value;




@end
