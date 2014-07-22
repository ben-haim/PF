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
   
   if ( bid_quote_info_ && ask_quote_info_ )
   {
      PFLotsQuote* lots_quote_ = [ PFLotsQuote new ];
      lots_quote_.date = quote_date_;
      lots_quote_.bidInfo = bid_quote_info_;
      lots_quote_.askInfo = ask_quote_info_;
      
      return lots_quote_;
   }
   else if ( trade_quote_info_ )
   {
      PFTradesQuote* trades_quote_ = [ PFTradesQuote new ];
      trades_quote_.date = quote_date_;
      trades_quote_.info = trade_quote_info_;
      
      return trades_quote_;
   }
   else
   {
      return nil;
   }
}

@end
