#import "TradeRecord.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface TradeRecord ()

@property ( nonatomic, assign ) BOOL isOrder;

@end

@implementation TradeRecord

@synthesize row_type;
@synthesize order;
@synthesize login;
@synthesize open_time;
@synthesize close_time;
@synthesize cmd;
@synthesize symbol;
@synthesize volume;
@synthesize open_price;
@synthesize open_price_string;
@synthesize sl;
@synthesize tp;
@synthesize close_price;
@synthesize close_price_string;
@synthesize commission;
@synthesize storage;
@synthesize profit;
@synthesize comment;
@synthesize activation;
@synthesize execCommand;

@synthesize positionId;
@synthesize instrumentId;
@synthesize routeId;

@synthesize isOrder;

- (void)dealloc 
{
    [open_price_string release];
    [close_price_string release];
	[open_time release];
	[close_time release];	
	[symbol release];	
	[comment release];	
	[super dealloc];
}

-(NSString*)cmd_str
{
	switch (cmd)
	{
		case TradeRecordBuy:
			return @"buy";
		case TradeRecordSell:
			return @"sell";
		case TradeRecordBuyLimit:
			return @"buy limit";
		case TradeRecordSellLimit:
			return @"sell limit";
		case TradeRecordBuyStop:
			return @"buy stop";
		case TradeRecordSellStop:
			return @"sell stop";
		case TradeRecordBalance:
			return @"balance";
		case TradeRecordCredit:
			return @"credit";
		default:
			return nil;
	}
}

-(id)copyWithZone:( NSZone* )zone_
{
	TradeRecord *another = [ [ TradeRecord allocWithZone: zone_ ] init ];
	another.open_time = [ [self.open_time copyWithZone: zone_] autorelease ];
	another.close_time = [ [self.close_time copyWithZone: zone_] autorelease ];
	another.symbol = [ [self.symbol copyWithZone:zone_] autorelease ];
	another.comment = [ [self.comment copyWithZone:zone_] autorelease ];
	another.open_price_string = [ [self.open_price_string copyWithZone:zone_] autorelease ];
    another.close_price_string = [ [self.close_price_string copyWithZone:zone_] autorelease ];
   
   another.positionId = self.positionId;
   another.row_type = self.row_type;
   another.order = self.order;
   another.login = self.login;
   another.cmd = self.cmd;
   another.volume = self.volume;
	another.open_price = self.open_price;
	another.sl = self.sl;
	another.tp = self.tp;
	another.close_price = self.close_price;
	another.commission = self.commission;
	another.storage = self.storage;
	another.profit = self.profit;
	another.activation = self.activation;
	another.execCommand = self.execCommand;
   another.instrumentId = self.instrumentId;
   another.routeId = self.routeId;
   another.isOrder = self.isOrder;
   
	return another;
}

@end

@implementation TradeRecord (PFPosition)

+(id)tradeRecordWithPosition:( id< PFPosition > )position_
{
   TradeRecord* trade_ = [ self new ];
   
   trade_.positionId = position_.positionId;
   trade_.cmd = position_.operationType == PFMarketOperationBuy ? TradeRecordBuy : TradeRecordSell;

   trade_.order = position_.orderId;
   trade_.open_time = [ NSDate date ];

   trade_.volume = position_.amount;
   trade_.instrumentId = position_.instrumentId;
   trade_.symbol = position_.symbol.name;
   trade_.routeId = position_.routeId;

   trade_.open_price = position_.openPrice;
   trade_.sl = position_.stopLossPrice;
   trade_.tp = position_.takeProfitPrice;

   return [ trade_ autorelease ];
}

+(id)tradeRecordWithOrder:( id< PFOrder > )order_
{
   TradeRecordType cmd_ = TradeRecordUndefined;
   
   if ( order_.type == PFOrderMarket )
   {
      if ( order_.status == PFOrderStatusNew )
      {
         return nil;
      }
      else if ( order_.operationType == PFMarketOperationBuy )
      {
         cmd_ = TradeRecordBuy;
      }
      else
      {
         cmd_ = TradeRecordSell;
      }
   }
   else if ( order_.type == PFOrderLimit )
   {
      if ( order_.operationType == PFMarketOperationBuy )
      {
         cmd_ = TradeRecordBuyLimit;
      }
      else
      {
         cmd_ = TradeRecordSellLimit;
      }
   }
   else if ( order_.type == PFOrderStop )
   {
      if ( order_.operationType == PFMarketOperationBuy )
      {
         cmd_ = TradeRecordBuyStop;
      }
      else
      {
         cmd_ = TradeRecordSellStop;
      }
   }

   TradeRecord* trade_ = [ self new ];
   trade_.isOrder = YES;
   trade_.order = order_.orderId;
   trade_.open_time = order_.createdAt;
   trade_.cmd = cmd_;

   trade_.instrumentId = order_.instrumentId;
   trade_.routeId = order_.routeId;

   //!Check amount?
   trade_.volume = order_.amount;
   
   trade_.open_price = order_.price;

   trade_.symbol = order_.symbol.name;

   return [ trade_ autorelease ];
}

+(id)tradeRecordWithTradeReportRow:( NSDictionary* )row_
{
   TradeRecord *tr = [self new];
   tr.order = [ [ row_ objectForKey: @"orderid" ] integerValue ];

   tr.symbol = [ NSString stringWithFormat: @"%@:%@", [ row_ objectForKey: @"instrumentname" ], [ row_ objectForKey: @"routename" ] ];

   //!TODO add locale
   NSDateFormatter* date_formatter_ = [ [ NSDateFormatter alloc ] init ];
   [ date_formatter_ setDateFormat: @"dd-MM-yyyy HH:mm:SSS" ];

   tr.open_time = [ date_formatter_ dateFromString: [ row_ objectForKey: @"time" ] ];

   tr.cmd = [ [ row_ objectForKey: @"operation" ] isEqual: @"BUY" ] ? TradeRecordBuy : TradeRecordSell;

   tr.symbol =[ NSString stringWithFormat: @"%@:%@", [ row_ objectForKey: @"instrumentname" ], [ row_ objectForKey: @"routename" ] ];

   tr.volume = [ [ row_ objectForKey: @"amount" ] doubleValue ];
   tr.open_price = [ [ row_ objectForKey: @"price" ] doubleValue ];
   tr.open_price_string = [ row_ objectForKey: @"price" ];
   tr.commission = [ [ row_ objectForKey: @"commission" ] doubleValue ];
   tr.profit = [ [ row_ objectForKey: @"profit" ] doubleValue ];

   return [tr autorelease];
}

@end

