#import "../PFTypes.h"

#import "PFMarketOperation.h"

#import <Foundation/Foundation.h>

@protocol PFMutablePosition;

@protocol PFPosition <PFMarketOperation>

-(PFInteger)positionId;
-(PFDouble)openPrice;
-(PFDouble)closePrice;
-(PFDouble)commission;
-(PFDouble)swap;
-(PFInteger)stopLossOrderId;
-(PFInteger)takeProfitOrderId;

-(PFDouble)grossPl;
-(PFDouble)netPl;
-(PFDouble)plTicks;

-(PFDouble)holdMargin;
-(PFDouble)openCrossPrice;
-(PFDouble)exposure;

-(id<PFMutablePosition>)mutablePosition;

@end

@protocol PFMutablePosition< PFMutableMarketOperation, PFPosition >

@end

@interface PFPosition : PFMarketOperation< PFMutablePosition >

@property ( nonatomic, assign ) PFInteger positionId;

@property ( nonatomic, assign ) PFInteger stopLossOrderId;
@property ( nonatomic, assign ) PFInteger takeProfitOrderId;

@property ( nonatomic, assign ) PFDouble openPrice;
@property ( nonatomic, assign ) PFDouble closePrice;

@property ( nonatomic, assign ) PFDouble commission;
@property ( nonatomic, assign ) PFDouble swap;

@property ( /*nonatomic, */assign ) PFDouble profitUSD;
@property ( /*nonatomic, */assign ) PFDouble netProfitUSD;

@property ( nonatomic, assign ) PFDouble openCrossPrice;

@property ( nonatomic, assign ) PFDouble grossPl;
@property ( nonatomic, assign ) PFDouble netPl;
@property ( nonatomic, assign ) PFDouble plTicks;

@property ( nonatomic, assign, readonly ) PFDouble holdMargin;

@property ( nonatomic, assign ) PFDouble exposure;

-(BOOL)isEqualToPosition:( PFPosition* )position_;

@end
