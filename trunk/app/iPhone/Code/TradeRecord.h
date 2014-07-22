#import <ProFinanceApi/PFTypes.h>

#import <Foundation/Foundation.h>

typedef enum
{
   TradeRecordUndefined = -1
   , TradeRecordBuy
   , TradeRecordSell
   , TradeRecordBuyLimit
   , TradeRecordSellLimit
   , TradeRecordBuyStop
   , TradeRecordSellStop
   , TradeRecordBalance
   , TradeRecordCredit
} TradeRecordType;

@interface TradeRecord : NSObject< NSCopying >

@property( assign) int row_type;
@property( assign) int order;
@property( assign) int login;
@property( nonatomic, retain) NSDate* open_time;
@property( nonatomic, retain) NSDate* close_time;
@property( assign) TradeRecordType cmd;
@property( nonatomic, retain) NSString *symbol;
@property( assign) double volume;
@property( assign) double open_price;
@property( nonatomic, retain) NSString *open_price_string;
@property( assign) double sl;
@property( assign) double tp;
@property( assign) double close_price;
@property( nonatomic, retain) NSString *close_price_string;
@property( assign) double commission;
@property( assign) double storage;
@property( assign) double profit;
@property( nonatomic, retain) NSString *comment;
@property( assign) int activation;
@property( assign) int execCommand;
@property ( nonatomic, assign ) PFInteger positionId;
@property ( nonatomic, assign ) PFInteger instrumentId;
@property ( nonatomic, assign ) PFInteger routeId;
@property ( nonatomic, assign, readonly ) BOOL isOrder;

-(NSString*)cmd_str;

@end

@protocol PFPosition;
@protocol PFOrder;

@interface TradeRecord (PFPosition)

+(id)tradeRecordWithPosition:( id< PFPosition > )position_;
+(id)tradeRecordWithOrder:( id< PFOrder > )order_;
+(id)tradeRecordWithTradeReportRow:( NSDictionary* )row_;

@end
