#import "PFSymbolInfoGroup.h"

#import "NSDate+Timestamp.h"
#import "NSString+DoubleFormatter.h"
#import "PFSymbolInfoRow.h"
#import "NSDateFormatter+PFTrader.h"

#import "PFInstrumentTypeConversion.h"

#import <ProFinanceApi/ProFinanceApi.h>

static NSString* nameForTradeMode( Byte trade_mode_ )
{
   return  trade_mode_ == PFTradeModeTradingAllowed ?
   NSLocalizedString( @"INSTRUMENT_ACTIVE", nil ) :
   ( trade_mode_ == PFTradeModeNotAllowed ? NSLocalizedString( @"INSTRUMENT_CLOSED", nil ) : NSLocalizedString( @"INSTRUMENT_HALT", nil ) );
}

static NSString* nameForDeliveryStatus( int delivery_status_ )
{
   switch ( delivery_status_ )
   {
      case PFDeliveryStatusWaitForPrice:
         return NSLocalizedString( @"INSTRUMENT_WAIT_FOR_PRICE", nil );
      case PFDeliveryStatusDelivered:
         return NSLocalizedString( @"INSTRUMENT_DELIVERED", nil );
         
      default:
         return NSLocalizedString( @"INSTRUMENT_READY", nil );
   }
}

static NSString* nameForDeliveryMethod( PFDeliveryMethod delivery_ )
{
   if (delivery_ == PFDeliveryMethodCash)      return NSLocalizedString(@"SYMBOL_INFO_CASH", nil);
   if (delivery_ == PFDeliveryMethodPhysicaly) return NSLocalizedString(@"SYMBOL_INFO_PHYSICALLY", nil);
   return @"";
}

static NSString* nameForTradingBalance( int trading_balance_ )
{
   NSString* balance_code_ = [ NSString stringWithFormat: trading_balance_ > 0 ? @"T + %d" : @"T - %d", trading_balance_ ];
   
   switch ( trading_balance_ )
   {
      case -2:
         return @"Immediate";
      case -1:
      case 0:
         return @"T + 0 (TOD)";
      case 1:
         return [ balance_code_ stringByAppendingString: @" (TOM)" ];
      case 2:
         return [ balance_code_ stringByAppendingString: @" (SPOT)" ];
      case 3:
         return [ balance_code_ stringByAppendingString: @" (SPOT+1)" ];
         
      default:
         return balance_code_;
   }
}

@interface PFSymbolInfoGroup ()

@property ( nonatomic, unsafe_unretained ) id < PFSymbol > symbol;
@property ( nonatomic, strong ) NSArray* infoRows;
@property ( nonatomic, assign ) PFSymbolInfoGroupType groupType;

@end

@implementation PFSymbolInfoGroup

@synthesize symbol;
@synthesize groupType;
@synthesize infoRows;

-(NSArray*)generalInfoRows
{
   NSMutableArray* general_rows_array_ = [ NSMutableArray arrayWithCapacity: 5 ];
   
   [ general_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_SYMBOL", nil )
                                                             andValue: self.symbol.name ] ];
   
   [ general_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_DESCRIPTION", nil )
                                                             andValue: self.symbol.instrument.overview ] ];
   
   if ( self.symbol.isFutures )
   {
      [ general_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_FUTURES_CLASS", nil )
                                                                andValue: self.symbol.instrument.name ] ];
   }
   
   [ general_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_EXANGE", nil )
                                                             andValue: self.symbol.routeName ] ];
   
   [ general_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_ASSET_CLASS", nil )
                                                             andValue: NSStringForAssetClass( self.symbol.instrument.type ) ] ];
   
   if ( self.symbol.isFutures )
   {
      [ general_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_CLOSE_OUT_DATE", nil )
                                                                andValue: [ self.symbol.autoCloseDate shortDateString ] ] ];
      
      switch ( self.symbol.instrument.expirationTemplate )
      {
         case PFExpirationTemplateContract:
            [ general_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_CONTRACT_MONTH", nil )
                                                                      andValue: [ self.symbol.contractMonthDate shortDateString ] ] ];
            break;
            
         case PFExpirationTemplateContractLastTradeSettlementFirstTrade:
            [ general_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_CONTRACT_MONTH", nil )
                                                                      andValue: [ self.symbol.contractMonthDate shortDateString ] ] ];
            [ general_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_LAST_TRADE_DATE", nil )
                                                                      andValue: [ self.symbol.lastTradeDate shortDateString ] ] ];
            [ general_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_SETTLEMENT_DATE", nil )
                                                                      andValue: [ self.symbol.settlementDate shortDateString ] ] ];
            [ general_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_NOTICE_DATE", nil )
                                                                      andValue: [ self.symbol.noticeDate shortDateString ] ] ];
            [ general_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_FIRST_TRADE_DATE", nil )
                                                                      andValue: [ self.symbol.firstTradeDate shortDateString ] ] ];
            break;
            
         case PFExpirationTemplateContractLastTradeSettlement:
            [ general_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_CONTRACT_MONTH", nil )
                                                                      andValue: [ self.symbol.contractMonthDate shortDateString ] ] ];
            [ general_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_LAST_TRADE_DATE", nil )
                                                                      andValue: [ self.symbol.lastTradeDate shortDateString ] ] ];
            [ general_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_SETTLEMENT_DATE", nil )
                                                                      andValue: [ self.symbol.settlementDate shortDateString ] ] ];
            [ general_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_NOTICE_DATE", nil )
                                                                      andValue: [ self.symbol.noticeDate shortDateString ] ] ];
            break;
            
         case PFExpirationTemplateContractLastTrade:
            [ general_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_CONTRACT_MONTH", nil )
                                                                      andValue: [ self.symbol.contractMonthDate shortDateString ] ] ];
            [ general_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_LAST_TRADE_DATE", nil )
                                                                      andValue: [ self.symbol.lastTradeDate shortDateString ] ] ];
            break;
      }
   }   

   [ general_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_DELIVERY_METHOD", nil )
                                                             andValue: nameForDeliveryMethod(self.symbol.instrument.deliveryMethodId) ] ];
   
   [ general_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_TRADING_BALANCE", nil )
                                                             andValue: nameForTradingBalance( self.symbol.instrument.tradingBalance ) ] ];
   
   return general_rows_array_;
}

-(NSArray*)tradingInfoRows
{
   NSMutableArray* trading_rows_array_ = [ NSMutableArray arrayWithCapacity: 8 ];
   
   [ trading_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_TRADING_ALLOWED", nil )
                                                             andValue: nameForTradeMode( self.symbol.tradeMode ) ] ];
   
   if ( self.symbol.isFutures )
   {
      [ trading_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_DELIVERY_STATUS", nil )
                                                                andValue: ( [ self.symbol.lastTradeDate compare: [ NSDate date ] ] == NSOrderedAscending ) ?
                                        nameForDeliveryStatus(self.symbol.deliveryStatus) :
                                        @"---" ] ];
   }

   id< PFTradeSessionContainer > trade_session_container_ = [ [ PFSession sharedSession ] tradeSessionContainerForInstrument: self.symbol.instrument ];
   if (trade_session_container_)
   {
      id< PFTradeSession > current_trade_session_ = trade_session_container_.currentTradeSession;
      PFHolidays* currrent_Holiday_ = trade_session_container_.currentHolliday;
      NSString* session_info_ = nil;
      
      if (currrent_Holiday_)
      {
         if (currrent_Holiday_.dayType == PFHolidaysDayTypeNotWorking)
         {
            session_info_ = NSLocalizedString( @"SYMBOL_INFO_CURRENT_SESSION_NOT_TRDING_DAY", nil );
         }
         else if (currrent_Holiday_.dayType == PFHolidaysDayTypeShorted)
         {
            if (current_trade_session_)
               session_info_ = [NSString stringWithFormat: @"%@ (%@)",
                                current_trade_session_.name,
                                NSLocalizedString( @"SYMBOL_INFO_CURRENT_SESSION_SHORTENED", nil ) ];
         }
         else if (currrent_Holiday_.dayType == PFHolidaysDayTypeWorking)
         {
            if (current_trade_session_)
               session_info_ = current_trade_session_.name;
         }
      }
      else
      {
         if (current_trade_session_)
            session_info_ = current_trade_session_.name;
      }
      
      if (!session_info_)
         session_info_ = NSLocalizedString( @"SYMBOL_INFO_NOT_DEFINED", nil );
      
      [ trading_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_CURRENT_SESSION", nil )
                                                                andValue: session_info_ ] ];
      
      NSDate* next_holiday_ = [trade_session_container_ nextDateHolliday];
      
      if (next_holiday_)
      {
         [ trading_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_NEXT_HOLIDAY", nil )
                                                                   andValue: [NSString stringWithFormat: @"%@ (%@)",
                                                                              [ [ NSDateFormatter pickerDateOnlyFormatter] stringFromDate: next_holiday_],
                                                                                 [ trade_session_container_ currentHollidayFromDate: next_holiday_ ].name ] ] ];
      }
   }
   
   [ trading_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_EXP", nil )
                                                             andValue: self.symbol.instrument.exp2 ] ];
   
   if ( self.symbol.isFutures )
   {
      [ trading_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_CONTRACT_SIZE", nil )
                                                                andValue: [ NSString stringWithAmount: self.symbol.instrument.contractSize ] ] ];
      
      double tick_coast_ = self.symbol.tickCoast < 0.0 ? self.symbol.lotSize * self.symbol.instrument.pointSize : self.symbol.tickCoast;
      
      [ trading_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_TICK_COAST", nil )
                                                                andValue: [ NSString stringWithAmount: tick_coast_ ] ] ];
   }
   else
   {
      [ trading_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_LOT_SIZE", nil )
                                                                andValue: [ NSString stringWithFormat: @"%lld %@"
                                                                           , self.symbol.lotSize
                                                                           , self.symbol.isForex ? self.symbol.instrument.exp1 : @"" ] ] ];
      
      [ trading_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_TICK_COAST", nil )
                                                                andValue: [ NSString stringWithAmount: self.symbol.lotSize * self.symbol.instrument.pointSize ] ] ];
   }
   
   [ trading_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_TICK_SIZE", nil )
                                                             andValue: [ NSString stringWithAmount: self.symbol.instrument.pointSize ] ] ];
   
   [ trading_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_MINIMAL_LOT", nil )
                                                             andValue: [ NSString stringWithAmount: self.symbol.instrument.minimalLot ] ] ];
   
   [ trading_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_LOT_STEP", nil )
                                                             andValue: [ NSString stringWithAmount: self.symbol.instrument.lotStep ] ] ];
   
   [ trading_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_HIGH_LIMIT", nil )
                                                             andValue: self.symbol.highLimit > 0.0 ? [ NSString stringWithPrice: self.symbol.highLimit symbol: self.symbol ] : @"-" ] ];
   
   [ trading_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_LOW_LIMIT", nil )
                                                             andValue: self.symbol.lowLimit > 0.0 ? [ NSString stringWithPrice: self.symbol.lowLimit symbol: self.symbol ] : @"-" ] ];
   
   return trading_rows_array_;
}

-(NSArray*)marginInfoRows
{
   //! Not all servers ready
   return nil;
}

-(NSString*)commissionNameByType: (int)type_
{
   if (type_ == PFCommissionTypePerLot)
   {
      return NSLocalizedString(@"SYMBOL_INFO_FEES_PER_LOT", nil);
   }
   else if (type_ == PFCommissionTypePerFill)
   {
      return NSLocalizedString(@"SYMBOL_INFO_FEES_PER_FILL", nil);
   }
   else if (type_ == PFCommissionTypePertransaction)
   {
      return NSLocalizedString(@"SYMBOL_INFO_FEES_PER_TRANSACTION", nil);
   }
   else if (type_ == PFCommissionTypePerphonetransaction)
   {
      return NSLocalizedString(@"SYMBOL_INFO_FEES_PER_PHONE_TRANSACTION", nil);
   }
   else if (type_ == PFCommissionTypeVat)
   {
      return NSLocalizedString(@"SYMBOL_INFO_FEES_VAT", nil);
   }
   else if (type_ == PFCommissionTypePercent)
   {
      return NSLocalizedString(@"SYMBOL_INFO_FEES_VOLUME", nil);
   }
   else return @"";
}

-(void)addFeesIntervalsByOperationType: (PFOperationType) operation_type_
                   withCommissionGroup: (PFCommissionGroup*) commission_group_
                        assetMinChange: (NSUInteger) asset_min_change_
                                    to: (NSMutableArray*) fees_rows_array_;
{
   for (PFCommissionInterval* interval_ in commission_group_.intervals)
   {
      NSString* to_ = (interval_.to == -1) ? @"∞" : [NSString stringWithFormat: @"%d", interval_.to];
      NSString* name_ = [NSString stringWithFormat: @"    %@(%d - %@)",
                         NSLocalizedString(@"SYMBOL_INFO_FEES_LOTS", nil), interval_.from, to_];
      double price_ = 0;
      
      if (operation_type_ == PFOperationTypeAll)
      {
         price_ = interval_.allPrice;
      }
      else if (operation_type_==PFOperationTypeShort)
      {
         price_ = interval_.shortPrice + interval_.allPrice;
      }
      else if (operation_type_ == PFOperationTypeBySell)
      {
         price_ = interval_.buySellPrice + interval_.allPrice;
      }
      
      [ fees_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: name_
                                                             andValue: (commission_group_.paymentType == PFCommissionPaymentTypeVolumePercent) ?
                                                               [ NSString stringWithPercent: price_ showPercentSign: YES ] :
                                                               [ NSString stringWithFormat: @"%@ %@", [ NSString stringWithAmount: price_ minChange: asset_min_change_ ],
                                                                  commission_group_.currency ] ] ];
   }
}

-(NSArray*)feesInfoRows
{
   NSMutableArray* fees_rows_array_ = [ NSMutableArray new ];
   NSArray* commission_levels_ = [ [ PFSession sharedSession ] currentCommissionLevelForInstrument: self.symbol.instrument ];
   
   for ( PFCommissionGroup* commission_group_ in commission_levels_ )
   {
      NSUInteger asset_min_change_ = [ [ PFSession sharedSession ] assetTypeForCurrency: commission_group_.currency ].minChange;
      NSString* name_ = [ self commissionNameByType: commission_group_.type ];
      
      if ( commission_group_.hasBuySellShort )
      {
         NSString* buy_name_ = [ NSString stringWithFormat: @"%@ %@", name_, NSLocalizedString(@"SYMBOL_INFO_FEES_BUY_SELL", nil) ];
         NSString* short_name_ = [ NSString stringWithFormat: @"%@ %@", name_, NSLocalizedString(@"SYMBOL_INFO_FEES_SHORT", nil) ];
         
         if ([commission_group_.intervals count] == 1)
         {
            PFCommissionInterval* firstInterval = (commission_group_.intervals)[0];
            double short_price_ = firstInterval.shortPrice + firstInterval.allPrice;
            double buy_sell_price_ = firstInterval.buySellPrice + firstInterval.allPrice;
            
            NSString* buy_sell_value_ = (commission_group_.paymentType == PFCommissionPaymentTypeVolumePercent) ?
               [ NSString stringWithPercent: buy_sell_price_ showPercentSign: YES ] :
               [ NSString stringWithFormat: @"%@ %@", [ NSString stringWithAmount: buy_sell_price_ minChange: asset_min_change_ ], commission_group_.currency ];
            
            [ fees_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: buy_name_
                                                                   andValue: buy_sell_value_ ] ];
            
            NSString* short_value_ = (commission_group_.paymentType == PFCommissionPaymentTypeVolumePercent) ?
            [ NSString stringWithPercent: short_price_ showPercentSign: YES ] :
            [ NSString stringWithFormat: @"%@ %@", [ NSString stringWithAmount: short_price_ minChange: asset_min_change_ ], commission_group_.currency ];
            
            [ fees_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: short_name_
                                                                   andValue: short_value_ ] ];
         }
         else
         {
            [ fees_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: buy_name_
                                                                   andValue: @"" ] ];
            
            [self addFeesIntervalsByOperationType: PFOperationTypeBySell
                              withCommissionGroup: commission_group_
                                   assetMinChange: asset_min_change_
                                               to: fees_rows_array_];
            
            [ fees_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: short_name_
                                                                   andValue: @"" ] ];
            
            [self addFeesIntervalsByOperationType: PFOperationTypeShort
                              withCommissionGroup: commission_group_
                                   assetMinChange: asset_min_change_
                                               to: fees_rows_array_];
         }
      }
      else
      {
         if ([commission_group_.intervals count] == 1)
         {
            PFCommissionInterval* firstInterval = (commission_group_.intervals)[0];
            
            NSString* value = (commission_group_.paymentType == PFCommissionPaymentTypeVolumePercent) ?
               [ NSString stringWithPercent: firstInterval.allPrice showPercentSign: YES ] :
               [ NSString stringWithFormat: @"%@ %@", [ NSString stringWithAmount: firstInterval.allPrice minChange: asset_min_change_ ], commission_group_.currency ];
            
            [ fees_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: name_
                                                                   andValue: value ] ];
         }
         else
         {
            [ fees_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: name_
                                                                   andValue: @"" ] ];
            
            [self addFeesIntervalsByOperationType: PFOperationTypeBySell
                              withCommissionGroup: commission_group_
                                   assetMinChange: asset_min_change_
                                               to: fees_rows_array_];
         }
      }
   }
   
   return fees_rows_array_;
}

-(NSArray*)sessionInfoRows
{
   id< PFTradeSessionContainer > trade_session_container_ = [ [ PFSession sharedSession ] tradeSessionContainerForInstrument: self.symbol.instrument ];
   
   if ( trade_session_container_ )
   {
      NSMutableArray* session_rows_ = [ NSMutableArray new ];
      PFHolidays* current_Holiday_ = trade_session_container_.currentHolliday;
      
      if (current_Holiday_)
         if (current_Holiday_.dayType == PFHolidaysDayTypeNotWorking)
         {
            [ session_rows_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_CURRENT_SESSION_NOT_TRDING_DAY", nil )
                                                                andValue: [ NSString stringWithFormat: @" (%@)", current_Holiday_.name ] ] ];
            return session_rows_;
         }
      
      for ( id< PFTradeSession > trade_session_ in trade_session_container_.tradeSessions )
      {
         id< PFTradeSessionDay > currentTradeDay_ =
            [trade_session_ currentTradeDayWithTypeDay: (current_Holiday_ ? current_Holiday_.dayType == PFHolidaysDayTypeShorted : NO)];
         
         [ session_rows_ addObject: [ PFSymbolInfoRow infoRowWithName: trade_session_.name
                                                             andValue: [ NSString stringWithFormat: @"%@ - %@"
                                                                        , [ currentTradeDay_.localBeginTime shortTimeString ]
                                                                        , [ currentTradeDay_.localEndTime shortTimeString ] ] ] ];
      }
      return session_rows_;
   }
   else
   {
      return nil;
   }
}

-(void)fillInfoRows
{
   switch ( self.groupType )
   {
      case PFSymbolInfoGroupTypeTrading:
         self.infoRows = [ self tradingInfoRows ];
         break;
         
      case PFSymbolInfoGroupTypeMargin:
         self.infoRows = [ self marginInfoRows ];
         break;
         
      case PFSymbolInfoGroupTypeFees:
         self.infoRows = [ self feesInfoRows ];
         break;
         
      case PFSymbolInfoGroupTypeSession:
         self.infoRows = [ self sessionInfoRows ];
         break;
         
      default:
         self.infoRows = [ self generalInfoRows ];
         break;
   }
}

+(id)groupWithType:( PFSymbolInfoGroupType )info_type_ andSymbol:( id< PFSymbol > )symbol_
{
   PFSymbolInfoGroup* symbol_info_group_ = [ [ PFSymbolInfoGroup alloc ] init ];
   symbol_info_group_.groupType = info_type_;
   symbol_info_group_.symbol = symbol_;
   
   [ symbol_info_group_ fillInfoRows ];
   
   return symbol_info_group_;
}

+(NSArray*)groupsForSymbol:( id< PFSymbol > )symbol_
{
   NSMutableArray* symbol_info_groups_ = [ NSMutableArray arrayWithCapacity: 5 ];
   
   PFSymbolInfoGroup* general_group_ = [ PFSymbolInfoGroup groupWithType: PFSymbolInfoGroupTypeGeneral andSymbol: symbol_ ];
   if ( general_group_.infoRows.count > 0 )
      [ symbol_info_groups_ addObject: general_group_ ];
   
   PFSymbolInfoGroup* trading_group_ = [ PFSymbolInfoGroup groupWithType: PFSymbolInfoGroupTypeTrading andSymbol: symbol_ ];
   if ( trading_group_.infoRows.count > 0 )
      [ symbol_info_groups_ addObject: trading_group_ ];
   
   PFSymbolInfoGroup* margin_group_ = [ PFSymbolInfoGroup groupWithType: PFSymbolInfoGroupTypeMargin andSymbol: symbol_ ];
   if ( margin_group_.infoRows.count > 0 )
      [ symbol_info_groups_ addObject: margin_group_ ];
   
   PFSymbolInfoGroup* fees_group_ = [ PFSymbolInfoGroup groupWithType: PFSymbolInfoGroupTypeFees andSymbol: symbol_ ];
   if ( fees_group_.infoRows.count > 0 )
      [ symbol_info_groups_ addObject: fees_group_ ];
   
   PFSymbolInfoGroup* session_group_ = [ PFSymbolInfoGroup groupWithType: PFSymbolInfoGroupTypeSession andSymbol: symbol_ ];
   if ( session_group_.infoRows.count > 0 )
      [ symbol_info_groups_ addObject: session_group_ ];
   
   return symbol_info_groups_;
}

@end
