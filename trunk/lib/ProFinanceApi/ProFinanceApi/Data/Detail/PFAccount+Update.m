#import "PFAccount+Update.h"

#import "PFSymbol.h"
#import "PFQuote.h"
#import "PFInstrument.h"

#import "PFPosition+Update.h"

@implementation PFAccount (Update)

-(NSArray*)update
{
   double total_net_pl_ = 0.0;
   double total_gross_pl_ = 0.0;
   double stock_value_ = 0.0;
   double profit_for_margin_ = 0.0;

   NSArray* positions_updated_ = [ self.positions copy ];
   for ( PFPosition* position_ in positions_updated_ )
   {
      //!should be synchronized
      [ position_ update ];

      total_net_pl_ += position_.netPl;
      total_gross_pl_ += position_.grossPl;
      profit_for_margin_ += [ position_.symbol.instrument profitWithGrossPl: position_.grossPl ];

      if ( position_.operationType == PFMarketOperationBuy && position_.symbol.marginType == PFInstrumentMarginTypeStocks )
      {
         stock_value_ += ( position_.closePrice * position_.symbol.quote.crossPrice * position_.amount * position_.symbol.lotSize );
      }
   }

   self.totalNetPl = total_net_pl_;
   self.totalGrossPl = total_gross_pl_;
   self.stockValue = stock_value_ * self.crossPrice;
   self.profitForMargin = profit_for_margin_;

   return positions_updated_;
}

@end
