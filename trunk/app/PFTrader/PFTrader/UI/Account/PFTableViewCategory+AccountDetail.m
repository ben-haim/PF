#import "PFTableViewCategory+AccountDetail.h"

#import "PFTableViewDetailItem.h"
#import "PFTableViewMoneyItem.h"
#import "PFBrandingSettings.h"
#import "NSString+DoubleFormatter.h"

#import <ProFinanceApi/ProFinanceApi.h>

@implementation PFTableViewCategory (AccountDetail)

+(id)todayCategoryWithAccount:( id< PFAccount > )account_
{
   PFTableViewItem* gross_pl_ = [ PFTableViewMoneyItem itemWithTitle: NSLocalizedString( @"GROSS_PL", nil )
                                                              amount: account_.grossPl
                                                            currency: account_.currency
                                                           colorSign: YES ];

   PFTableViewItem* net_pl_ = [ PFTableViewMoneyItem itemWithTitle: NSLocalizedString( @"NET_PL", nil )
                                                            amount: account_.netPl
                                                          currency: account_.currency
                                                         colorSign: YES ];

   PFTableViewItem* fees_ = [ PFTableViewMoneyItem itemWithTitle: NSLocalizedString( @"FEES", nil )
                                                          amount: account_.todayFees == 0.0 ? account_.todayFees : - account_.todayFees
                                                        currency: account_.currency
                                                       colorSign: NO ];

   PFTableViewItem* volume_ = [ PFTableViewDetailItem itemWithAction: nil
                                                               title: NSLocalizedString( @"VOLUME", nil )
                                                               value: [ NSString stringWithAmount: account_.amount ] ];

   PFTableViewItem* trades_count_ = [ PFTableViewDetailItem itemWithAction: nil
                                                                     title: NSLocalizedString( @"TRADES", nil )
                                                                     value: [ NSString stringWithFormat: @"%d", account_.tradesCount ] ];

   return [ self categoryWithTitle: nil
                             items: [ NSArray arrayWithObjects: gross_pl_, net_pl_, fees_, volume_, trades_count_, nil ] ];
}

+(id)activityCategoryWithAccount:( id< PFAccount > )account_
{
   PFTableViewItem* gross_pl_ = [ PFTableViewMoneyItem itemWithTitle: NSLocalizedString( @"OPEN_GROSS_PL", nil )
                                                              amount: account_.totalGrossPl
                                                            currency: account_.currency
                                                           colorSign: YES ];
   
   PFTableViewItem* net_pl_ = [ PFTableViewMoneyItem itemWithTitle: NSLocalizedString( @"OPEN_NET_PL", nil )
                                                            amount: account_.totalNetPl
                                                          currency: account_.currency
                                                         colorSign: YES ];
   
   PFTableViewItem* orders_ = [ PFTableViewDetailItem itemWithAction: nil
                                                               title: NSLocalizedString( @"N_ORDERS", nil )
                                                               value: [ NSString stringWithFormat: @"%d", (int)account_.orders.count ] ];
   
   PFTableViewItem* positions_ = [ PFTableViewDetailItem itemWithAction: nil
                                                                  title: NSLocalizedString( @"N_POSITIONS", nil )
                                                                  value: [ NSString stringWithFormat: @"%d", (int)account_.positions.count ] ];
   
   PFTableViewItem* orders_margin_ = [ PFTableViewMoneyItem itemWithTitle: NSLocalizedString( @"ORDERS_MARGIN", nil )
                                                                   amount: account_.ordersMargin
                                                                 currency: account_.currency
                                                                colorSign: NO ];
   
   PFTableViewItem* positions_margin_ = [ PFTableViewMoneyItem itemWithTitle: NSLocalizedString( @"POSITIONS_MARGIN", nil )
                                                                      amount: account_.positionsMargin
                                                                    currency: account_.currency
                                                                   colorSign: NO ];
   
   PFTableViewItem* funds_ = [ PFTableViewMoneyItem itemWithTitle: NSLocalizedString( @"BLOCKED_FOR_FUNDS", nil )
                                                           amount: account_.blockedFunds
                                                         currency: account_.currency
                                                        colorSign: NO ];
    
    NSArray* activity_items_ = nil;
    
    if ( [ PFBrandingSettings sharedBranding ].showFundValues )
    {
        PFTableViewItem* stock_value_ = [ PFTableViewMoneyItem itemWithTitle: NSLocalizedString( @"STOCK_VALUE", nil )
                                                                      amount: account_.stockValue
                                                                    currency: account_.currency
                                                                   colorSign: NO ];
        
        PFTableViewItem* current_fund_capital_ = [ PFTableViewMoneyItem itemWithTitle: NSLocalizedString( @"CURRENT_FUND_CAPITAL", nil )
                                                                               amount: account_.currentFundCapital
                                                                             currency: account_.currency
                                                                            colorSign: NO ];
        
        PFTableViewItem* fund_capital_gain_ = [ PFTableViewMoneyItem itemWithTitle: NSLocalizedString( @"FUND_CAPITAL_GAIN", nil )
                                                                            amount: account_.fundCapitalGain
                                                                          currency: account_.currency
                                                                         colorSign: NO ];
        
        PFTableViewItem* invested_fund_capital_ = [ PFTableViewMoneyItem itemWithTitle: NSLocalizedString( @"INVESTED_FUND_CAPITAL", nil )
                                                                                amount: account_.investedFundCapital
                                                                              currency: account_.currency
                                                                             colorSign: NO ];
        
        activity_items_ = [ NSArray arrayWithObjects: gross_pl_
                           , net_pl_
                           , orders_
                           , positions_
                           , orders_margin_
                           , positions_margin_
                           , funds_
                           , stock_value_
                           , current_fund_capital_
                           , fund_capital_gain_
                           , invested_fund_capital_
                           , nil ];
    }
    else
    {
        activity_items_ = [ NSArray arrayWithObjects: gross_pl_
                           , net_pl_
                           , orders_
                           , positions_
                           , orders_margin_
                           , positions_margin_
                           , funds_
                           , nil ];
    }
    
   return [ self categoryWithTitle: nil items: activity_items_ ];
}

+(id)generalCategoryWithAccount:( id< PFAccount > )account_
{
   PFTableViewItem* balance_ = [ PFTableViewMoneyItem itemWithTitle: NSLocalizedString( @"ACCOUNT_BALANCE", nil )
                                                             amount: account_.balance
                                                           currency: account_.currency
                                                          colorSign: NO ];

   PFTableViewItem* equity_ = [ PFBrandingSettings sharedBranding ].showEquityValue ? [ PFTableViewMoneyItem itemWithTitle: NSLocalizedString( @"ACCOUNT_EQUITY", nil )
                                                                                                                     amount: account_.equity
                                                                                                                   currency: account_.currency
                                                                                                                  colorSign: NO ] : nil;

   PFTableViewItem* value_ = [ PFTableViewMoneyItem itemWithTitle: NSLocalizedString( @"ACCOUNT_VALUE", nil )
                                                           amount: account_.value
                                                         currency: account_.currency
                                                        colorSign: NO ];

   PFTableViewItem* margin_avaliable_ = [ PFTableViewMoneyItem itemWithTitle: NSLocalizedString( @"MARGIN_AVAILABLE", nil )
                                                                      amount: account_.marginAvailable
                                                                    currency: account_.currency
                                                                   colorSign: NO ];

   PFTableViewItem* current_margin_ = [ PFTableViewDetailItem itemWithAction: nil
                                                                       title: NSLocalizedString( @"CURRENT_MARGIN", nil )
                                                                       value: [ NSString stringWithPercent: account_.currentMargin showPercentSign: YES ] ];

   PFTableViewItem* margin_warning_ = [ PFTableViewMoneyItem itemWithTitle: NSLocalizedString( @"MARGIN_WARNING", nil )
                                                                    amount: account_.marginWarning
                                                                  currency: account_.currency
                                                                 colorSign: NO ];

   PFTableViewItem* stop_trading_ = [ PFTableViewMoneyItem itemWithTitle: NSLocalizedString( @"STOP_TRADING", nil )
                                                                  amount: account_.stopTrading
                                                                currency: account_.currency
                                                               colorSign: NO ];

   PFTableViewItem* stop_out_ = [ PFTableViewMoneyItem itemWithTitle: NSLocalizedString( @"STOP_OUT", nil )
                                                              amount: account_.stopOut
                                                            currency: account_.currency
                                                           colorSign: NO ];

   PFTableViewItem* blocked_balance_ = [ PFTableViewMoneyItem itemWithTitle: NSLocalizedString( @"BLOCKED_BALANCE", nil )
                                                                     amount: account_.blockedBalance
                                                                   currency: account_.currency
                                                                  colorSign: NO ];

   PFTableViewItem* cash_balance_ = [ PFTableViewMoneyItem itemWithTitle: NSLocalizedString( @"CASH_BALANCE", nil )
                                                                  amount: account_.cashBalance
                                                                currency: account_.currency
                                                               colorSign: NO ];

   PFTableViewItem* withdrawal_ = [ PFTableViewMoneyItem itemWithTitle: NSLocalizedString( @"WITHDRAWAL_AVAILABLE", nil )
                                                                amount: account_.withdrawalAvailable
                                                              currency: account_.currency
                                                             colorSign: NO ];


   NSMutableArray* general_items_ = [NSMutableArray new];
   if (balance_)           [general_items_ addObject: balance_];
   if (equity_)            [general_items_ addObject: equity_];
   if (value_)             [general_items_ addObject: value_];
   if (margin_avaliable_)  [general_items_ addObject: margin_avaliable_];
   if (current_margin_)    [general_items_ addObject: current_margin_];
   if (margin_warning_)    [general_items_ addObject: margin_warning_];
   if (stop_trading_)      [general_items_ addObject: stop_trading_];
   if (stop_out_)          [general_items_ addObject: stop_out_];
   if (blocked_balance_)   [general_items_ addObject: blocked_balance_];
   if (cash_balance_)      [general_items_ addObject: cash_balance_];
   if (withdrawal_)        [general_items_ addObject: withdrawal_];

   return [ self categoryWithTitle: nil items: general_items_ ];
}

@end
