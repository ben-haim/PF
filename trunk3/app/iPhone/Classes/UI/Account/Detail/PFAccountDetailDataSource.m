#import "PFAccountDetailDataSource.h"

#import "PFAccountDetailCell.h"
#import "PFAccountDetailRow.h"

#import "PFTraderLocalizedString.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFAccountDetailDataSource ()

@property ( nonatomic, strong ) NSArray* rows;

@end

@implementation PFAccountDetailDataSource

@synthesize rows = _rows;

@dynamic numberOfRows;

-(void)dealloc
{
   [ _rows release ];
   
   [ super dealloc ];
}

-(id)initWithRows:( NSArray* )rows_
{
   self = [ super init ];
   if ( self )
   {
      self.rows = rows_;
   }
   return self;
}

+(id)dataSourceWithRows:( NSArray* )rows_
{
   return [ [ [ self alloc ] initWithRows: rows_ ] autorelease ];
}

+(id)todayDataSource
{
   PFAccountDetailRow* gross_pl_ = [ PFAccountDetailRow rowWithTitle: PFTraderLocalizedString( @"GROSS_PL", nil )
                                                         initializer: ^( PFAccountDetailCell* cell_, id< PFAccount > account_ )
                                    {
                                       cell_.valueLabel.text = [ NSString stringWithFormat: @"%f", account_.grossPl ];
                                    }];
   
   PFAccountDetailRow* net_pl_ = [ PFAccountDetailRow rowWithTitle: PFTraderLocalizedString( @"NET_PL", nil )
                                                       initializer: ^( PFAccountDetailCell* cell_, id< PFAccount > account_ )
                                  {
                                     cell_.valueLabel.text = [ NSString stringWithFormat: @"%f", account_.netPl ];
                                  }];
   
   PFAccountDetailRow* fees_ = [ PFAccountDetailRow rowWithTitle: PFTraderLocalizedString( @"FEES", nil )
                                                     initializer: ^( PFAccountDetailCell* cell_, id< PFAccount > account_ )
                                {
                                   cell_.valueLabel.text = [ NSString stringWithFormat: @"%f", account_.todayFees ];
                                }];
   
   PFAccountDetailRow* volume_ = [ PFAccountDetailRow rowWithTitle: PFTraderLocalizedString( @"VOLUME", nil )
                                                       initializer: ^( PFAccountDetailCell* cell_, id< PFAccount > account_ )
                                  {
                                     cell_.valueLabel.text = [ NSString stringWithFormat: @"%f", account_.amount ];
                                  }];
   
   PFAccountDetailRow* trades_count_ = [ PFAccountDetailRow rowWithTitle: PFTraderLocalizedString( @"TRADES", nil )
                                                             initializer: ^( PFAccountDetailCell* cell_, id< PFAccount > account_ )
                                        {
                                           cell_.valueLabel.text = [ NSString stringWithFormat: @"%d", account_.tradesCount ];
                                        }];

   NSArray* today_rows_ = [ NSArray arrayWithObjects: gross_pl_, net_pl_, fees_, volume_, trades_count_, nil ];

   return [ self dataSourceWithRows: today_rows_ ];
}

+(id)activityDataSource
{
   PFAccountDetailRow* gross_pl_ = [ PFAccountDetailRow rowWithTitle: PFTraderLocalizedString( @"OPEN_GROSS_PL", nil )
                                                         initializer: ^( PFAccountDetailCell* cell_, id< PFAccount > account_ )
                                    {
                                       cell_.valueLabel.text = @"-";
                                    }];
   
   PFAccountDetailRow* net_pl_ = [ PFAccountDetailRow rowWithTitle: PFTraderLocalizedString( @"OPEN_NET_PL", nil )
                                                       initializer: ^( PFAccountDetailCell* cell_, id< PFAccount > account_ )
                                  {
                                     cell_.valueLabel.text = @"-";
                                  }];
   
   PFAccountDetailRow* orders_ = [ PFAccountDetailRow rowWithTitle: PFTraderLocalizedString( @"N_ORDERS", nil )
                                                       initializer: ^( PFAccountDetailCell* cell_, id< PFAccount > account_ )
                                  {
                                     cell_.valueLabel.text = @"-";
                                  }];
   
   PFAccountDetailRow* positions_ = [ PFAccountDetailRow rowWithTitle: PFTraderLocalizedString( @"N_POSITIONS", nil )
                                                          initializer: ^( PFAccountDetailCell* cell_, id< PFAccount > account_ )
                                     {
                                        cell_.valueLabel.text = @"-";
                                     }];
   
   PFAccountDetailRow* orders_margin_ = [ PFAccountDetailRow rowWithTitle: PFTraderLocalizedString( @"ORDERS_MARGIN", nil )
                                                              initializer: ^( PFAccountDetailCell* cell_, id< PFAccount > account_ )
                                         {
                                            cell_.valueLabel.text = [ NSString stringWithFormat: @"%f", account_.ordersMargin ];
                                         }];
   
   PFAccountDetailRow* positions_margin_ = [ PFAccountDetailRow rowWithTitle: PFTraderLocalizedString( @"POSITIONS_MARGIN", nil )
                                                                 initializer: ^( PFAccountDetailCell* cell_, id< PFAccount > account_ )
                                            {
                                               cell_.valueLabel.text = @"-";
                                            }];
   
   PFAccountDetailRow* funds_ = [ PFAccountDetailRow rowWithTitle: PFTraderLocalizedString( @"BLOCKED_FOR_FUNDS", nil )
                                                      initializer: ^( PFAccountDetailCell* cell_, id< PFAccount > account_ )
                                 {
                                    cell_.valueLabel.text = [ NSString stringWithFormat: @"%f", account_.blockedFunds ];
                                 }];
   
   PFAccountDetailRow* stock_value_ = [ PFAccountDetailRow rowWithTitle: PFTraderLocalizedString( @"STOCK_VALUE", nil )
                                                            initializer: ^( PFAccountDetailCell* cell_, id< PFAccount > account_ )
                                       {
                                          cell_.valueLabel.text = @"-";
                                       }];
   
   NSArray* activity_rows_ = [ NSArray arrayWithObjects: gross_pl_, net_pl_, orders_, positions_, orders_margin_, positions_margin_, funds_, stock_value_, nil ];

   return [ self dataSourceWithRows: activity_rows_ ];
}

+(id)generalDataSource
{
   PFAccountDetailRow* balance_ = [ PFAccountDetailRow rowWithTitle: PFTraderLocalizedString( @"ACCOUNT_BALANCE", nil )
                                                        initializer: ^( PFAccountDetailCell* cell_, id< PFAccount > account_ )
                                   {
                                      cell_.valueLabel.text = [ NSString stringWithFormat: @"%f", account_.balance ];
                                   }];
   
   PFAccountDetailRow* equity_ = [ PFAccountDetailRow rowWithTitle: PFTraderLocalizedString( @"ACCOUNT_EQUITY", nil )
                                                       initializer: ^( PFAccountDetailCell* cell_, id< PFAccount > account_ )
                                  {
                                     cell_.valueLabel.text = @"-";
                                  }];
   
   PFAccountDetailRow* value_ = [ PFAccountDetailRow rowWithTitle: PFTraderLocalizedString( @"ACCOUNT_VALUE", nil )
                                                      initializer: ^( PFAccountDetailCell* cell_, id< PFAccount > account_ )
                                 {
                                    cell_.valueLabel.text = @"-";
                                 }];
   
   PFAccountDetailRow* blocked_balance_ = [ PFAccountDetailRow rowWithTitle: PFTraderLocalizedString( @"BLOCKED_BALANCE", nil )
                                                                initializer: ^( PFAccountDetailCell* cell_, id< PFAccount > account_ )
                                           {
                                              cell_.valueLabel.text = [ NSString stringWithFormat: @"%f", account_.blockedBalance ];
                                           }];
   
   PFAccountDetailRow* cash_balance_ = [ PFAccountDetailRow rowWithTitle: PFTraderLocalizedString( @"CASH_BALANCE", nil )
                                                             initializer: ^( PFAccountDetailCell* cell_, id< PFAccount > account_ )
                                        {
                                           cell_.valueLabel.text = [ NSString stringWithFormat: @"%f", account_.cashBalance ];
                                        }];

   NSArray* general_rows_ = [ NSArray arrayWithObjects: balance_, equity_, value_, blocked_balance_, cash_balance_, nil ];

   return [ self dataSourceWithRows: general_rows_ ];
}

-(NSUInteger)numberOfRows
{
   return [ self.rows count ];
}

-(UITableViewCell*)cellForAccount:( id< PFAccount > )account_
                        tableView:( UITableView* )table_view_
                              row:( NSUInteger )row_
{
   static NSString* cell_identifier_ = @"PFAccountDetailCell";
   PFAccountDetailCell *cell_ = (PFAccountDetailCell*)[ table_view_ dequeueReusableCellWithIdentifier: cell_identifier_ ];

   if ( !cell_ )
   {
      cell_ = [ PFAccountDetailCell accountDetailCell ];
   }

   PFAccountDetailRow* account_row_ = [ self.rows objectAtIndex: row_ ];

   [ account_row_ initializeCell: cell_ account: account_ ];

   return cell_;
}

@end
