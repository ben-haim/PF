#import "PFQuoteFile+PFMessage.h"

#import "PFMessage.h"
#import "PFField.h"

#import "PFQuoteInfo.h"

@implementation PFQuoteFile (PFMessage)

+(NSArray*)arrayWithFilesFromMessage:( PFMessage* )message_
{
   NSArray* files_group_ = [ message_ groupFieldsWithId: PFGroupHistoryFileInfo ];

   NSMutableArray* files_ = [ NSMutableArray arrayWithCapacity: [ files_group_ count ] ];
   for ( PFGroupField* group_field_ in files_group_ )
   {
      [ files_ addObject: [ PFQuoteFile objectWithFieldOwner: group_field_.fieldOwner ] ];
   }

   return files_;
}

+(PFQuoteInfo*)quoteInfoWithGroupField:( PFGroupField* )bar_group_
{
   PFQuoteInfo* quote_info_ = [ PFQuoteInfo new ];
   
   quote_info_.open = [ [ bar_group_ fieldWithId: PFFieldOpen ] doubleValue ];
   quote_info_.high = [ [ bar_group_ fieldWithId: PFFieldHigh ] doubleValue ];
   quote_info_.low = [ [ bar_group_ fieldWithId: PFFieldLow ] doubleValue ];
   quote_info_.close = [ [ bar_group_ fieldWithId: PFFieldClosePrice ] doubleValue ];
   quote_info_.volume = [ ( PFLongField* )[ bar_group_ fieldWithId: PFFieldSize ] longValue ];
   
   return quote_info_;
}

+(id)lastBarWithMessage:( PFMessage* )message_
{
   NSDate* quote_date_;
   
   PFQuoteInfo* bid_quote_info_;
   PFQuoteInfo* ask_quote_info_;
   PFQuoteInfo* trade_quote_info_;
   
   for (PFGroupField* last_bar_group_ in [ message_ groupFieldsWithId: PFGroupQuoteBar ] )
   {
      quote_date_ = [ [ last_bar_group_ fieldWithId: PFFieldTimestamp ] dateValue ];
      
      switch ( [ [ last_bar_group_ fieldWithId: PFFieldBarsType ] byteValue ] )
      {
         case 0:
            bid_quote_info_ = [ PFQuoteFile quoteInfoWithGroupField: last_bar_group_ ];
            break;
            
         case 2:
            ask_quote_info_ = [ PFQuoteFile quoteInfoWithGroupField: last_bar_group_ ];
            break;
            
         default:
            trade_quote_info_ = [ PFQuoteFile quoteInfoWithGroupField: last_bar_group_ ];
            break;
      }
   }
   
   PFBaseDayQuote* last_quote_ = nil;
   
   if ( bid_quote_info_ && ask_quote_info_ )
   {
      PFLotsDayQuote* lots_quote_ = [ PFLotsDayQuote new ];
      lots_quote_.bidInfo = bid_quote_info_;
      lots_quote_.askInfo = ask_quote_info_;
      
      last_quote_ = lots_quote_;
   }
   else if ( trade_quote_info_ )
   {
      PFTradesDayQuote* trades_quote_ = [ PFTradesDayQuote new ];
      trades_quote_.info = trade_quote_info_;
      
      last_quote_ = trades_quote_;
   }
   else
   {
      return nil;
   }
   
   last_quote_.date = quote_date_;
   last_quote_.ticks = [ ( PFLongField* )[ message_ fieldWithId: PFFieldTicks ] longValue ];
   last_quote_.volume = [ ( PFLongField* )[ message_ fieldWithId: PFFieldSize ] longValue ];
   last_quote_.sessionType = [ ( PFIntegerField* )[ message_ fieldWithId: PFFieldSessionType ] integerValue ];
   last_quote_.openInterest = [ ( PFLongField* )[ message_ fieldWithId: PFFieldOpenInterest ] longValue ];
   last_quote_.ticksPreMarket = [ ( PFLongField* )[ message_ fieldWithId: PFFieldTicksPreMarket ] longValue ];
   last_quote_.volumePreMarket = [ ( PFLongField* )[ message_ fieldWithId: PFFieldVolumePreMarket ] longValue ];
   last_quote_.ticksAfterMarket = [ ( PFLongField* )[ message_ fieldWithId: PFFieldTicksPostMarket ] longValue ];
   last_quote_.volumeAfterMarket = [ ( PFLongField* )[ message_ fieldWithId: PFFieldVolumePostMarket ] longValue ];
   
   return last_quote_;
}

@end
