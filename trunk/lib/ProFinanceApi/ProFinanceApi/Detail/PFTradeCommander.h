#import "PFCommander.h"

#import "../PFTypes.h"

#import "../Data/PFDoneBlockDefs.h"

#import <Foundation/Foundation.h>

@protocol PFOrder;
@protocol PFPosition;
@protocol PFMarketOperation;
@protocol PFChatMessage;
@protocol PFSearchCriteria;

@protocol PFTradeCommander <PFCommander>

-(void)reportTableForAccountWithId:( PFInteger )account_id_
                          criteria:( id< PFSearchCriteria > )criteria_
                         doneBlock:( PFReportDoneBlock )done_block_;

-(void)createOrder:( id< PFOrder > )order_;

-(void)replaceOrder:( id< PFOrder > )order_
      withDoneBlock:( PFReplaceOrderDoneBlock )done_block_;

-(void)cancelOrder:( id< PFOrder > )order_;

-(void)closePosition:( id< PFPosition > )position_;

-(void)withdrawalForAccountId:( PFInteger )account_id_
                    andAmount:( PFDouble )amount_;

-(void)transferFromAccountId:( PFInteger )from_account_id_
                 toAccountId:( PFInteger )to_account_id_
                      amount:( PFDouble )amount_;

-(void)updateMarketOperation:( id< PFMarketOperation > )market_operation_
               stopLossPrice:( PFDouble )stop_loss_price_
              stopLossOffset:( PFDouble )stop_loss_offset_;

-(void)updateMarketOperation:( id< PFMarketOperation > )market_operation_
             takeProfitPrice:( PFDouble )take_profit_price_;

-(void)storiesForAccountWithId:( PFInteger )account_id_
                      fromDate:( NSDate* )from_date_
                        toDate:( NSDate* )to_date_;

-(void)sendChatMessage:( id< PFChatMessage > )message_
      forAccountWithId:( PFInteger )account_id_;

@end
