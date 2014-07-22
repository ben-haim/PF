#import "PFQuoteApi.h"

#import "PFApiDelegate.h"

#import "PFMessage.h"
#import "PFField.h"

#import "PFMessageBuilder.h"

#import "PFInstrument.h"
#import "PFLevel2Quote.h"
#import "PFLevel2QuotePackage.h"

#import "PFLevel4Quote.h"

#import "PFQuoteFilesReader.h"

#import "PFQuoteFile+PFMessage.h"

@implementation PFQuoteApi

-(PFInteger)logonMode
{
   return PFLoginModeQuote | PFLoginModeHistory;
}

-(void)processMessage:( PFMessage* )message_
{
   PFShort message_type_ = [ [ message_ fieldWithId: PFFieldMessageType ] shortValue ];

   if ( message_type_ == PFMessageInstrument )
   {
      PFInstrument* instrument_ = [ PFInstrument objectWithFieldOwner: message_ ];
      
      //!Currently forwards are not supported
      if ( instrument_.type != PFInstrumentForward )
      {
         [ self.delegate api: self didLoadInstrument: instrument_ ];
      }
   }
   else if ( message_type_ == PFMessageLevel1Quote )
   {
      [ self.delegate api: self didLoadQuoteMessage: message_ ];
   }
   else if ( message_type_ == PFMessageLevel2Quote )
   {
      PFLevel2Quote* quote_ = [ PFLevel2Quote objectWithFieldOwner: message_ ];
      quote_.price = quote_.realPrice;
      [ self.delegate api: self didLoadLevel2Quote: quote_ ];
   }
   else if ( message_type_ == PFMessageLevel2QuoteAggregated )
   {
      PFLevel2QuotePackage* quote_package_ = [ PFLevel2QuotePackage objectWithFieldOwner: message_ ];
      [ self.delegate api: self didLoadLevel2QuotePackage: quote_package_ ];
   }
   else if ( message_type_ == PFMessageLevel3Quote )
   {
      [ self.delegate api: self didLoadTradeQuoteMessage: message_ ];
   }
   else if ( message_type_ == PFMessageLevel4Quote )
   {
      PFLevel4Quote* quote_ = [ PFLevel4Quote objectWithFieldOwner: message_ ];
      [ self.delegate api: self didLoadLevel4Quote: quote_ ];
   }
   else if ( message_type_ == PFMessageCrossRatesMessage )
   {
       [ self.delegate api: self didLoadCrossRatesMessage: message_ ];
   }
}

-(void)subscribeToSymbols:( NSArray* )symbols_
                     type:( PFSubscriptionType )subscription_type_
{
   PFMessage* subscribe_message_ = [ self.messageBuilder messageForSubscribe: PFSubsribeAction
                                                                        type: subscription_type_
                                                                     symbols: symbols_ ];
   
   [ self sendMessage: subscribe_message_ doneBlock: nil ];
}

-(void)unsubscribeFromSymbols:( NSArray* )symbols_
                         type:( PFSubscriptionType )subscription_type_
{
   PFMessage* subscribe_message_ = [ self.messageBuilder messageForSubscribe: PFUnsubsribeAction
                                                                        type: subscription_type_
                                                                     symbols: symbols_ ];

   [ self sendMessage: subscribe_message_ doneBlock: nil ];
}

-(void)historyFilesForSymbol:( id< PFSymbol > )symbol_
                   accountId:( PFInteger )account_id_
                      period:( PFChartPeriodType )period_
                    fromDate:( NSDate* )from_date_
                      toDate:( NSDate* )to_date_
              timeZoneOffset:( PFInteger )time_zone_offset_
                   doneBlock:( PFChartFilesDoneBlock )done_block_
{
   PFChartPeriodType base_period_ = PFBaseChartPeriod( period_ );

   PFRequestDoneBlock parse_files_ = ^( PFMessage* message_ )
   {
      id last_bar_ = [ PFQuoteFile lastBarWithMessage: message_ ];
      NSArray* files_ = [ PFQuoteFile arrayWithFilesFromMessage: message_ ];
      
      done_block_( [ PFQuoteFilesReader readerWithServerInfo: self.serverInfo
                                                       files: files_
                                                     lastBar: last_bar_
                                                    fromDate: from_date_
                                                  basePeriod: base_period_
                                           destinationPeriod: period_
                                              timeZoneOffset: time_zone_offset_ ] );
   };

   [ self sendMessage: [ self.messageBuilder messageForHistoryFilesWithSymbol: symbol_
                                                                    accountId: account_id_
                                                                       period: base_period_
                                                                     fromDate: from_date_
                                                                       toDate: to_date_ ]
            doneBlock: parse_files_ ];
}

@end
