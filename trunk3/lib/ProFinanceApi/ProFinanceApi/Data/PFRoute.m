#import "PFRoute.h"

#import "PFMetaObject.h"
#import "PFField.h"

#import "PFOrder.h"

@interface PFRoute ()

@property ( nonatomic, strong ) NSMutableDictionary* validitiesForOrderTypes;

@end

@implementation PFRoute

@synthesize routeId;
@synthesize quoteRouteId;
@synthesize name;

@synthesize allowsTifModification;

@synthesize validitiesForOrderTypes;

+(PFMetaObject*)metaObject
{
   return [ PFMetaObject metaObjectWithFields:
           [ NSArray arrayWithObjects: [ PFMetaObjectField fieldWithId: PFFieldRouteId name: @"routeId" ]
            , [ PFMetaObjectField fieldWithId: PFFieldQuoteRouteId name: @"quoteRouteId" ]
            , [ PFMetaObjectField fieldWithId: PFFieldName name: @"name" ]
            , [ PFMetaObjectField fieldWithId: PFFieldTifModification name: @"allowsTifModification" ]
            , [ PFMetaObjectField fieldWithId: PFFieldTifsForOrderTypes name: @"validitiesForOrderTypes" transformer:
               ^id(id object_, PFFieldOwner *field_owner_, id value_)
               {
                  NSString* validities_for_orderTypes_string_ = value_;
                  NSArray* orderType_validity_pairs_ = [ validities_for_orderTypes_string_ componentsSeparatedByString: @";" ];
                  NSMutableDictionary* orderTypes_validity_ = [ NSMutableDictionary dictionaryWithCapacity: 4 ];
                  
                  for ( NSString* pair_ in orderType_validity_pairs_ )
                  {
                     NSArray* orderType_tif_strings_ = [ pair_ componentsSeparatedByString: @":" ];
                     if ( orderType_tif_strings_.count == 2 )
                     {
                        PFOrderType order_type_ = [ [ orderType_tif_strings_ objectAtIndex: 0 ] intValue ];
                        
                        PFOrderValidityType order_validity_ = [ [ orderType_tif_strings_ objectAtIndex: 1 ] intValue ];
                        
                        if ( order_validity_ == PFOrderValidityDay || order_validity_ == PFOrderValidityGtc || order_validity_ == PFOrderValidityIoc || order_validity_ == PFOrderValidityGtd )
                        {
                           NSMutableArray* validities_ = [ orderTypes_validity_ objectForKey: @(order_type_) ];
                           if ( !validities_ )
                           {
                              validities_ = [ NSMutableArray arrayWithCapacity: 4 ];
                              [ orderTypes_validity_ setObject: validities_ forKey: @(order_type_) ];
                           }
                           
                           if ( ![ validities_ containsObject: @(order_validity_) ] )
                              [ validities_ addObject: @(order_validity_) ];
                        }
                     }
                  }
                  
                  return orderTypes_validity_;
               } ]
            , nil ] ];
}

+(id)routeWithName:( NSString* )name_
{
   PFRoute* route_ = [ self new ];
   route_.name = name_;
   return route_;
}

-(NSArray*)allowedOrderTypes
{
   return self.validitiesForOrderTypes.allKeys;
}

-(NSArray*)allowedValiditiesForOrderType:( PFOrderType )order_type_
{
   if ( order_type_ == PFOrderOCO )
   {
      NSMutableSet* limit_validities_set_ = [ NSMutableSet setWithArray: [ self.validitiesForOrderTypes objectForKey: @(PFOrderLimit) ] ];
      NSSet* stop_validities_set_ = [ NSSet setWithArray: [ self.validitiesForOrderTypes objectForKey: @(PFOrderStop) ] ];
      
      [ limit_validities_set_ intersectSet: stop_validities_set_ ];
      
      return [ limit_validities_set_ allObjects ];
   }
   else
   {
      return [ self.validitiesForOrderTypes objectForKey: @(order_type_) ];
   }
}

@end
