#import "PFSymbolInfoGroup.h"

#import "NSDate+Timestamp.h"
#import "NSString+DoubleFormatter.h"
#import "PFSymbolInfoRow.h"

#import "PFInstrumentTypeConversion.h"

#import <ProFinanceApi/ProFinanceApi.h>

static NSString* nameForTradeMode( Byte trade_mode_ )
{
   return  trade_mode_ == PFTradeModeTradingAllowed || trade_mode_ == PFTradeModeOrdersAndLargeTradesAllowed ?
   NSLocalizedString( @"INSTRUMENT_ACTIVE", nil ) :
   NSLocalizedString( @"INSTRUMENT_CLOSED", nil );
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

static NSString* nameForSessionType( int session_type_ )
{
   switch ( session_type_ )
   {
      case 0:
         return NSLocalizedString( @"TRADING_SESSION_AUCTION", nil );
         
      case 1:
         return NSLocalizedString( @"TRADING_SESSION_MAINTRADE", nil );
         
      case 2:
         return NSLocalizedString( @"TRADING_SESSION_EXTTRADE", nil );
         
      case 3:
         return NSLocalizedString( @"TRADING_SESSION_CLEARING", nil );
         
      default:
         return @"";
   }
}

static NSString* nameForCurrentSession( id< PFSymbol > symbol_ )
{
   if ( [ symbol_.instrument.sessions count ] > 0 )
   {
      NSDate* gmt_now_ = [ NSDate GMTNow ];
      NSDate* gmt_date_ = [ NSDate dateFromDateAndTime: gmt_now_ ];
      
      NSDate* current_session_begin_ = nil;
      NSDate* current_session_end_ = nil;
      
      id< PFTradingSession > current_session_ = nil;
      
      for ( id< PFTradingSession > trading_session_ in symbol_.instrument.sessions )
      {
         current_session_begin_ = [ NSDate dateWithTimeInterval: trading_session_.beginTime + ( trading_session_.beginTime > trading_session_.endTime ? - 3600 * 24 : 0 )
                                                      sinceDate: gmt_date_ ];
         
         current_session_end_ = [ NSDate dateWithTimeInterval: trading_session_.endTime
                                                    sinceDate: gmt_date_ ];
         
         if ( [ gmt_now_ compare: current_session_begin_ ] == NSOrderedDescending &&
             [ gmt_now_ compare: current_session_end_ ] == NSOrderedAscending )
         {
            current_session_ = trading_session_;
            break;
         }
      }
      
      if ( !current_session_ )
      {
         current_session_ = [ symbol_.instrument.sessions objectAtIndex: 0 ];
         
         current_session_begin_ = [ NSDate dateWithTimeInterval: current_session_.beginTime
                                                      sinceDate: gmt_date_ ];
         
         current_session_end_ = [ NSDate dateWithTimeInterval: current_session_.endTime
                                                    sinceDate: gmt_date_ ];
      }
      
      return [ NSString stringWithFormat: @"%@ (%@ - %@)"
       , nameForSessionType( current_session_.type )
       , [ [ current_session_begin_ dateByAddingTimeInterval: [ [ NSTimeZone localTimeZone ] secondsFromGMT ] ] shortTimeString ]
       , [ [ current_session_end_ dateByAddingTimeInterval: [ [ NSTimeZone localTimeZone ] secondsFromGMT ] ] shortTimeString ]
       ];
   }
   else
   {
      return @"";
   }
}

@interface PFSymbolInfoGroup ()

@property ( nonatomic, weak ) id < PFSymbol > symbol;
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
      [ general_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_DELIVERY_METHOD", nil )
                                                                andValue: self.symbol.instrument.deliveryMethod ] ];
      
      [ general_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_CONTRACT_MONTH", nil )
                                                                andValue: [ self.symbol.contractMonthDate shortDateString ] ] ];
      
      [ general_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_FIRST_TRADE_DATE", nil )
                                                                andValue: [ self.symbol.firstTradeDate shortDateString ] ] ];
      
      [ general_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_LAST_TRADE_DATE", nil )
                                                                andValue: [ self.symbol.lastTradeDate shortDateString ] ] ];
      
      [ general_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_NOTICE_DATE", nil )
                                                                andValue: [ self.symbol.noticeDate shortDateString ] ] ];
      
      [ general_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_SETTLEMENT_DATE", nil )
                                                                andValue: [ self.symbol.settlementDate shortDateString ] ] ];
      
      [ general_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_CLOSE_OUT_DATE", nil )
                                                                andValue: [ self.symbol.autoCloseDate shortDateString ] ] ];
   }   
   
   [ general_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_TRADING_BALANCE", nil )
                                                             andValue: [ NSString stringWithFormat: @"T + %d", self.symbol.instrument.tradingBalance ] ] ];
   
   return general_rows_array_;
}

-(NSArray*)tradingInfoRows
{
   NSMutableArray* trading_rows_array_ = [ NSMutableArray arrayWithCapacity: 8 ];
   
   [ trading_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_TRADING_ALLOWED", nil )
                                                             andValue: nameForTradeMode( self.symbol.instrument.tradeMode ) ] ];
   
   if ( self.symbol.isFutures )
   {
      [ trading_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_DELIVERY_STATUS", nil )
                                                                andValue: ( [ self.symbol.lastTradeDate compare: [ NSDate date ] ] == NSOrderedAscending ) ?
                                        nameForDeliveryStatus(self.symbol.deliveryStatus) :
                                        @"---" ] ];
   }
   
   [ trading_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_CURRENT_SESSION", nil )
                                                             andValue: nameForCurrentSession( self.symbol ) ] ];
   
   [ trading_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_EXP", nil )
                                                             andValue: self.symbol.instrument.exp2 ] ];
   
   if ( self.symbol.isFutures )
   {
      double lot_size_ = self.symbol.lotSize;
      
      if ( self.symbol.pointSize != 0 )
      {
         lot_size_ = fabsf(self.symbol.tickCoast / self.symbol.pointSize );
      }

      [ trading_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_LOT_SIZE", nil )
                                                                andValue: [ NSString stringWithAmount: lot_size_ ] ] ];
      
      double tick_coast_ = self.symbol.tickCoast;
      
      if ( tick_coast_ < 0.0 )
      {
         tick_coast_ = self.symbol.lotSize * self.symbol.pointSize;
      }
      
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
                                                                andValue: [ NSString stringWithAmount: self.symbol.lotSize * self.symbol.pointSize ] ] ];
   }
   
   [ trading_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_TICK_SIZE", nil )
                                                             andValue: [ NSString stringWithAmount: self.symbol.pointSize ] ] ];
   
   [ trading_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_MINIMAL_LOT", nil )
                                                             andValue: [ NSString stringWithAmount: self.symbol.minimalLot ] ] ];
   
   [ trading_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_LOT_STEP", nil )
                                                             andValue: [ NSString stringWithAmount: self.symbol.lotStep ] ] ];
   
   return trading_rows_array_;
}

-(NSArray*)marginInfoRows
{
   //! Not all servers ready
   return nil;
   
//   NSMutableArray* margin_rows_array_ = [ NSMutableArray arrayWithCapacity: 2 ];
//   
//   return margin_rows_array_;
}

-(NSArray*)feesInfoRows
{
   NSMutableArray* fees_rows_array_ = [ NSMutableArray arrayWithCapacity: 8 ];
   
   [ fees_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_FEES_SWAPBUY", nil )
                                                          andValue: [ NSString stringWithAmount: self.symbol.instrument.swapBuy ] ] ];
   
   [ fees_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_FEES_SWAPSELL", nil )
                                                          andValue: [ NSString stringWithAmount: self.symbol.instrument.swapSell ] ] ];
   
   id< PFCommissionLevel > commission_level_ = [ [ PFSession sharedSession ] currentCommissionLevelForInstrument: self.symbol.instrument ];
   
   if ( commission_level_ )
   {
      NSString* unit_ = @"%";
      
      if ( commission_level_.type == PFCommissionTypePerLotInServerCCY ||
          commission_level_.type == PFCommissionTypePerPips ||
          commission_level_.type == PFCommissionTypePerHit )
      {
         unit_ = [ [ PFSession sharedSession ].accounts.defaultAccount baseCurrency ];
      }
      else if ( commission_level_.type == PFCommissionTypePerLotInInstrumentCCY )
      {
         unit_ = self.symbol.instrument.exp2;
      }
      else if ( commission_level_.type == PFCommissionTypePerLotInSpecified )
      {
         unit_ = commission_level_.specifiedCurrency;
      }

      [ fees_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_FEES_OPEN", nil )
                                                                andValue: [ NSString stringWithFormat: @"%@ %@"
                                                                           , [ NSString stringWithAmount: commission_level_.openPrice ]
                                                                           , unit_ ] ] ];
      
      [ fees_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_FEES_CLOSE", nil )
                                                             andValue: [ NSString stringWithFormat: @"%@ %@"
                                                                        , [ NSString stringWithAmount: commission_level_.closePrice ]
                                                                        , unit_ ] ] ];
      
      [ fees_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_FEES_ORDER_MIN", nil )
                                                             andValue: [ NSString stringWithFormat: @"%@ %@"
                                                                        , [ NSString stringWithAmount: commission_level_.minPerOrder ]
                                                                        , unit_ ] ] ];
      
      [ fees_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_FEES_ORDER_MAX", nil )
                                                             andValue: [ NSString stringWithFormat: @"%@ %@"
                                                                        , [ NSString stringWithAmount: commission_level_.maxPerOrder ]
                                                                        , unit_ ] ] ];
      
      [ fees_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_FEES_FREE", nil )
                                                             andValue: [ NSString stringWithFormat: @"%@ %@"
                                                                        , [ NSString stringWithAmount: commission_level_.freeAmount ]
                                                                        , unit_ ] ] ];
      
      [ fees_rows_array_ addObject: [ PFSymbolInfoRow infoRowWithName: NSLocalizedString( @"SYMBOL_INFO_FEES_PHONE", nil )
                                                             andValue: [ NSString stringWithFormat: @"%@ %@"
                                                                        , [ NSString stringWithAmount: commission_level_.dealerCommission ]
                                                                        , unit_ ] ] ];
   }
   
   return fees_rows_array_;
}

-(NSArray*)sessionInfoRows
{
   if ( [ self.symbol.instrument.sessions count ] > 0 )
   {
      NSMutableArray* session_rows_ = [ NSMutableArray new ];
      NSDate* gmt_date_ = [ NSDate dateFromDateAndTime: [ NSDate GMTNow ] ];
      
      for ( id< PFTradingSession > trading_session_ in self.symbol.instrument.sessions )
      {
         NSDate* local_begin_ = [ NSDate dateWithTimeInterval: trading_session_.beginTime + [ [ NSTimeZone localTimeZone ] secondsFromGMT ]
                                                    sinceDate: gmt_date_ ];
         
         NSDate* local_end_ = [  NSDate dateWithTimeInterval: trading_session_.endTime + [ [ NSTimeZone localTimeZone ] secondsFromGMT ]
                                                   sinceDate: gmt_date_ ];
         
         [ session_rows_ addObject: [ PFSymbolInfoRow infoRowWithName: nameForSessionType( trading_session_.type )
                                                             andValue: [ NSString stringWithFormat: @"%@ - %@"
                                                                        , [ local_begin_ shortTimeString ]
                                                                        , [ local_end_ shortTimeString ] ] ] ];
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
