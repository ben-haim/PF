#import "../PFTypes.h"

#import "Detail/PFObject.h"

#import "PFOrderType.h"
#import "PFMarketOperationType.h"
#import "PFSymbolConnection.h"

#import <Foundation/Foundation.h>

@protocol PFSymbol;
@protocol PFAccount;
@protocol PFOrder;

@protocol PFMarketOperation <PFSymbolId>

-(PFInteger)operationId;
-(PFInteger)orderId;

-(PFInteger)accountId;

-(PFDouble)amount;

-(PFOrderType)orderType;

-(PFMarketOperationType)operationType;

-(PFDouble)price;

-(PFDouble)stopLossPrice;
-(PFDouble)takeProfitPrice;

-(NSDate*)createdAt;

-(id<PFOrder>)stopLossOrder;
-(id<PFOrder>)takeProfitOrder;

-(id<PFSymbol>)symbol;
-(id<PFAccount>)account;

-(PFDouble)slTrailingOffset;
-(PFDouble)trailingOffset;

-(NSDate*)expirationDate;

@end

@protocol PFMutableMarketOperation <PFMarketOperation>

-(void)setAmount:( PFDouble )amount_;
-(void)setStopLossPrice:( PFDouble )price_;
-(void)setTakeProfitPrice:( PFDouble )price_;

-(void)setSlTrailingOffset:( PFDouble )sl_offset_;
-(void)setTrailingOffset:( PFDouble )sl_offset_;

@end

@protocol PFTrade;
@protocol PFOrder;
@protocol PFPosition;

extern id< PFTrade > PFMarketOperationAsTrade( id< PFMarketOperation > operation_ );
extern id< PFOrder > PFMarketOperationAsOrder( id< PFMarketOperation > operation_ );
extern id< PFPosition > PFMarketOperationAsPosition( id< PFMarketOperation > operation_ );

@interface PFMarketOperation : PFSymbolId< PFMutableMarketOperation, PFSymbolConnection >

@property ( nonatomic, assign ) PFInteger accountId;
@property ( nonatomic, assign ) PFInteger orderId;
@property ( nonatomic, assign ) PFDouble amount;
@property ( nonatomic, assign ) PFOrderType orderType;
@property ( nonatomic, assign ) PFMarketOperationType operationType;
@property ( nonatomic, assign ) PFDouble price;
@property ( nonatomic, assign ) PFDouble stopLossPrice;
@property ( nonatomic, assign ) PFDouble takeProfitPrice;

@property ( nonatomic, strong ) NSDate* createdAt;

@property ( nonatomic, strong, readonly ) id<PFSymbol> symbol;
@property ( nonatomic, unsafe_unretained, readonly ) id<PFAccount> account;

@property ( nonatomic, assign ) PFDouble slTrailingOffset;
@property ( nonatomic, assign ) PFDouble trailingOffset;

-(void)connectToAccount:( id< PFAccount > )account_;
-(void)disconnectFromAccount;

-(void)boundOrder:( id< PFOrder > )order_;
-(void)unboundOrder:( id< PFOrder > )order_;

-(void)bound:( BOOL )bound_ order:( id< PFOrder > )order_;

@end