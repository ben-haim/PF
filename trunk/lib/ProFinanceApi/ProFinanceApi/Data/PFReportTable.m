#import "PFReportTable.h"

@interface PFReportTable ()

@property ( nonatomic, strong ) NSArray* header;
@property ( nonatomic, strong ) NSMutableArray* mutableRows;

@end

@implementation PFReportTable

@synthesize name;
@synthesize date;
@synthesize dialog;
@synthesize header;
@synthesize mutableRows = _mutableRows;

@dynamic rows;

//+(NSString*)reportLocalizatedStringWithValue:( NSString* )value_
//{
//   return NSLocalizedString([PFReportTable reportLocalizatedKeyWithValue: value_], nil);
//}


//#warning For convert localization keys to polish
//+(NSString*)reportLocalizatedKeyWithValue:( NSString* )value_
//{
//   static NSArray* names_mapping_ = nil;
//
//   if ( !names_mapping_ )
//   {
//      names_mapping_ = [[NSArray alloc] initWithObjects: //Keys for header
//         @"Delayed Stop Order Removed" , @"event_Delayed_Stop_Order_Removed",
//         @"Delayed Limit Order Created" , @"event_Delayed_Limit_Order_Created",
//         @"Delayed Stop Order Created" , @"event_Delayed_Stop_Order_Created",
//         @"Delayed OCO Order Created" , @"event_Delayed_OCO_Order_Created",
//         @"Delayed Limit Order Modified" , @"event_Delayed_Limit_Order_Modified",
//         @"Delayed Stop Order Modified" , @"event_Delayed_Stop_Order_Modified",
//         @"Stop Limit Order Created" , @"event_Stop_Limit_Order_Created",
//         @"Stop Limit Order Modified" , @"event_Stop_Limit_Order_Modified",
//         @"Stop Limit Order Removed" , @"event_Stop_Limit_Order_Removed",
//         @"Trailing Stop Order Created" , @"event_Trailing_Stop_Order_Created",
//         @"Trailing Stop Order Modified" , @"event_Trailing_Stop_Order_Modified",
//         @"Trailing Stop Order Removed" , @"event_Trailing_Stop_Order_Removed",
//         @"Delayed Stop Limit Order Created" , @"event_Delayed_Stop_Limit_Order_Created",
//         @"Delayed Stop Limit Order Modified" , @"event_Delayed_Stop_Limit_Order_Modified",
//         @"Delayed Stop Limit Order Removed" , @"event_Delayed_Stop_Limit_Order_Removed",
//         @"Delayed Trailing Stop Order Created" , @"event_Delayed_Trailing_Stop_Order_Created",
//         @"Delayed Trailing Stop Order Modified" , @"event_Delayed_Trailing_Stop_Order_Modified",
//         @"Delayed Trailing Stop Order Removed" , @"event_Delayed_Trailing_Stop_Order_Removed",
//         @"Limit Order Removed" , @"event_Limit_Order_Removed",
//         @"Stop Order Removed" , @"event_Stop_Order_Removed",
//         @"Stop Order Removed" , @"event_Stop_Order_Removed",
//         @"Limit Order Created" , @"event_Limit_Order_Created",
//         @"Stop Order Created" , @"event_Stop_Order_Created",
//         @"OCO Order Created" , @"event_OCO_Order_Created",
//         @"Stop Order Removed" , @"event_Stop_Order_Removed",
//         @"Tr.SL Order Removed" , @"event_Tr_SL_Order_Removed",
//         @"Stop Order Removed" , @"event_Stop_Order_Removed",
//         @"Limit Order Created" , @"event_Limit_Order_Created",
//         @"Stop Order Created" , @"event_Stop_Order_Created",
//         @"OCO Order Created" , @"event_OCO_Order_Created",
//         @"Limit Order Modified" , @"event_Limit_Order_Modified",
//         @"Stop Order Modified" , @"event_Stop_Order_Modified",
//         @"Position Opened" , @"event_Position_Opened",
//         @"TP Order Modified" , @"event_TP_Order_Modified",
//         @"SL Order Modified" , @"event_SL_Order_Modified",
//         @"Position Closed" , @"event_Position_Closed",
//         @"Order placing request" , @"event_Order_placing_request",
//         @"Position Closed (TP)" , @"event_Position_Closed_TP",
//         @"Position Closed (SL)" , @"event_Position_Closed_SL",
//         @"Trade executed (Mutual)" , @"event_Trade_executed_Mutual",
//         @"Fill Market Order" , @"event_Fill_Market_Order",
//         @"Market Order Modified" , @"event_Market_Order_Modified",
//         @"Margin Call Reached" , @"event_Margin_Call_Reached",
//         @"Margin Call Warning." , @"event_Margin_Call_Warning",
//         @"Account operation confirmation." , @"event_Account_operation_confirmation",
//         @"Market Order Removed" , @"event_Market_Order_Removed",
//         @"Not enough Margin to open position" , @"event_Not_enough_Margin_to_open_position",
//         @"Trade executed" , @"event_Trade_executed",
//         @"SL Order Removed" , @"event_SL_Order_Removed",
//         @"TP Order Removed" , @"event_TP_Order_Removed",
//         @"SL Order Created" , @"event_SL_Order_Created",
//         @"TP Order Created" , @"event_TP_Order_Created",
//         @"Trailing Stop Order Created" , @"event_Trailing_Stop_Order_Created",
//         @"POSITION MODIFIED" , @"event_POSITION_MODIFIED",
//         @"Market Close Order Removed" , @"event_Market_Close_Order_Removed",
//         @"Position Opened (Limit Order)" , @"event_Position_Opened_Limit_Order",
//         @"Informational message" , @"event_Informational_message",
//         @"Trade executed (SL)" , @"event_Trade_executed_SL",
//         @"Order Modified" , @"event_Order_Modified",
//         @"Fill Close Market Order" , @"event_Fill_Close_Market_Order",
//         @"Fill Market Order" , @"event_Fill_Market_Order",
//         @"Fill Close Market Order (Mutual)" , @"event_Fill_Close_Market_Order_Manual",
//         @"Fill Market Order (Mutual)" , @"event_Fill_Market_Order_Manual",
//         @"Fill Close Limit Order" , @"event_Fill_Close_Limit_Order",
//         @"Fill Limit Order" , @"event_Fill_Limit_Order",
//         @"Fill Close Stop Order" , @"event_Fill_Close_Stop_Order",
//         @"Fill Close Traling Stop Order" , @"event_Fill_Close_Traling_Stop_Order",
//         @"Fill Stop Order" , @"event_Fill_Stop_Order",
//         @"Fill Traling Stop Order" , @"event_Fill_Traling_Stop_Order",
//         @"Fill Stop Limit Order" , @"event_Fill_Stop_Limit_Order",
//         @"Partially Reject Close Market Order" , @"event_Partially_Reject_Close_Market_Order",
//         @"Partially Reject Market Order" , @"event_Partially_Reject_Market_Order",
//         @"Partially Reject Close Limit Order" , @"event_Partially_Reject_Close_Limit_Order",
//         @"Partially Reject Limit Order" , @"event_Partially_Reject_Limit_Order",
//         @"Partially Reject Close Stop Order" , @"event_Partially_Reject_Close_Stop_Order",
//         @"Partially Reject Close Traling Stop Order" , @"event_Partially_Reject_Close_Traling_Stop_Order",
//         @"Partially Reject Stop Order" , @"event_Partially_Reject_Stop_Order",
//         @"Partially Reject Traling Stop Order" , @"event_Partially_Reject_Traling_Stop_Order",
//         @"Partially Reject Stop Limit Order" , @"event_Partially_Reject_Stop_Limit_Order",
//         @"Fill Stop Limit Order" , @"event_Fill_Stop_Limit_Order",
//         @"SL Order Modified" , @"event_SL_Order_Modified",
//         @"TP Order Modified" , @"event_TP_Order_Modified",
//         @"Market Close Order Modified" , @"event_Market_Close_Order_Modified",
//         @"Close Market Order Created" , @"event_Close_Market_Order_Created",
//         @"Market Order Created" , @"event_Market_Order_Created",
//         @"Fund processing failed." , @"event_Fund_processing_failed",
//         @"Limit order Filled" , @"event_Limit_order_Filled",
//         @"Stop order Filled" , @"event_Stop_order_Filled",
//         @"StopLimit order Filled" , @"event_StopLimit_order_Filled",
//         @"Market_order_Filled" , @"event_Market_order_Filled",
//         @"Limit_order_Filled_Mutual" , @"event_Limit_order_Filled_Mutual",
//         @"Stop_order_Filled_Mutual" , @"event_Stop_order_Filled_Mutual",
//         @"StopLimit_order_Filled_Mutual" , @"event_StopLimit_order_Filled_Mutual",
//         @"Market order Filled Mutual" , @"event_Market_order_Filled_Mutual",
//         @"Limit order Filled (Stop Order)" , @"event_Limit_order_Filled_Stop_Order",
//         @"Stop order Filled (Stop Order)" , @"event_Stop_order_Filled_Stop_Order",
//         @"StopLimit order Filled (Stop Order)" , @"event_StopLimit_order_Filled_Stop_Order",
//         @"Market order Filled (Stop Order)" , @"event_Market_order_Filled_Stop_Order",
//         @"Limit order Filled (Trailing Stop Order)" , @"event_Limit_order_Filled_Trailing_Stop_Order",
//         @"Stop order Filled (Trailing Stop Order)" , @"event_Stop_order_Filled_Trailing_Stop_Order",
//         @"StopLimit order Filled (Trailing Stop Order)" , @"event_StopLimit_order_Filled_Trailing_Stop_Order",
//         @"Market order Filled (Trailing Stop Order)" , @"event_Market_order_Filled_Trailing_Stop_Order",
//         @"Limit order Filled (Limit Order)" , @"event_Limit_order_Filled_Limit_Order",
//         @"Stop order Filled (Limit Order)" , @"event_Stop_order_Filled_Limit_Order",
//         @"StopLimit order Filled (Limit Order)" , @"event_StopLimit_order_Filled_Limit_Order",
//         @"Market order Filled (Limit Order)" , @"event_Market_order_Filled_Limit_Order",
//         @"Position Closed" , @"event_Position_Closed",
//         @"Trade executed" , @"event_Trade_executed",
//         @"Position Closed (Mutual)" , @"event_Position_Closed_mutual",
//         @"Trade executed (Mutual)" , @"event_Trade_executed_mutual",
//         @"Position Closed (Margin Call)" , @"event_Position_Closed_margin_call",
//         @"Trade executed (Margin Call)" , @"event_Trade_executed_margin_call",
//         @"Position Closed (Option Expired)" , @"event_Position_Closed_Option_Expired",
//         @"Trade executed (Option Expired)" , @"event_Trade_executed_Option_Expired",
//         @"Position Closed (SL)" , @"event_Position_Closed_SL",
//         @"Trade executed (SL)" , @"event_Trade_executed_SL",
//         @"Position Closed (TrSL)" , @"event_Position_Closed_TrSL",
//         @"Trade executed (TrSL)" , @"event_Trade_executed_TrSL",
//         @"Position Closed (TP)" , @"event_Position_Closed_TP",
//         @"Trade executed (TP)" , @"event_Trade_executed_TP",
//
//
//         //Keys for value
//         @"User" , @"event_User",
//         @"Account" , @"event_Account",
//         @"Order number" , @"event_Order_Number",
//         @"Instrument" , @"event_Instrument",
//         @"Amount" , @"event_Amount",
//         @"Operation" , @"event_Operation",
//         @"Average filled price" , @"event_Average_Filled_Price",
//         @"Last fill price" , @"event_Last_Fill_Price",
//         @"Time" , @"event_Time",
//         @"Sell" , @"event_Sell",
//         @"Buy" , @"event_Buy",
//         @"Position number" , @"event_Position_number",
//         @"Price" , @"event_Price",
//         @"Margin Call" , @"event_Margin_Call",
//         @"Stop Out Type" , @"event_Stop_out_type",
//         @"Deposit" , @"event_Deposit",
//         @"Message" , @"event_Message",
//         @"Please deposit on your account." , @"event_Please_deposit_on_your_account",
//         @"Fund User" , @"event_Fund_user",
//         @"Fund Account" , @"event_Fund_account",
//         @"Investor User" , @"event_Investor_user",
//         @"Investor Account" , @"event_Investor_account",
//         @"Share Price" , @"event_Share_Price",
//         @"Pending Shares" , @"event_Pending_Shares",
//         @"Pending Capital" , @"event_Pending_Capital",
//         @"Pending Gross P/L" , @"event_Pending_Gross_P_L",
//         @"Event" , @"event_Event",
//         @"Can't finish investment period" , @"event_Cant_finish_investment_period",
//         @"Can't perform rollover" , @"event_Cant_perform_rollover",
//         @"Notification" , @"event_Notification",
//         @"Share Price" , @"event_Share_Price",
//         @"Reason" , @"event_Reason",
//         @"Account Name" , @"event_Account_Name",
//         @"Counter Account Name" , @"event_Counter_Account_Name",
//         @"Operation Id" , @"event_Operation_Id",
//         @"Counter Operation Id" , @"event_Counter_Operation_Id",
//         @"Operation Type" , @"event_Operation_Type",
//         @"Sum" , @"event_Sum",
//         @"Basis" , @"event_Basis",
//         @"Open lots" , @"event_Open_lots",
//         @"Lots to open" , @"event_Lots_to_open",
//         @"Commission" , @"event_Commission",
//         @"Available funds" , @"event_Available_funds",
//         @"Init margin req." , @"event_Init_margin_req",
//         @"Minimum Open Margin" , @"event_Minimum_Open_Margin",
//         @"Current Balance" , @"event_Current_Balance",
//         @"Required Balance" , @"event_Required_Balance",
//         @"Open lots" , @"event_Open_lots",
//         @"Comission" , @"event_Commission",
//         @"Operation" , @"event_Operation",
//         @"Avg.Price" , @"event_Avg_Price",
//         @"SL trailing offset" , @"event_SL_trailing_offset",
//         @"SL price" , @"event_SL_price",
//         @"TP price" , @"event_TP_price",
//         @"Open order type" , @"event_Open_order_type",
//         @"Commissions" , @"event_Commissions",
//         @"Modifyied by" , @"event_Modifyied_by",
//         @"Position number" , @"event_Position_number",
//         @"Open date" , @"event_Open_date",
//         @"Open price" , @"event_Open_price",
//         @"Close order type" , @"event_Close_order_type",
//         @"Realised profit/loss" , @"event_Realised_profit_loss",
//         @"Market" , @"event_Market",
//         @"Limit" , @"event_Limit",
//         @"Stop" , @"event_Stop",
//         @"Traling Stop" , @"event_Traling_Stop",
//         @"Stop Limit" , @"event_Stop_Limit",
//         @"Unknown" , @"event_Unknown",
//         @"Route Name" , @"event_Route_Name",
//         @"Refused Amount" , @"event_Refused_Amount",
//         @"Bound To" , @"event_Bound_To",
//         @"Route" , @"event_Route",
//         @"Limit price" , @"event_Limit_price",
//         @"Stop price" , @"event_Stop_price",
//         @"Order price" , @"event_Order_price",
//         @"Type" , @"event_Type",
//         @"Stop-loss" , @"event_Stop_loss",
//         @"Take-profit" , @"event_Take_profit",
//         @"SettleDate" , @"event_SettleDate", nil
//      ];
//
//      int i = 0;
//      NSString* s;
//      for (NSString* key_ in names_mapping_ )
//      {
//         if (i==0) s = [NSString stringWithFormat: @"\"%@\" = \"", key_];
//         if (i==1)
//         {
//            s = [s stringByAppendingFormat: @"%@\";", NSLocalizedString(key_, nil)];
//            NSLog(@"%@", s);
//         }
//         i++;
//         i%=2;
//      }
//   }
//   return nil;//[ names_mapping_ objectForKey: value_ ];
//}

-(NSArray*)rows
{
   return self.mutableRows;
}

-(NSMutableArray*)mutableRows
{
   if ( !_mutableRows )
   {
      _mutableRows = [ NSMutableArray new ];
   }
   return _mutableRows;
}

-(void)addRow:( NSArray* )values_
{
   //First row is header
   if ( !self.header )
   {
      self.header = values_;
   }
   else
   {
      NSAssert( [ values_ count ] == [ self.header count ], @"Invalid table" );

      NSMutableDictionary* row_ = [ NSMutableDictionary dictionaryWithCapacity: [ values_ count ] ];

      for ( NSUInteger i_ = 0; i_ < [ self.header count ]; ++i_ )
      {
         NSString* key_ = [ self.header objectAtIndex: i_ ];
         NSString* value_ = [ values_ objectAtIndex: i_ ];

         [ row_ setObject: value_ forKey: key_ ];
      }

      [ self.mutableRows addObject: row_ ];
   }
}

-(NSString*)description
{
   return [ self.mutableRows description ];
}

+(id)reportWithString:( NSString* )message_
{
   PFReportTable* report_ = [ PFReportTable new ];

   report_.name = message_;
   report_.date = [ NSDate date ];
   report_.dialog = @"";
   report_.header = [ NSArray arrayWithObjects: @"Title", @"Value", nil ];
   [ report_.mutableRows addObject: [ NSDictionary dictionaryWithObjectsAndKeys: @"Event:", @"Title", message_, @"Value", nil ] ];

   return report_;
}

@end
