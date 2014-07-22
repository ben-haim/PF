#import "../PFTypes.h"

#import <Foundation/Foundation.h>

@protocol PFAccount;

@protocol PFAccounts <NSObject>

-(NSArray*)accounts;

-(NSArray*)allOrders;
-(NSArray*)allActiveOrders;
-(NSArray*)allPositions;
-(NSArray*)allTrades;
-(NSArray*)allOperations;
+(NSArray*)sortedOrdersByDateCreatedWithArray: (NSArray*)sort_array_;

-(id< PFAccount >)defaultAccount;
-(NSString*)accountNameWithId:( PFInteger )account_id_;

@end

@protocol PFAccountsDelegate;
@protocol PFPositionsDelegate;
@protocol PFOrdersDelegate;
@protocol PFTradesDelegate;

@class PFMessage;
@class PFPosition;
@class PFOrder;
@class PFInstruments;
@class PFPositions;
@class PFOrders;
@class PFSymbols;
@class PFRule;

@interface PFAccounts : NSObject< PFAccounts >

@property ( nonatomic, strong, readonly ) NSArray* accounts;
@property ( nonatomic, strong ) id< PFAccount > defaultAccount;
@property ( nonatomic, strong ) NSMutableDictionary* pammStatuses;

@property ( nonatomic, strong, readonly ) PFPositions* positions;
@property ( nonatomic, strong, readonly ) PFOrders* orders;

-(id)initWithUserId:( PFInteger )user_id_
        instruments:( PFInstruments* )instruments_;

-(void)updateAccountWithMessage:( PFMessage* )message_
                       delegate:( id< PFAccountsDelegate > )delegate_;

-(void)updatePammAccountStatusesWithMessage:( PFMessage* )message_
                                   delegate:( id< PFAccountsDelegate > )delegate_;

-(void)updatePositionWithMessage:( PFMessage* )message_
                        delegate:( id< PFPositionsDelegate > )delegate_;

-(void)updateOrderWithMessage:( PFMessage* )message_
                     delegate:( id< PFOrdersDelegate > )delegate_;

-(void)updateTradeWithMessage:( PFMessage* )message_
                     delegate:( id< PFTradesDelegate > )delegate_;

-(void)updateOrder:( PFOrder* )order_
          delegate:( id< PFOrdersDelegate > )delegate_;

-(void)removePosition:( PFPosition* )position_
             delegate:( id< PFPositionsDelegate > )delegate_;

-(void)connectToSymbols:( PFSymbols* )symbols_;

-(void)addRule:( PFRule* )rule_ withTransferFinished:( BOOL )transfer_finished_;
-(void)removeRule:( PFRule* )rule_;
-(PFRule*)getRuleByName:(NSString*) ruleName andAccountId:(int) acId;



@end


@class PFAccount;

@protocol PFAccountsDelegate< NSObject >

-(void)accounts:( PFAccounts* )accounts_
didUpdateAccount:( PFAccount* )account_;

-(void)accounts:( PFAccounts* )accounts_
  didAddAccount:( PFAccount* )account_;

@end