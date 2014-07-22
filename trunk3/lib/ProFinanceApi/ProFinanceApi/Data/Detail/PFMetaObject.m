#import "PFMetaObject.h"

#import "PFField.h"
#import "PFFieldOwner.h"

@interface PFMetaObjectField ()

@property ( nonatomic, assign ) PFShort fieldId;
@property ( nonatomic, strong ) NSString* name;
@property ( nonatomic, copy ) PFMetaObjectFieldFilter filter;
@property ( nonatomic, copy ) PFMetaObjectFieldTransformer transformer;

@end

@implementation PFMetaObjectField

@synthesize fieldId;
@synthesize name;
@synthesize filter;
@synthesize transformer;

-(id)initWithId:( PFShort )id_
           name:( NSString* )name_
         filter:( PFMetaObjectFieldFilter )filter_
    transformer:( PFMetaObjectFieldTransformer )transformer_
{
   self = [ super init ];
   if ( self )
   {
      self.fieldId = id_;
      self.name = name_;
      self.filter = filter_;
      self.transformer = transformer_;
   }
   return self;
}

+(id)fieldWithId:( PFShort )id_
            name:( NSString* )name_
          filter:( PFMetaObjectFieldFilter )filter_
     transformer:( PFMetaObjectFieldTransformer )transformer_
{
   return [ [ self alloc ] initWithId: id_
                                 name: name_
                               filter: filter_
                          transformer: transformer_ ];
}

+(id)fieldWithId:( PFShort )id_
            name:( NSString* )name_
          filter:( PFMetaObjectFieldFilter )filter_
{
   return [ self fieldWithId: id_
                        name: name_
                      filter: filter_
                 transformer: nil ];
}

+(id)fieldWithId:( PFShort )id_
            name:( NSString* )name_
     transformer:( PFMetaObjectFieldTransformer )transformer_
{
   return [ self fieldWithId: id_
                        name: name_
                      filter: nil
                 transformer: transformer_ ];
}

+(id)fieldWithId:( PFShort )id_
            name:( NSString* )name_
{
   return [ self fieldWithId: id_
                        name: name_
                      filter: nil ];
}

+(id)fieldWithName:( NSString* )name_
{
   return [ self fieldWithId: PFFieldUndefined
                        name: name_ ];
}

-(void)copyObject:( id )from_object_
         toObject:( id )to_object_
{
   NSString* key_ = self.name;
   id value_ = [ from_object_ valueForKey: key_ ];
   [ to_object_ setValue: value_ forKey: key_ ];
}

-(id)transformValue:( id )value_
     fromFieldOwner:( PFFieldOwner* )field_owner_
             object:( id )object_
{
   return self.transformer ? self.transformer( object_, field_owner_, value_ ) : value_;
}

-(id)objectValueFromFieldOwner:( PFFieldOwner* )field_owner_
                        object:( id )object_
{
   if ( self.fieldId == PFFieldUndefined )
      return nil;

   PFField* field_ = [ field_owner_ fieldWithId: self.fieldId ];
   if ( !field_ )
      return nil;

   return [ self transformValue: [ field_ objectValue ]
                 fromFieldOwner: field_owner_
                         object: object_ ];
}

-(void)readFromFieldOwner:( PFFieldOwner* )field_owner_
                   object:( id )object_
{
   id value_ = [ self objectValueFromFieldOwner: field_owner_
                                         object: object_ ];
   if ( value_ )
   {
      [ object_ setValue: value_ forKey: self.name ];
   }
}

-(void)writeToFieldOwner:( PFFieldOwner* )field_owner_
                  object:( id )object_
{
   if ( self.fieldId == PFFieldUndefined )
      return;

   if ( !self.filter || self.filter( object_ ) )
   {
      PFField* field_ = [ field_owner_ writeFieldWithId: self.fieldId ];
      field_.objectValue = [ object_ valueForKey: self.name ];
   }
}

-(NSString*)descriptionForObject:( id )object_
{
   return [ NSString stringWithFormat: @"%@ (%d) = '%@'"
           , self.name
           , self.fieldId
           , [ object_ valueForKey: self.name ] ];
}

@end

@interface PFMetaObject ()

@property ( nonatomic, strong ) NSArray* fields;
@property ( nonatomic, strong, readonly ) NSDictionary* fieldsById;

@end

@implementation PFMetaObject

@synthesize fields;
@synthesize fieldsById = _fieldById;

-(id)initWithFields:( NSArray* )fields_
{
   self = [ super init ];
   if ( self )
   {
      self.fields = fields_;
   }
   return self;
}

+(id)metaObjectWithFields:( NSArray* )fields_
{
   return [ [ self alloc ] initWithFields: fields_ ];
}

-(id)metaObjectByAddingFields:( NSArray* )fields_
{
   NSArray* all_fields_ = self.fields
      ? [ self.fields arrayByAddingObjectsFromArray: fields_ ]
      : fields_;

   return [ [ [ self class ] alloc ] initWithFields: all_fields_ ];
}


-(id)metaObjectByAddingFieldsFromMetaObject:( PFMetaObject* )meta_object_
{
   return [ self metaObjectByAddingFields: meta_object_.fields ];
}

-(NSDictionary*)fieldsById
{
   if ( !_fieldById )
   {
      NSMutableDictionary* fields_by_id_ = [ NSMutableDictionary dictionaryWithCapacity: [ self.fields count ] ];
      for ( PFMetaObjectField* field_ in self.fields )
      {
         if ( field_.fieldId != PFFieldUndefined )
         {
            [ fields_by_id_ setObject: field_ forKey: @(field_.fieldId) ];
         }
      }
      _fieldById = fields_by_id_;
   }
   return _fieldById;
}

-(void)copyObject:( id )from_object_
         toObject:( id )to_object_
{
   for ( PFMetaObjectField* field_ in self.fields )
   {
      [ field_ copyObject: from_object_
                 toObject: to_object_ ];
   }
}

-(void)readFromFieldOwner:( PFFieldOwner* )field_owner_
                   object:( id )object_
{
   for ( PFField* protocol_field_ in field_owner_.fields )
   {
      PFMetaObjectField* mo_field_ = [ self.fieldsById objectForKey: @(protocol_field_.fieldId) ];
      [ mo_field_ readFromFieldOwner: field_owner_ object: object_ ];
   }
}

-(id)readValueForKey:( NSString* )key_
      fromFieldOwner:( PFFieldOwner* )field_owner_
{
   PFMetaObjectField* mo_field_ = [ self.fieldsById objectForKey: key_ ];
   return [ mo_field_ objectValueFromFieldOwner: field_owner_ object: self ];
}

-(void)writeToFieldOwner:( PFFieldOwner* )field_owner_
                  object:( id )object_
{
   for ( PFMetaObjectField* mo_field_ in self.fields )
   {
      [ mo_field_ writeToFieldOwner: field_owner_ object: object_ ];
   }
}

-(void)writeToFieldOwner:( PFFieldOwner* )field_owner_
                  object:( id )object_
                  fields:( NSArray* )fields_
{
   for ( NSNumber* field_id_ in fields_ )
   {
      PFMetaObjectField* mo_field_ = [ self.fieldsById objectForKey: field_id_ ];
      NSAssert( mo_field_, @"invalid field" );
      [ mo_field_ writeToFieldOwner: field_owner_ object: object_ ];
   }
}

-(void)writeToFieldOwner:( PFFieldOwner* )field_owner_
                  object:( id )object_
         excludingFields:( NSSet* )fields_
{
   for ( PFMetaObjectField* mo_field_ in self.fields )
   {
      if ( ![ fields_ containsObject: @(mo_field_.fieldId) ] )
      {
         [ mo_field_ writeToFieldOwner: field_owner_ object: object_ ];
      }
   }
}

-(NSString*)descriptionForObject:( id )object_
{
   NSMutableArray* description_ = [ NSMutableArray arrayWithCapacity: 1/*Header*/ + [ self.fields count ] ];

   [ description_ addObject: NSStringFromClass( [ object_ class ] ) ];

   for ( PFMetaObjectField* mo_field_ in self.fields )
   {
      [ description_ addObject: [ mo_field_ descriptionForObject: object_ ] ];
   }
   
   return [ description_ componentsJoinedByString: @"\n\t" ];
}

@end

