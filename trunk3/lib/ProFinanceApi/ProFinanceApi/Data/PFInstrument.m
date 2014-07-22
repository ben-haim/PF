#import "PFInstrument.h"
#import "PFAssetType.h"

#import "PFSymbol.h"
#import "PFMetaObject.h"
#import "PFField.h"
#import "PFMessage.h"
#import "NSDateFormatter+PFMessage.h"
#import "PFMarginCoefficient.h"

static int server_time_offset_ = 0;

@interface PFInstrument ()

@property ( nonatomic, weak ) id< PFInstrumentGroup > group;
@property ( nonatomic, strong ) NSArray* routeNames;
@property ( nonatomic, strong ) NSMutableArray* mutableMarginCoefficient;

@end

@implementation PFInstrument

@synthesize type;
@synthesize instrumentId;
@synthesize baseInstrumentId;
@synthesize groupId;

@synthesize name = _name;
@synthesize overview = _overview;
@synthesize routes = _routes;
@synthesize tradeRouteNames;
@synthesize infoRouteNames;
@synthesize routeNames = _routeNames;
@synthesize expirationDates;
@synthesize lastTradeDates;
@synthesize settlementDates;
@synthesize noticeDates;
@synthesize firstTradeDates;
@synthesize autoCloseDates;
@synthesize deliveryStatuses;
@synthesize isContiniousContracts;
@synthesize tradeModes;
@synthesize priceLowLimits;
@synthesize priceHighLimits;
@synthesize priceLimitMeasures;

@synthesize tickCoast;
@synthesize pointSize;
@synthesize lotSize;
@synthesize contractSize;

@synthesize deliveryMethodId;

@synthesize lotStep;
@synthesize minimalLot;

@synthesize precision;
@synthesize marginMode;
@synthesize barType;

@synthesize marginType;
@synthesize tradeSessionContainerId;
@synthesize expirationTemplate;
@synthesize tradingBalance;
@synthesize tradeMode;
@synthesize exp1;
@synthesize exp2;
@synthesize swapBuy;
@synthesize swapSell;

@synthesize assetExp1;
@synthesize assetExp2;

@synthesize highLimitPrice;
@synthesize lowLimitPrice;
@synthesize limitMeasure;

@synthesize group;

@synthesize symbols = _symbols;

@synthesize useSameCrossPriceforCloseOpen;

@synthesize useLongShortMargin;
@synthesize useOvernightMargin;
@synthesize mutableMarginCoefficient = _mutableMarginCoefficient;

-(NSMutableArray*)mutableMarginCoefficient
{
    if (!_mutableMarginCoefficient)
        _mutableMarginCoefficient = [NSMutableArray new];

    return _mutableMarginCoefficient;
}

-(NSArray*)marginCoefficients
{
    return self.mutableMarginCoefficient;
}

+(void)setServerTimeOffset:( int )server_offset_
{
   server_time_offset_ = server_offset_;
}

+(PFMetaObject*)metaObject
{
   return [ PFMetaObject metaObjectWithFields:
           [ NSArray arrayWithObjects: [ PFMetaObjectField fieldWithId: PFFieldType name: @"type" ]
            , [ PFMetaObjectField fieldWithId: PFFieldInstrumentId name: @"instrumentId" ]
            , [ PFMetaObjectField fieldWithId: PFFieldInstrumentTypeId name: @"groupId" ]
            , [ PFMetaObjectField fieldWithId: PFFieldName name: @"name" ]
            , [ PFMetaObjectField fieldWithId: PFFieldDescription name: @"overview" ]
            , [ PFMetaObjectField fieldWithId: PFFieldRouteList name: @"infoRouteNames" ]
            , [ PFMetaObjectField fieldWithId: PFFieldTradeRouteList name: @"tradeRouteNames" ]
            , [ PFMetaObjectField fieldWithId: PFFieldPointSize name: @"pointSize" ]
            , [ PFMetaObjectField fieldWithId: PFFieldLotSize name: @"lotSize" ]
            , [ PFMetaObjectField fieldWithId: PFFieldContractSize name: @"contractSize" ]
            , [ PFMetaObjectField fieldWithId: PFFieldLotStep name: @"lotStep" ]
            , [ PFMetaObjectField fieldWithId: PFFieldMinimalLot name: @"minimalLot" ]
            , [ PFMetaObjectField fieldWithId: PFFieldPrecision name: @"precision" ]
            , [ PFMetaObjectField fieldWithId: PFFieldBarsType name: @"barType" ]
            , [ PFMetaObjectField fieldWithId: PFFieldMarginType name: @"marginType" ]
            , [ PFMetaObjectField fieldWithId: PFFieldBaseInstrumentID name: @"baseInstrumentId" ]
            , [ PFMetaObjectField fieldWithId: PFFieldTickCost name: @"tickCoast" ]
            , [ PFMetaObjectField fieldWithId: PFFieldValuedDateBasis name: @"tradingBalance" ]
            , [ PFMetaObjectField fieldWithId: PFFieldTradeMode name: @"tradeMode" ]
            , [ PFMetaObjectField fieldWithId: PFFieldNameExp1 name: @"exp1" ]
            , [ PFMetaObjectField fieldWithId: PFFieldNameExp2 name: @"exp2" ]
            , [ PFMetaObjectField fieldWithId: PFFieldSwapBuy name: @"swapBuy" ]
            , [ PFMetaObjectField fieldWithId: PFFieldSwapSell name: @"swapSell" ]
            , [ PFMetaObjectField fieldWithId: PFFieldMarginMode name: @"marginMode" ]
            , [ PFMetaObjectField fieldWithId: PFFieldTradeSessionId name: @"tradeSessionContainerId" ]
            , [ PFMetaObjectField fieldWithId: PFFieldPriceHighLimit name: @"highLimitPrice" ]
            , [ PFMetaObjectField fieldWithId: PFFieldPriceLowLimit name: @"lowLimitPrice" ]
            , [ PFMetaObjectField fieldWithId: PFFieldPriceLimitMesure name: @"limitMeasure" ]
            , [ PFMetaObjectField fieldWithId: PFFieldDerivativeExpirationTemplate name: @"expirationTemplate" ]
            , [ PFMetaObjectField fieldWithId: PFFieldDeliveryMethodId name: @"deliveryMethodId" ]
            , [ PFMetaObjectField fieldWithId: PFFieldUseOvernightMargin name: @"useOvernightMargin" ]
            , [ PFMetaObjectField fieldWithId: PFFieldUseLongShortMargin name: @"useLongShortMargin" ]
            , nil ] ];
}

-(void)didUpdateWithFieldOwner:( PFFieldOwner* )field_owner_
{
    NSArray* margin_coefficients_ = [ field_owner_ groupFieldsWithId: PFGroupMarginCoefficient ];
    for (PFGroupField* margin_coefficient_ in margin_coefficients_)
    {
        [ self.mutableMarginCoefficient addObject: [PFMarginCoefficient objectWithFieldOwner: margin_coefficient_.fieldOwner ] ];
    }

    PFBoolField* use_same_cross_price_for_close_open_ = [ field_owner_ fieldWithId: PFFieldUseSameCrosspriceForOpenClose ];
    self.useSameCrossPriceforCloseOpen = use_same_cross_price_for_close_open_ ? [ use_same_cross_price_for_close_open_ boolValue ] : YES;
    
    if ( self.highLimitPrice == 0.0 && self.lowLimitPrice == 0.0 && self.expirationTemplate == 0 )
    {
        self.limitMeasure = PFLimitMeasureNone;
    }
    
    NSArray* expirations_array_ = [ field_owner_ groupFieldsWithId: PFGroupExpiration ];
    
    if ( expirations_array_.count > 0 )
    {
        NSMutableArray* dates_ = [ NSMutableArray arrayWithCapacity: [ expirations_array_ count ] ];
        NSMutableArray* last_dates_ = [ NSMutableArray arrayWithCapacity: [ expirations_array_ count ] ];
        NSMutableArray* settlement_dates_ = [ NSMutableArray arrayWithCapacity: [ expirations_array_ count ] ];
        NSMutableArray* notice_dates_ = [ NSMutableArray arrayWithCapacity: [ expirations_array_ count ] ];
        NSMutableArray* first_trade_dates_ = [ NSMutableArray arrayWithCapacity: [ expirations_array_ count ] ];
        NSMutableArray* auto_close_dates_ = [ NSMutableArray arrayWithCapacity: [ expirations_array_ count ] ];
        NSMutableArray* delivery_statuses_ = [ NSMutableArray arrayWithCapacity: [ expirations_array_ count ] ];
        NSMutableArray* is_continious_contracts_ = [ NSMutableArray arrayWithCapacity: [ expirations_array_ count ] ];
        NSMutableArray* trade_modes_ = [ NSMutableArray arrayWithCapacity: [ expirations_array_ count ] ];
        NSMutableArray* price_low_limits_ = [ NSMutableArray arrayWithCapacity: [ expirations_array_ count ] ];
        NSMutableArray* price_high_limits_ = [ NSMutableArray arrayWithCapacity: [ expirations_array_ count ] ];
        NSMutableArray* price_limit_measures_ = [ NSMutableArray arrayWithCapacity: [ expirations_array_ count ] ];
        
        for ( PFGroupField* expiration_group_ in expirations_array_ )
        {
            [ dates_ addObject: [ [ [ expiration_group_ fieldWithId: PFFieldContractMonthDate ] dateValue ] dateByAddingTimeInterval: server_time_offset_ * 60 * 60 ] ];
            [ last_dates_ addObject: [ [ [ expiration_group_ fieldWithId: PFFieldLastTradeDate ] dateValue ] dateByAddingTimeInterval: server_time_offset_ * 60 * 60 ] ];
            [ settlement_dates_ addObject: [ [ [ expiration_group_ fieldWithId: PFFieldSettlementDate ] dateValue ] dateByAddingTimeInterval: server_time_offset_ * 60 * 60 ] ];
            [ notice_dates_ addObject: [ [ [ expiration_group_ fieldWithId: PFFieldNoticeDate ] dateValue ] dateByAddingTimeInterval: server_time_offset_ * 60 * 60 ] ];
            [ first_trade_dates_ addObject: [ [ [ expiration_group_ fieldWithId: PFFieldFirstTradeDate ] dateValue ] dateByAddingTimeInterval: server_time_offset_ * 60 * 60 ] ];
            [ auto_close_dates_ addObject: [ [ [ expiration_group_ fieldWithId: PFFieldAutoCloseDate ] dateValue ] dateByAddingTimeInterval: server_time_offset_ * 60 * 60 ] ];
            [ delivery_statuses_ addObject: @([ (PFIntegerField*)[ expiration_group_ fieldWithId: PFFieldDeliveryStatus ] integerValue ] ) ];
            [ is_continious_contracts_ addObject: @( [ [ expiration_group_ fieldWithId: PFFieldIsContiniousContract ] boolValue ] ) ];
            [ trade_modes_ addObject: @( [ [ expiration_group_ fieldWithId: PFFieldTradeMode ] byteValue ] ) ];
            [ price_low_limits_ addObject: @( [ [ expiration_group_ fieldWithId: PFFieldPriceLowLimit ] doubleValue ] ) ];
            [ price_high_limits_ addObject: @( [ [ expiration_group_ fieldWithId: PFFieldPriceHighLimit ] doubleValue ] ) ];
            [ price_limit_measures_ addObject: @( [ [ expiration_group_ fieldWithId: PFFieldPriceLimitMesure ] byteValue ] ) ];
        }
        
        self.expirationDates = dates_;
        self.lastTradeDates = last_dates_;
        self.settlementDates = settlement_dates_;
        self.noticeDates = notice_dates_;
        self.firstTradeDates = first_trade_dates_;
        self.autoCloseDates = auto_close_dates_;
        self.deliveryStatuses = delivery_statuses_;
        self.isContiniousContracts = is_continious_contracts_;
        self.tradeModes = trade_modes_;
        self.priceLowLimits = price_low_limits_;
        self.priceHighLimits = price_high_limits_;
        self.priceLimitMeasures = price_limit_measures_;
    }
}

-(void)dealloc
{
   for ( PFSymbol* symbol_ in _symbols )
   {
      [ symbol_ disconnectFromInstrument ];
   }
}

-(NSArray*)routeNames
{
   if ( !_routeNames )
   {
      NSMutableSet* routes_set_ = [ NSMutableSet setWithArray: self.tradeRouteNames ];
      [ routes_set_ addObjectsFromArray: self.infoRouteNames ];
      _routeNames = [ routes_set_ allObjects ];
   }
   
   return _routeNames;
}

-(PFBool)isDerivative
{
    return self.isOption || self.isForward || self.isFutures;
}

-(PFBool)isForward
{
    return self.type == PFInstrumentForward;
}

-(PFBool)isForex
{
   return self.type == PFInstrumentForex;
}

-(PFBool)isFutures
{
   return self.type == PFInstrumentFutures || self.type == PFInstrumentCFDFutures;
}

-(PFBool)isOption
{
   return self.type == PFInstrumentOptions;
}

-(PFDouble)pipsSize
{
   if ( self.isForex )
   {
      NSInteger power_ = round( log10( self.pointSize ) );
      if ( power_ % 2 != 0 )
      {
         return self.pointSize * 10.0;
      }
   }

   return self.pointSize;
}

-(void)connectToGroup:( id< PFInstrumentGroup > )group_
{
   self.group = group_;
}

-(void)disconnectFromGroup
{
   self.group = nil;
}

-(NSArray*)symbols
{
   if ( [ self.routeNames count ] == 0 )
      return nil;

   if ( !_symbols )
   {
      NSMutableArray* symbols_ = [ NSMutableArray arrayWithCapacity: [ self.routes count ] ];
      for ( PFRoute* route_ in self.routes )
      {
         [ symbols_ addObjectsFromArray: [ NSArray symbolsArrayWithInstrument: self
                                                                        route: route_ ] ];
      }

      _symbols = symbols_;
   }

   return _symbols;
}

-(NSArray*)symbolsForRouteId:(PFInteger)route_id_
{
   NSMutableArray* filtered_symbols_ = [ NSMutableArray new ];
   
   for ( PFSymbol* symbol_ in self.symbols )
   {
      if ( symbol_.routeId == route_id_ )
         [ filtered_symbols_ addObject: symbol_ ];
   }
   
   return filtered_symbols_;
}

-(void)setSymbols:( NSArray* )symbols_
{
   for ( PFSymbol* symbol_ in symbols_ )
   {
      [ symbol_ connectToInstrument: self ];
   }

   _symbols = symbols_;
}

-(void)synchronizeWithInstrument:( PFInstrument* )existent_instrument_
{
   self.routes = existent_instrument_.routes;
   [ self connectToGroup: existent_instrument_.group ];
   self.symbols = existent_instrument_.symbols;
   existent_instrument_.symbols = nil;
}

-(PFDouble)profitWithGrossPl:( PFDouble )gross_pl_
{
   switch ( self.marginMode )
   {
      case PFMarginModeUseProfitLoss:
         return gross_pl_;
         
      case PFMarginModeUseProfit:
         return ( gross_pl_ > 0.0 ) ? gross_pl_ : 0.0;
         
      case PFMarginModeUseLoss:
         return ( gross_pl_ < 0.0 ) ? gross_pl_ : 0.0;
         
      default:
         return 0.0;
   }
}

-(PFDouble)lotStepExp1
{
    return assetExp1.minChange;
}

-(PFDouble)lotStepExp2
{
    return assetExp2.minChange;
}

-(NSUInteger)precisionExp1
{
    return [PFInstrument precisionFromLotStep: self.lotStepExp1];
}

-(NSUInteger)precisionExp2
{
    return [PFInstrument precisionFromLotStep: self.lotStepExp2];
}

+(NSUInteger)precisionFromLotStep: (double)lot_step_
{
    int precision_ = 1;
    
    if ( lot_step_ != 0.0 )
    {
        int symbol_precision_ = -log10( lot_step_ );
        
        if ( symbol_precision_ > 1)
        {
            precision_ = symbol_precision_;
        }
    }
    return precision_;
}

@end
