#import "PFAccount+Update.h"

#import "PFSymbol.h"
#import "PFQuote.h"
#import "PFInstrument.h"
#import "PFCrossRates.h"
#import "PFSession.h"
#import "PFTradeSessionContainer.h"

#import "PFPosition+Update.h"

@implementation PFAccount (Update)

-(NSArray*)update
{
   NSArray* positions_updated_ = [ self.positions copy ];

   for (PFAssetAccount* asset_account_ in self.assetAccounts)
   {
      double total_gross_pnl_ = 0;
      double total_net_pnl_ = 0;
      double stock_value_summ_ = 0;
      double position_value_sum_ = 0;
      int positions_count_ = 0;

      for ( PFPosition* position_ in positions_updated_ )
      {
         if (position_.accountId != self.accountId)
            continue;

         PFSymbol* symbol_ = (PFSymbol*)position_.symbol;
         PFQuote* quote_ = symbol_.quote;

         if (self.accountType == PFAccountTypeMultiAsset && [asset_account_.currency isEqualToString: symbol_.instrument.exp2])
            continue;

         positions_count_++;

         double quote_bid_ = quote_.bid;
         double quote_ask_ = quote_.ask;

         double current_cross_ = [ [ PFCrossRates sharedRates ] priceForCurrency: symbol_.instrument.exp2
                                                                    toCurrency: position_.account.currency ];

         double open_cross_ = symbol_.instrument.useSameCrossPriceforCloseOpen ? current_cross_ : position_.openCrossPrice;
         double currentPrice = (position_.operationType == PFMarketOperationBuy) ? quote_bid_ : quote_ask_;

         id< PFTradeSessionContainer > trade_session_ = [ [ PFSession sharedSession ] tradeSessionContainerForInstrument: symbol_.instrument ];

         if ((current_cross_ != -1) && (trade_session_) && (trade_session_.currentTradeSession) && (currentPrice > 0))
         {
            double position_value_ = currentPrice *  current_cross_ * position_.amount * symbol_.instrument.lotSize;
            double exposure_value_ = position_.openPrice * open_cross_ * position_.amount * symbol_.instrument.lotSize;
            double gross_pl_ = (position_value_ - exposure_value_) * (position_.operationType == PFMarketOperationBuy ? 1 : -1);

            position_value_sum_ += position_value_;

            if (symbol_.instrument.type == PFInstrumentFutures)
               position_.grossPl = gross_pl_ / symbol_.pipsSize * symbol_.instrument.tickCoast;
            else
               position_.grossPl = gross_pl_;

            total_gross_pnl_ += position_.grossPl;

            if (symbol_.instrument)
            {
               position_.netPl = position_.grossPl + position_.commission + position_.swap;
               total_net_pnl_ += position_.netPl;

               bool is_ext_ = (symbol_.instrument.type == PFInstrumentForex) && (symbol_.instrument.precision % 2 != 0);

               double difference_ = (position_.operationType == PFMarketOperationBuy) ? (quote_bid_ - position_.openPrice) : (position_.openPrice - quote_ask_);
               position_.plTicks = difference_ / (is_ext_ ? (symbol_.instrument.pointSize * 10) : (symbol_.instrument.pointSize));

               if ((position_.operationType == PFMarketOperationBuy) && (symbol_.instrument.marginType == PFInstrumentStocks))
                  stock_value_summ_ += (position_.closePrice *  current_cross_ * position_.amount * symbol_.instrument.lotSize);
            }
         }
         else
         {
            position_.netPl = 0;
            position_.grossPl = 0;
            position_.plTicks = 0;
         }

         asset_account_.positionValue = position_value_sum_;
         asset_account_.positionSum = positions_count_;
         asset_account_.grossPL = total_gross_pnl_;
         asset_account_.netPL = total_net_pnl_;
         [asset_account_ recalculateValues: self];

         double current_balance_for_fargin_ = self.balance + total_gross_pnl_;
         double total_used_margin_ = self.usedMargin + self.blockedForOrders;

         double stop_trade_ = self.riskFromEquity ?
            current_balance_for_fargin_ * self.tradingLevel / 100 :
            total_used_margin_ * 100 / self.tradingLevel;

         asset_account_.stopTrading = stop_trade_;

         double stop_out_ = self.riskFromEquity ?
            current_balance_for_fargin_ * self.marginLevel / 100 :
            total_used_margin_ * 100 / self.marginLevel;

         asset_account_.stopOut = stop_out_;

         double withdrawal_available_ = asset_account_.availableMargin - ((self.marginMode && total_gross_pnl_ > 0) ? total_gross_pnl_ : 0);

         if (withdrawal_available_ > 0)
            asset_account_.withDrawalAvaiable = withdrawal_available_;
         else
            asset_account_.withDrawalAvaiable = 0;

         asset_account_.stocksValue = stock_value_summ_;
      }

      if (positions_count_ == 0)
      {
         asset_account_.grossPL = total_gross_pnl_;
         asset_account_.netPL = total_net_pnl_;
         [ asset_account_ recalculateValues: self ];
         asset_account_.positionSum = 0;
         asset_account_.positionValue = 0;

         double withdrawal_available_ = asset_account_.availableMargin;

         if (withdrawal_available_ > 0)
            asset_account_.withDrawalAvaiable = withdrawal_available_;
         else
            asset_account_.withDrawalAvaiable = 0;

         asset_account_.stocksValue = stock_value_summ_;
      }

      asset_account_.orderSum = 0;
      for (PFMarketOperation* order_ in self.orders)
      {
         if (order_.accountId == self.accountId)
         {
            NSString* order_currency_ = order_.operationType == PFMarketOperationBuy ? order_.symbol.instrument.exp2 : order_.symbol.instrument.exp1;
            if (self.accountType == PFAccountTypeMultiAsset ? [asset_account_.currency isEqual: order_currency_] : YES)
               asset_account_.orderSum++;
         }
      }
   }

   return positions_updated_;


//   NSArray* positions_updated_ = [ self.positions copy ];
//
//   double total_net_pl_ = 0.0;
//   double total_gross_pl_ = 0.0;
//   double stock_value_ = 0.0;
//   double profit_for_margin_ = 0.0;
//
//   for ( PFPosition* position_ in positions_updated_ )
//   {
//      //!should be synchronized
//      [ position_ update ];
//
//      total_net_pl_ += position_.netPl;
//      total_gross_pl_ += position_.grossPl;
//      profit_for_margin_ += [ position_.symbol.instrument profitWithGrossPl: position_.grossPl ];
//
//      if ( position_.operationType == PFMarketOperationBuy && position_.symbol.marginType == PFInstrumentMarginTypeStocks )
//      {
//         PFDouble cross_price_ = [ [ PFCrossRates sharedRates ] priceForCurrency: position_.symbol.instrument.exp2
//                                                                      toCurrency: position_.account.currency ];
//
//         stock_value_ += ( position_.closePrice * cross_price_ * position_.amount * position_.symbol.lotSize );
//      }
//   }
//
//   self.totalNetPl = total_net_pl_;
//   self.totalGrossPl = total_gross_pl_;
//   self.stockValue = stock_value_ * self.crossPrice;
//   self.profitForMargin = profit_for_margin_;
//
//   return positions_updated_;
}

@end
