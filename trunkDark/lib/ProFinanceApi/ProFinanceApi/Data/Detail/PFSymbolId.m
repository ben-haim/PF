#import "PFSymbolId.h"

#import "PFSymbolConnection.h"
#import "PFSymbolOptionType.h"

#import "PFMessage.h"
#import "PFField.h"

#import "PFMetaObject.h"

#import "PFSymbol.h"

@interface PFSymbolId ()

@property ( nonatomic, strong ) NSDate* expirationDate;

@end

@implementation PFSymbolId

@synthesize instrumentId;
@synthesize routeId;
@synthesize optionType;
@synthesize expYear;
@synthesize expMonth;
@synthesize expDay;
@synthesize strikePrice;
@synthesize isGeneralOptionKey;
@synthesize expirationDate = _expirationDate;

+(PFMetaObject*)metaObject
{
   PFMetaObjectFieldFilter filter_exp_date_ = ^BOOL( id self_ )
   {
      return [ self_ expYear ] >= PFExpYearIgnore;
   };

   PFMetaObjectFieldTransformer year_transformer_ = ^id(id object_, PFFieldOwner* field_owner_, id value_)
   {
      return [ value_ shortValue ] >= PFExpYearIgnore ? value_ : nil;
   };

   return [ PFMetaObject metaObjectWithFields:
           [ NSArray arrayWithObjects: [ PFMetaObjectField fieldWithId: PFFieldInstrumentId name: @"instrumentId" ]
            , [ PFMetaObjectField fieldWithId: PFFieldRouteId name: @"routeId" ]
            , [ PFMetaObjectField fieldWithId: PFFieldOptionType name: @"optionType" ]
            , [ PFMetaObjectField fieldWithId: PFFieldStrikePrice name: @"strikePrice" ]
            , [ PFMetaObjectField fieldWithId: PFFieldExpYear
                                         name: @"expYear"
                                       filter: filter_exp_date_
                                  transformer: year_transformer_ ]
            , [ PFMetaObjectField fieldWithId: PFFieldExpMonth
                                         name: @"expMonth"
                                       filter: filter_exp_date_ ]
            , [ PFMetaObjectField fieldWithId: PFFieldExpDay
                                         name: @"expDay"
                                       filter: filter_exp_date_ ]
            , nil ] ];
}

-(id)init
{
   self = [ super init ];
   if ( self )
   {
      self.optionType = PFSymbolOptionTypeUndefined;
      self.isGeneralOptionKey = NO;
   }
   return self;
}

-(id)initWithInstrumentId:( PFInteger )instrument_id_
                  routeId:( PFInteger )route_id_
               optionType:( PFByte )option_type_
                  expYear:( PFShort )year_
                 expMonth:( PFByte )month_
                   expDay:( PFByte )day_
{
   self = [ super init ];
   if ( self )
   {
      self.instrumentId = instrument_id_;
      self.routeId = route_id_;
      self.optionType = option_type_;
      self.expYear = year_;
      self.expMonth = month_;
      self.expDay = day_;
   }
   return self;
}

-(NSDate*)expirationDate
{
   if ( !_expirationDate )
   {
      NSDateComponents* date_components_ = [ NSDateComponents new ];
      date_components_.day = self.expDay;
      date_components_.month = self.expMonth;
      date_components_.year = self.expYear;
      NSCalendar* calendar_ = [ [ NSCalendar alloc ] initWithCalendarIdentifier: NSGregorianCalendar ];
      _expirationDate = [ calendar_ dateFromComponents: date_components_ ];
   }
   
   return _expirationDate;
}

@end

@implementation PFSymbolIdKey

-(id)initWithCoder:( NSCoder* )coder_
{
   self = [ super init ];
   
   if ( self )
   {
      self.instrumentId = [ coder_ decodeInt32ForKey: @"instrumentId" ];
      self.routeId = [ coder_ decodeInt32ForKey: @"routeId" ];
      self.optionType = [ coder_ decodeIntForKey: @"optionType" ];
      self.expYear = [ coder_ decodeIntForKey: @"expYear" ];
      self.expMonth = [ coder_ decodeIntForKey: @"expMonth" ];
      self.expDay = [ coder_ decodeIntForKey: @"expDay" ];
      self.isGeneralOptionKey = [ coder_ decodeBoolForKey: @"isGeneralOptionKey" ];
   }
   return self;
}

-(void)encodeWithCoder:( NSCoder* )coder_
{
   [ coder_ encodeInt32: self.instrumentId forKey: @"instrumentId" ];
   [ coder_ encodeInt32: self.routeId forKey: @"routeId" ];
   [ coder_ encodeInt: self.optionType forKey: @"optionType" ];
   [ coder_ encodeInt: self.expYear forKey: @"expYear" ];
   [ coder_ encodeInt: self.expMonth forKey: @"expMonth" ];
   [ coder_ encodeInt: self.expDay forKey: @"expDay" ];
   [ coder_ encodeBool: self.isGeneralOptionKey forKey: @"isGeneralOptionKey" ];
}

-(NSUInteger)hash
{
   return self.instrumentId;
}

-(BOOL)isEqual:( id )other_
{
   if ( ![ other_ conformsToProtocol: @protocol(PFSymbolId) ] )
      return NO;

   id< PFSymbolId > other_id_ = ( id< PFSymbolId > )other_;

   if ( other_id_.instrumentId != self.instrumentId || other_id_.routeId != self.routeId || other_id_.isGeneralOptionKey != self.isGeneralOptionKey )
   {
      return NO;
   }

   if ( other_id_.optionType == PFSymbolOptionTypeFutures )
   {
      return other_id_.optionType == self.optionType
      && other_id_.expYear == self.expYear
      && other_id_.expMonth == self.expMonth
      && other_id_.expDay == self.expDay;
   }

   return YES;
}

+(id)keyWithSymbolId:( id< PFSymbolId > )symbol_id_
{
   return [ [ self alloc ] initWithInstrumentId: symbol_id_.instrumentId
                                        routeId: symbol_id_.routeId
                                     optionType: symbol_id_.optionType
                                        expYear: symbol_id_.expYear
                                       expMonth: symbol_id_.expMonth
                                         expDay: symbol_id_.expDay ];
}

+(id)quotesKeyWithSymbol:( id< PFSymbol > )symbol_
{
   return [ [ self alloc ] initWithInstrumentId: symbol_.instrumentId
                                        routeId: symbol_.quoteRouteId
                                     optionType: symbol_.optionType
                                        expYear: symbol_.expYear
                                       expMonth: symbol_.expMonth
                                         expDay: symbol_.expDay ];
}

+(id)generalOptionKeyWithSymbolId:( id< PFSymbolId > )symbol_id_
{
   PFSymbolIdKey* key_ = [ PFSymbolIdKey keyWithSymbolId: symbol_id_ ];
   key_.isGeneralOptionKey = YES;
   
   return key_;
}

@end
