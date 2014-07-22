#import "../../PFTypes.h"

#import <Foundation/Foundation.h>

typedef BOOL (^PFMetaObjectFieldFilter)( id object_ );

@class PFFieldOwner;
typedef id (^PFMetaObjectFieldTransformer)( id object_, PFFieldOwner* field_owner_, id value_ );

@interface PFMetaObjectField : NSObject

@property ( nonatomic, assign, readonly ) PFShort fieldId;
@property ( nonatomic, strong, readonly ) NSString* name;
@property ( nonatomic, copy, readonly ) PFMetaObjectFieldFilter filter;
@property ( nonatomic, copy, readonly ) PFMetaObjectFieldTransformer transformer;

+(id)fieldWithName:( NSString* )name_;

+(id)fieldWithId:( PFShort )id_
            name:( NSString* )name_;

+(id)fieldWithId:( PFShort )id_
            name:( NSString* )name_
          filter:( PFMetaObjectFieldFilter )filter_;

+(id)fieldWithId:( PFShort )id_
            name:( NSString* )name_
     transformer:( PFMetaObjectFieldTransformer )transformer_;

+(id)fieldWithId:( PFShort )id_
            name:( NSString* )name_
          filter:( PFMetaObjectFieldFilter )filter_
     transformer:( PFMetaObjectFieldTransformer )transformer_;

@end

@class PFFieldOwner;

@interface PFMetaObject : NSObject

+(id)metaObjectWithFields:( NSArray* )fields_;

-(id)metaObjectByAddingFields:( NSArray* )fields_;
-(id)metaObjectByAddingFieldsFromMetaObject:( PFMetaObject* )meta_object_;

-(void)copyObject:( id )from_object_
         toObject:( id )to_object_;

-(void)readFromFieldOwner:( PFFieldOwner* )field_owner_
                   object:( id )object_;

-(id)readValueForKey:( NSString* )key_
      fromFieldOwner:( PFFieldOwner* )field_owner_;

-(void)writeToFieldOwner:( PFFieldOwner* )field_owner_
                  object:( id )object_;

-(void)writeToFieldOwner:( PFFieldOwner* )field_owner_
                  object:( id )object_
                  fields:( NSArray* )fields_;

-(void)writeToFieldOwner:( PFFieldOwner* )field_owner_
                  object:( id )object_
         excludingFields:( NSSet* )fields_;

-(NSString*)descriptionForObject:( id )object_;

@end
