// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KKRProduct.h instead.

#import <CoreData/CoreData.h>
#import "KKRTransitionable.h"

extern const struct KKRProductAttributes {
	__unsafe_unretained NSString *subtitle;
	__unsafe_unretained NSString *textDescription;
	__unsafe_unretained NSString *title;
	__unsafe_unretained NSString *year;
} KKRProductAttributes;

extern const struct KKRProductRelationships {
	__unsafe_unretained NSString *images;
} KKRProductRelationships;

extern const struct KKRProductFetchedProperties {
} KKRProductFetchedProperties;

@class KKRImage;






@interface KKRProductID : NSManagedObjectID {}
@end

@interface _KKRProduct : KKRTransitionable {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (KKRProductID*)objectID;





@property (nonatomic, strong) NSString* subtitle;



//- (BOOL)validateSubtitle:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* textDescription;



//- (BOOL)validateTextDescription:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* title;



//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* year;



@property int64_t yearValue;
- (int64_t)yearValue;
- (void)setYearValue:(int64_t)value_;

//- (BOOL)validateYear:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSOrderedSet *images;

- (NSMutableOrderedSet*)imagesSet;





@end

@interface _KKRProduct (CoreDataGeneratedAccessors)

- (void)addImages:(NSOrderedSet*)value_;
- (void)removeImages:(NSOrderedSet*)value_;
- (void)addImagesObject:(KKRImage*)value_;
- (void)removeImagesObject:(KKRImage*)value_;

@end

@interface _KKRProduct (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveSubtitle;
- (void)setPrimitiveSubtitle:(NSString*)value;




- (NSString*)primitiveTextDescription;
- (void)setPrimitiveTextDescription:(NSString*)value;




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;




- (NSNumber*)primitiveYear;
- (void)setPrimitiveYear:(NSNumber*)value;

- (int64_t)primitiveYearValue;
- (void)setPrimitiveYearValue:(int64_t)value_;





- (NSMutableOrderedSet*)primitiveImages;
- (void)setPrimitiveImages:(NSMutableOrderedSet*)value;


@end
