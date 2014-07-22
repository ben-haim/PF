#import "PFFieldOwner.h"

#import "PFField.h"

@interface PFField (PFFieldOwner)
 
-(void)addToFieldOwner:( PFFieldOwner* )field_owner_;
 
@end


@interface PFPlainFieldKey : NSObject< NSCopying >

@property ( nonatomic, assign ) PFShort fieldId;

+(id)keyWithFieldId:( PFShort )field_id_;

@end

@implementation PFPlainFieldKey

@synthesize fieldId;

-(id)initWithFieldId:( PFShort )field_id_
{
   self = [ super init ];
   if ( self )
   {
      self.fieldId = field_id_;
   }
   return self;
}

+(id)keyWithFieldId:( PFShort )field_id_
{
   return [ [ self alloc ] initWithFieldId: field_id_ ];
}

-(NSUInteger)hash
{
   return self.fieldId;
}

-(BOOL)isEqual:( id )other_
{
   if ( [ self class ] != [ other_ class ] )
      return NO;
   
   PFPlainFieldKey* other_field_key_ = ( PFPlainFieldKey* )other_;
   return self.fieldId == other_field_key_.fieldId;
}

-(id)copyWithZone:( NSZone* )zone_
{
   return [ [ [ self class ] alloc ] initWithFieldId: self.fieldId ];
}

@end

@interface PFGroupFieldKey : NSObject< NSCopying >

@property ( nonatomic, assign ) PFInteger groupId;

+(id)keyWithGroupId:( PFInteger )group_id_;

@end

@implementation PFGroupFieldKey

@synthesize groupId;

-(id)initWithGroupId:( PFInteger )group_id_
{
   self = [ super init ];
   if ( self )
   {
      self.groupId = group_id_;
   }
   return self;
}

+(id)keyWithGroupId:( PFInteger )group_id_
{
   return [ [ self alloc ] initWithGroupId: group_id_ ];
}

-(NSUInteger)hash
{
   return self.groupId;
}

-(BOOL)isEqual:( id )other_
{
   if ( [ self class ] != [ other_ class ] )
      return NO;
   
   PFGroupFieldKey* other_group_key_ = ( PFGroupFieldKey* )other_;
   return self.groupId == other_group_key_.groupId;
}

-(id)copyWithZone:( NSZone* )zone_
{
   return [ [ [ self class ] alloc ] initWithGroupId: self.groupId ];
}

@end

@interface PFFieldOwner ()

//is usefull for print in same order as they where pushed
@property ( nonatomic, strong ) NSMutableArray* mutableFields;
@property ( nonatomic, strong ) NSMutableDictionary* fieldsById;

@end

@implementation PFFieldOwner

@synthesize mutableFields = _mutableFields;
@synthesize fieldsById = _fieldsById;

-(NSMutableArray*)mutableFields
{
   if ( !_mutableFields )
   {
      _mutableFields = [ NSMutableArray new ];
   }
   return _mutableFields;
}

-(NSMutableDictionary*)fieldsById
{
   if ( !_fieldsById )
   {
      _fieldsById = [ NSMutableDictionary new ];
   }
   return _fieldsById;
}

-(NSArray*)fields
{
   return self.mutableFields;
}

-(void)addField:( PFField* )field_
{
   [ field_ addToFieldOwner: self ];
}

-(void)addPlainField:( PFField* )field_
{
   [ self.mutableFields addObject: field_ ];
   PFPlainFieldKey* key_ = [ PFPlainFieldKey keyWithFieldId: field_.fieldId ];
   [ self.fieldsById setObject: field_ forKey: key_ ];
}

-(NSMutableArray*)mutableGroupFieldsWithId:( PFInteger )group_id_
{
   PFGroupFieldKey* key_ = [ PFGroupFieldKey keyWithGroupId: group_id_ ];
   NSMutableArray* groups_ = [ self.fieldsById objectForKey: key_ ];

   if ( !groups_ )
   {
      groups_ = [ NSMutableArray array ];
      [ self.fieldsById setObject: groups_ forKey: key_ ];
   }

   return groups_;
}

-(id)fieldWithId:( PFShort )id_
{
   NSAssert( id_ != PFFieldGroup && id_ != PFFieldLongGroup, @"can't be group id" );

   PFPlainFieldKey* key_ = [ PFPlainFieldKey keyWithFieldId: id_ ];
   return [ self.fieldsById objectForKey: key_ ];
}

-(id)writeFieldWithId:( PFShort )id_
{
   PFField* field_ = [ self fieldWithId: id_ ];
   if ( !field_ )
   {
      field_ = [ PFField fieldWithId: id_ ];
      [ self addPlainField: field_ ];
   }

   return field_;
}

-(NSArray*)groupFieldsWithId:( PFInteger )group_id_
{
   return [ self mutableGroupFieldsWithId: group_id_ ];
}

-(PFGroupField*)groupFieldWithId:( PFInteger )group_id_
{
   NSArray* groups_ = [ self groupFieldsWithId: group_id_ ];
   return [ groups_ count ] > 0 ? [ groups_ objectAtIndex: 0 ] : nil;
}

-(void)addGroupField:( PFGroupField* )group_
{
   [ self.mutableFields addObject: group_ ];
   NSMutableArray* groups_ = [ self mutableGroupFieldsWithId: group_.groupId ];
   [ groups_ addObject: group_ ];
}

-(PFGroupField*)writeGroupFieldWithId:( PFInteger )group_id_
{
   PFGroupField* group_ = [ PFGroupField groupWithId: group_id_ ];
   [ self addGroupField: group_ ];
   return group_;
}

-(NSString*)description
{
   return [ NSString stringWithFormat: @"{%@}", [ self.fields componentsJoinedByString: @"; " ] ];
}

@end

@implementation PFFieldOwner (Optional)

-(PFInteger)integerValueForFieldWithId:( PFShort )id_
{
   static PFInteger undefined_integer_value_ = -1;

   PFIntegerField* integer_field_ = [ self fieldWithId: id_ ];
   return integer_field_
      ? [ integer_field_ integerValue ]
      : undefined_integer_value_;
}

@end

@implementation PFField (PFFieldOwner)

-(void)addToFieldOwner:( PFFieldOwner* )field_owner_
{
   [ field_owner_ addPlainField: self ];
}

@end

@implementation PFGroupField (PFFieldOwner)

-(void)addToFieldOwner:( PFFieldOwner* )field_owner_
{
   [ field_owner_ addGroupField: self ];
}

@end
