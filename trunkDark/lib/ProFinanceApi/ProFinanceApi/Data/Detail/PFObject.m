#import "PFObject.h"

#import "PFMetaObject.h"
#import "PFTrigger.h"

@interface NSObject (PFObject)

+(PFMetaObject*)cachedMetaObject;

@end

@implementation NSObject (PFObject)

+(PFMetaObject*)cachedMetaObject
{
   return nil;
}

@end

@interface PFObject ()

@property ( nonatomic, strong, readonly ) NSMutableSet* triggers;

@end


@implementation PFObject

@synthesize triggers = _triggers;

-(NSMutableSet*)triggers
{
   if ( !_triggers )
   {
      _triggers = [ NSMutableSet new ];
   }
   return _triggers;
}

+(NSMutableDictionary*)metaObjectsByClass
{
   static NSMutableDictionary* meta_objects_ = nil;
   if ( !meta_objects_ )
   {
      meta_objects_ = [ NSMutableDictionary new ];
   }
   return meta_objects_;
}

+(PFMetaObject*)metaObject
{
   return [ PFMetaObject new ];
}

+(PFMetaObject*)cachedMetaObject
{
   NSString* class_name_ = NSStringFromClass( self );
   PFMetaObject* meta_object_ = [ [ self metaObjectsByClass ] objectForKey: class_name_ ];

   if ( !meta_object_ )
   {
      PFMetaObject* super_meta_object_ = [ [ self superclass ] cachedMetaObject ];
      PFMetaObject* self_meta_object_ = [ self metaObject ];

      meta_object_ = super_meta_object_
         ? [ super_meta_object_ metaObjectByAddingFieldsFromMetaObject: self_meta_object_ ]
         : self_meta_object_;

      [ [ self metaObjectsByClass ] setObject: meta_object_
                                       forKey: class_name_ ];
   }

   return meta_object_;
}

-(PFMetaObject*)metaObject
{
   return [ [ self class ] cachedMetaObject ];
}

+(id)objectWithFieldOwner:( PFFieldOwner* )field_owner_
{
   PFObject* object_ = [ self new ];
   [ object_ updateWithFieldOwner: field_owner_ ];
   return object_;
}

-(void)writeToFieldOwner:( PFFieldOwner* )field_owner_
{
   PFMetaObject* meta_object_ = [ self metaObject ];
   [ meta_object_ writeToFieldOwner: field_owner_
                             object: self ];
}

-(void)writeToFieldOwner:( PFFieldOwner* )field_owner_
                  fields:( NSArray* )fields_
{
   PFMetaObject* meta_object_ = [ self metaObject ];
   [ meta_object_ writeToFieldOwner: field_owner_
                             object: self
                             fields: fields_ ];
}

-(void)invokeTriggers
{
   NSSet* triggers_copy_ = [ _triggers copy ];
   for ( PFTrigger* trigger_ in triggers_copy_ )
   {
      PFTriggerResult result_ = [ trigger_ invokeWithObject: self ];
      
      if ( result_ == PFTriggerExpired || ( result_ == PFTriggerInvoked && trigger_.removeAfterInvoke ) )
      {
         [ _triggers removeObject: trigger_ ];
      }
   }
}

-(void)willUpdateWithFieldOwner:( PFFieldOwner* )field_owner_
{
}

-(void)didUpdateWithFieldOwner:( PFFieldOwner* )field_owner_
{
}

-(void)updateWithFieldOwner:( PFFieldOwner* )field_owner_
{
   [ self willUpdateWithFieldOwner: field_owner_ ];

   PFMetaObject* meta_object_ = [ self metaObject ];
   [ meta_object_ readFromFieldOwner: field_owner_ object: self ];
   [ self invokeTriggers ];

   [ self didUpdateWithFieldOwner: field_owner_ ];
}

-(void)readFromFieldOwner:( PFFieldOwner* )field_owner_
{
   [ self updateWithFieldOwner: field_owner_ ];
}

+(void)writeToFieldOwner:( PFFieldOwner* )field_owner_
                  object:( id )object_
{
   PFMetaObject* meta_object_ = [ self cachedMetaObject ];
   [ meta_object_ writeToFieldOwner: field_owner_
                             object: object_ ];
}

+(void)writeToFieldOwner:( PFFieldOwner* )field_owner_
                  object:( id )object_
                  fields:( NSArray* )fields_
{
   PFMetaObject* meta_object_ = [ self cachedMetaObject ];
   [ meta_object_ writeToFieldOwner: field_owner_
                             object: object_
                             fields: fields_ ];
}

+(id)readValueForKey:( NSString* )key_
      fromFieldOwner:( PFFieldOwner* )field_owner_
{
   PFMetaObject* meta_object_ = [ self cachedMetaObject ];
   return [ meta_object_ readValueForKey: key_
                          fromFieldOwner: field_owner_ ];
}

-(id)copyWithZone:( NSZone* )zone_
{
   PFObject* copy_ = [ [ [ self class ] allocWithZone: zone_ ] init ];

   PFMetaObject* meta_object_ = [ self metaObject ];
   [ meta_object_ copyObject: self
                    toObject: copy_ ];

   return copy_;
}

-(NSString*)description
{
   PFMetaObject* meta_object_ = [ self metaObject ];
   return [ meta_object_ descriptionForObject: self ];
}

-(void)addTrigger:( PFTrigger* )trigger_
{
   [ self.triggers addObject: trigger_ ];
}

@end
