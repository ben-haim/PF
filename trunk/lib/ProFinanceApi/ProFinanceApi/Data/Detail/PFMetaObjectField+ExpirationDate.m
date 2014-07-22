#import "PFMetaObjectField+ExpirationDate.h"

#import "PFFieldOwner.h"
#import "PFField.h"

@implementation PFMetaObjectField (ExpirationDate)

+(id)expirationDateFieldWithName:( NSString* )name_
{
   PFMetaObjectFieldTransformer expiration_date_transformer_ = ^id(id object_, PFFieldOwner* field_owner_, id year_value_)
   {
      NSDateComponents* date_components_ = [ NSDateComponents new ];
      date_components_.day = [ [ field_owner_ fieldWithId: PFFieldExpDay ] byteValue ];
      date_components_.month = [ [ field_owner_ fieldWithId: PFFieldExpMonth ] byteValue ];
      date_components_.year = [ year_value_ shortValue ];
      NSCalendar* calendar_ = [ [ NSCalendar alloc ] initWithCalendarIdentifier: NSGregorianCalendar ];
      return [ calendar_ dateFromComponents: date_components_ ];
   };

   return [ self fieldWithId: PFFieldExpYear
                        name: name_
                 transformer: expiration_date_transformer_ ];
}

@end
