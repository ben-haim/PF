#import "PFPosition+Update.h"

//#import "PFSymbol.h"
//#import "PFInstrument.h"
//#import "PFAccount.h"
//#import "PFQuote.h"
//#import "PFLevel4QuotePackage.h"
//#import "PFCrossRates.h"

@implementation PFPosition (Update)

//-(void)update
//{
//   PFDouble amount_exp1_ = self.amount * self.symbol.lotSize;
//   if ( self.operationType == PFMarketOperationSell )
//      amount_exp1_ = -amount_exp1_;
//   
//   PFDouble amount_exp1_close_ = -amount_exp1_;
//   
//   PFDouble amount_exp2_ = -( amount_exp1_ * self.openPrice );
//   
//   PFDouble bid_ = self.strikePrice > 0 ? [ self.symbol.level4Quotes bidForSymbolId: self ] : self.symbol.quote.bid;
//   PFDouble ask_ = self.strikePrice > 0 ? [ self.symbol.level4Quotes askForSymbolId: self ] : self.symbol.quote.ask;
//   
//   PFDouble amount_exp2_close_ = -amount_exp1_close_ * ( self.operationType == PFMarketOperationBuy ? bid_ : ask_ );
//
//   PFDouble profit_exp2_ = amount_exp2_ + amount_exp2_close_;
//
//   PFDouble cross_price_ = [ [ PFCrossRates sharedRates ] priceForCurrency: self.symbol.instrument.exp2 toCurrency: self.account.currency ];
//
//   if ( self.symbol.isFutures && self.symbol.tickCoast > 0 )
//   {
//      profit_exp2_ *= self.symbol.tickCoast / self.symbol.pipsSize;
//   }
//
//   if (amount_exp2_close_ != 0.0 )
//   {
//      self.profitUSD = profit_exp2_ * cross_price_;
//      self.netProfitUSD = self.profitUSD + ( ( self.swap - self.commission ) / self.account.crossPrice );
//   }
//   else
//   {
//      self.profitUSD = 0;
//      self.netProfitUSD = 0;
//   }
//}

@end
