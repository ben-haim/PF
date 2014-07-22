#import "PFTableViewCategory+AccountDetail.h"

#import "PFTableViewDetailItem.h"
#import "PFTableViewMoneyItem.h"
#import "PFAssetAccountsPickerItem.h"

#import "NSString+DoubleFormatter.h"

#import <ProFinanceApi/ProFinanceApi.h>

@implementation PFTableViewCategory (AccountDetail)

+(id)todayCategoryWithAccount:( id< PFAccount > )account_
{
   PFTableViewItem* gross_pl_ = [ PFTableViewMoneyItem itemWithTitle: NSLocalizedString( @"GROSS_PL", nil )
                                                              amount: account_.grossPl
                                                           precision: account_.precision
                                                            currency: account_.currency
                                                           colorSign: YES ];

   PFTableViewItem* net_pl_ = [ PFTableViewMoneyItem itemWithTitle: NSLocalizedString( @"NET_PL", nil )
                                                            amount: account_.netPl
                                                         precision: account_.precision
                                                          currency: account_.currency
                                                         colorSign: YES ];

   PFTableViewItem* fees_ = [ PFTableViewMoneyItem itemWithTitle: NSLocalizedString( @"FEES", nil )
                                                          amount: account_.todayFees
                                                       precision: account_.precision
                                                        currency: account_.currency
                                                       colorSign: NO ];

   PFTableViewItem* volume_ = [ PFTableViewDetailItem itemWithAction: nil
                                                               title: NSLocalizedString( @"VOLUME", nil )
                                                               value: [ NSString stringWithAmount: account_.amount ] ];

   PFTableViewItem* trades_count_ = [ PFTableViewDetailItem itemWithAction: nil
                                                                     title: NSLocalizedString( @"TRADES", nil )
                                                                     value: [ NSString stringWithFormat: @"%d", account_.tradesCount ] ];

   return [ self categoryWithTitle: nil
                             items: @[gross_pl_, net_pl_, fees_, volume_, trades_count_] ];
}

+(id)activityCategoryWithAccount:( id< PFAccount > )account_
{
   PFTableViewItem* gross_pl_ = [ PFTableViewMoneyItem itemWithTitle: NSLocalizedString( @"OPEN_GROSS_PL", nil )
                                                              amount: account_.totalGrossPl
                                                           precision: account_.precision
                                                            currency: account_.currency
                                                           colorSign: YES ];
   
   PFTableViewItem* net_pl_ = [ PFTableViewMoneyItem itemWithTitle: NSLocalizedString( @"OPEN_NET_PL", nil )
                                                            amount: account_.totalNetPl
                                                         precision: account_.precision
                                                          currency: account_.currency
                                                         colorSign: YES ];
   
   PFTableViewItem* orders_ = [ PFTableViewDetailItem itemWithAction: nil
                                                               title: NSLocalizedString( @"N_ORDERS", nil )
                                                               value: [ NSString stringWithFormat: @"%d", (int)account_.orderSum ] ];
   
   PFTableViewItem* positions_ = [ PFTableViewDetailItem itemWithAction: nil
                                                                  title: NSLocalizedString( @"N_POSITIONS", nil )
                                                                  value: [ NSString stringWithFormat: @"%d", (int)account_.positionSum ] ];
   
   PFTableViewItem* orders_margin_ = [ PFTableViewMoneyItem itemWithTitle: NSLocalizedString( @"ORDERS_MARGIN", nil )
                                                                   amount: account_.blockedForOrders
                                                                precision: account_.precision
                                                                 currency: account_.currency
                                                                colorSign: NO ];
   
   PFTableViewItem* positions_margin_ = [ PFTableViewMoneyItem itemWithTitle: NSLocalizedString( @"POSITIONS_MARGIN", nil )
                                                                      amount: account_.initMargin
                                                                   precision: account_.precision
                                                                    currency: account_.currency
                                                                   colorSign: NO ];

   PFTableViewItem* current_fund_capital_ = [ PFTableViewMoneyItem itemWithTitle: NSLocalizedString( @"CURRENT_FUND_CAPITAL", nil )
                                                                          amount: account_.currentFundCapital
                                                                       precision: account_.precision
                                                                        currency: account_.currency
                                                                       colorSign: NO ];

   PFTableViewItem* fund_capital_gain_ = [ PFTableViewMoneyItem itemWithTitle: NSLocalizedString( @"FUND_CAPITAL_GAIN", nil )
                                                                    amount: account_.fundCapitalGain
                                                                    precision: account_.precision
                                                                  currency: account_.currency
                                                                 colorSign: NO ];

   PFTableViewItem* invested_fund_capital_ = [ PFTableViewMoneyItem itemWithTitle: NSLocalizedString( @"INVESTED_FUND_CAPITAL", nil )
                                                                        amount: account_.investedFundCapital
                                                                        precision: account_.precision
                                                                      currency: account_.currency
                                                                     colorSign: NO ];
   
   NSArray* activity_items_ = @[gross_pl_,
                                  net_pl_,
                                  orders_,
                                  positions_,
                                  orders_margin_,
                                  positions_margin_,
                                  current_fund_capital_,
                                  fund_capital_gain_,
                                  invested_fund_capital_];

   return [ self categoryWithTitle: nil items: activity_items_ ];
}

+(id)generalCategoryWithAccount:( id< PFAccount > )account_
{
   PFTableViewItem* balance_ = [ PFTableViewMoneyItem itemWithTitle: NSLocalizedString( @"ACCOUNT_BALANCE", nil )
                                                             amount: account_.balance
                                                          precision: account_.precision
                                                           currency: account_.currency
                                                          colorSign: NO ];

   PFTableViewItem* projected_balance_ = [ PFTableViewMoneyItem itemWithTitle: NSLocalizedString( @"PROJECTED_BALANCE", nil )
                                                                       amount: account_.balance + account_.totalGrossPl
                                                                    precision: account_.precision
                                                                     currency: account_.currency
                                                                    colorSign: NO ];

   PFTableViewItem* value_ = [ PFTableViewMoneyItem itemWithTitle: NSLocalizedString( @"ACCOUNT_VALUE", nil )
                                                           amount: account_.value
                                                        precision: account_.precision
                                                         currency: account_.currency
                                                        colorSign: NO ];

   PFTableViewItem* margin_avaliable_ = [ PFTableViewMoneyItem itemWithTitle: NSLocalizedString( @"MARGIN_AVAILABLE", nil )
                                                                      amount: account_.marginAvailable
                                                                   precision: account_.precision
                                                                    currency: account_.currency
                                                                   colorSign: NO ];

   PFTableViewItem* current_margin_ = [ PFTableViewMoneyItem itemWithTitle: NSLocalizedString( @"CURRENT_MARGIN", nil )
                                                                    amount: account_.usedMargin
                                                                 precision: account_.precision
                                                                  currency: account_.currency
                                                                 colorSign: NO ];

   PFTableViewItem* margin_warning_ = [ PFTableViewMoneyItem itemWithTitle: NSLocalizedString( @"MARGIN_WARNING", nil )
                                                                    amount: account_.marginWarning
                                                                 precision: account_.precision
                                                                  currency: account_.currency
                                                                 colorSign: NO ];

   PFTableViewItem* blocked_balance_ = [ PFTableViewMoneyItem itemWithTitle: NSLocalizedString( @"BLOCKED_BALANCE", nil )
                                                                     amount: account_.blockedSum
                                                                  precision: account_.precision
                                                                   currency: account_.currency
                                                                  colorSign: NO ];

   PFTableViewItem* cash_balance_ = [ PFTableViewMoneyItem itemWithTitle: NSLocalizedString( @"CASH_BALANCE", nil )
                                                                  amount: account_.cashBalance
                                                               precision: account_.precision
                                                                currency: account_.currency
                                                               colorSign: NO ];

   PFTableViewItem* withdrawal_ = [ PFTableViewMoneyItem itemWithTitle: NSLocalizedString( @"WITHDRAWAL_AVAILABLE", nil )
                                                                amount: account_.withdrawalAvailable
                                                             precision: account_.precision
                                                              currency: account_.currency
                                                             colorSign: NO ];

   NSArray* general_items_ = @[balance_,
                              projected_balance_,
                              value_,
                              margin_avaliable_,
                              current_margin_,
                              margin_warning_,
                              blocked_balance_,
                              cash_balance_,
                              withdrawal_];

   return [ self categoryWithTitle: nil items: general_items_ ];
}

+(id)generalAssetCategoryWithAccount:( id< PFAccount > )account_
{
   PFTableViewCategory* general_category_ = [ PFTableViewCategory generalCategoryWithAccount: account_ ];
   
   PFTableViewItem* trades_count_ = [ PFTableViewDetailItem itemWithAction: nil
                                                                     title: NSLocalizedString( @"TRADES", nil )
                                                                     value: [ NSString stringWithFormat: @"%d", account_.tradesCount ] ];
   
   PFTableViewItem* volume_ = [ PFTableViewDetailItem itemWithAction: nil
                                                               title: NSLocalizedString( @"VOLUME", nil )
                                                               value: [ NSString stringWithAmount: account_.amount ] ];
   

   PFTableViewItem* fees_ = [ PFTableViewMoneyItem itemWithTitle: NSLocalizedString( @"FEES", nil )
                                                          amount: account_.todayFees
                                                       precision: account_.precision
                                                        currency: account_.currency
                                                       colorSign: NO ];
   
   PFTableViewItem* orders_margin_ = [ PFTableViewMoneyItem itemWithTitle: NSLocalizedString( @"ORDERS_MARGIN", nil )
                                                                   amount: account_.blockedForOrders
                                                                precision: account_.precision
                                                                 currency: account_.currency
                                                                colorSign: NO ];
   
   NSArray* general_asset_items_ = [ @[trades_count_, volume_, fees_, orders_margin_] arrayByAddingObjectsFromArray: general_category_.items ];
   
   return [ self categoryWithTitle: nil items: general_asset_items_ ];
}

+(id)assetAccountCategoryWithAccount:( id< PFAccount > )account_
{
   PFAssetAccountsPickerItem* asset_account_ = [ [ PFAssetAccountsPickerItem alloc ] initWithAccount: account_ ];

   asset_account_.pickerAction = ^( PFTableViewBasePickerItem* picker_item_ )
   {
      PFAssetAccountsPickerItem* asset_account_picker_ = ( PFAssetAccountsPickerItem* )picker_item_;
      if ( account_.currAssetAccount != asset_account_picker_.selectedAssetAccount )
      {
         [ (PFAccount*)account_ setCurrAssetAccountFromId: asset_account_picker_.selectedAssetAccount.assetId ];
      }
   };
   
   return [ self categoryWithTitle: nil items: @[asset_account_] ];
}

@end
