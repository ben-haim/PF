#import "PFAccounts.h"

#import "PFAccount.h"

#import "PFOrder.h"
#import "PFOrders.h"
#import "PFPosition.h"
#import "PFPositions.h"
#import "PFTrade.h"
#import "PFTrades.h"
#import "PFOrderHistory.h"
#import "PFPammInvestor.h"
#import "PFPammAccountStatus.h"

#import "PFRule.h"

#import "PFField.h"
#import "PFMessage.h"
#import "PFMetaObject.h"

#import "NSString+PFUserPath.h"

@interface PFAccounts ()

@property ( nonatomic, strong ) NSMutableDictionary* accountsById;
@property ( nonatomic, strong ) id< PFAccount > userAccount;
@property ( nonatomic, strong ) NSString* fileName;

@property ( nonatomic, strong ) PFInstruments* instruments;
@property ( nonatomic, strong ) PFPositions* positions;
@property ( nonatomic, strong ) PFOrders* orders;
@property ( nonatomic, strong ) PFTrades* trades;

@end
//also can contains useId and usergroupId
@implementation PFAccounts

@synthesize accountsById = _accountsById;
@synthesize userAccount = _userAccount;
@synthesize fileName;
@synthesize pammStatuses;

@synthesize instruments;
@synthesize positions;
@synthesize orders;
@synthesize trades;

@dynamic accounts;
@dynamic defaultAccount;

-(id)initWithUserId:( PFInteger )user_id_
        instruments:( PFInstruments* )instruments_
{
   self = [ super init ];
   if ( self )
   {
      self.fileName = [ NSString defaultAccountPathForUserWithId: user_id_ ];
      self.instruments = instruments_;
      self.positions = [ PFPositions new ];
      self.orders = [ PFOrders new ];
      self.trades = [ PFTrades new ];
   }
   return self;
}

-(NSArray*)allOrders
{
   return self.orders.orders;
}

-(NSArray*)allActiveOrders
{
   return self.orders.activeOrders;
}

-(NSArray*)allPositions
{
   return self.positions.positions;
}

-(NSArray*)allTrades
{
   return self.trades.trades;
}

-(NSArray*)allOperations
{
   NSMutableArray* operations_ = [ NSMutableArray new ];
   
   for ( PFAccount* account_ in self.accounts )
   {
      [ operations_ addObjectsFromArray: account_.operations ];
   }
   
   return operations_;
}

+(NSArray*)sortedOrdersByDateCreatedWithArray: (NSArray*)orders_for_sorted_
{
   return [orders_for_sorted_ sortedArrayWithOptions: 0
                                     usingComparator:
           ^(PFPosition* v1, PFPosition* v2)
           {
              long delta_time = [v1.createdAt timeIntervalSinceDate: v2.createdAt];
              
              if (delta_time == 0) return NSOrderedSame;
              return delta_time > 0 ? NSOrderedAscending : NSOrderedDescending;
           } ];
}

-(NSMutableDictionary*)accountsById
{
   if ( !_accountsById )
   {
      _accountsById = [ NSMutableDictionary new ];
   }
   return _accountsById;
}

-(id<PFAccount>)userAccount
{
   if ( !_userAccount )
   {
      PFLong account_id_ = [ self readDefaultAccountId ];

      id< PFAccount > user_account_ = account_id_ != -1 ? [ self accountWithId: account_id_ ] : nil;

      if ( !user_account_ )
      {
         user_account_ = [ self.accounts objectAtIndex: 0 ];
         NSAssert( user_account_, @"no account available" );

         [ self writeDefaultAccountId: user_account_.accountId ];
      }

      _userAccount = user_account_;
   }

   return _userAccount;
}

-(void)setDefaultAccount:( id< PFAccount > )account_
{
   NSAssert( account_, @"can't select nil account" );
   self.userAccount = account_;
   [ self writeDefaultAccountId: account_.accountId ];
}

-(id< PFAccount >)defaultAccount
{
   return self.userAccount;
}

-(NSArray*)accounts
{
   return [ self.accountsById allValues ];
}

-(NSString*)accountNameWithId:( PFInteger )account_id_
{
   PFAccount* account_ = [ self accountWithId: account_id_ ];
   return account_.name;
}

-(PFAccount*)accountWithId:( PFLong )account_id_
{
   return [ self.accountsById objectForKey: @(account_id_) ];
}

-(PFPammAccountStatus*)pammStatusWithId:( PFInteger )account_id_
{
    return [ self.pammStatuses objectForKey: @(account_id_) ];
}

-(void)addAccount:( PFAccount* )account_
{
    if( account_.name)
        [ self.accountsById setObject: account_ forKey: @(account_.accountId) ];
}

-(PFAccount*)writeAccountWithId:( PFInteger )account_id_
{
    
   PFAccount* account_ = [ self accountWithId: account_id_ ];
    if( !account_.name)
        return nil;
   if ( !account_ )
   {
      account_ = [ PFAccount accountWithId: account_id_];
       
           [ self addAccount: account_ ];
   }
   return account_;
}

-(void)updateAccountWithMessage:( PFMessage* )message_
                       delegate:( id< PFAccountsDelegate > )delegate_
{
   PFInteger account_id_ = [ (PFIntegerField*)[ message_ fieldWithId: PFFieldAccountId ] integerValue ];
   PFAccount* account_ = [ self accountWithId: account_id_ ];

   if ( account_ )
   {
      [ account_ readFromFieldOwner: message_ ];
      [ delegate_ accounts: self didUpdateAccount: account_ ];
      [self recalcPammStatusAndUpdeteFromDelegate: delegate_];
   }
   else
   {
      account_ = [ PFAccount objectWithFieldOwner: message_ ];
      
      if ( account_.accountState != 2 )
      {
         [ self addAccount: account_ ];
         [ delegate_ accounts: self didAddAccount: account_ ];
      }
   }
}

-(void)updatePammAccountStatusesWithMessage:( PFMessage* )message_
                                   delegate:( id< PFAccountsDelegate > )delegate_
{
    [self addPammStatus: [ PFPammAccountStatus objectWithFieldOwner: message_ ]];
    [self recalcPammStatusAndUpdeteFromDelegate: delegate_];
}

-(void)addPammStatus: (PFPammAccountStatus*)pamm_status_
{
    if ( !self.pammStatuses )
    {
        self.pammStatuses = [ NSMutableDictionary new ];
    }
    
    [ self.pammStatuses setObject: pamm_status_ forKey: @(pamm_status_.pammStatusId) ];
}

-(void)recalcPammStatusAndUpdeteFromDelegate: ( id< PFAccountsDelegate > )delegate_
{
    NSMutableDictionary* investors_ = [NSMutableDictionary new];
    for (PFPammAccountStatus* pamm_status_ in [self.pammStatuses allValues])
    {
        NSArray* invest_groups_ = pamm_status_.allInvestors;
        
        if (invest_groups_)
        {
            for (PFPammInvestor* invest_group_ in invest_groups_)
            {
                PFPammInvestor* investor_ = [investors_ objectForKey: @(invest_group_.investId)];
                if (!investor_)
                {
                    investor_ = [PFPammInvestor new];
                    investor_.investId = invest_group_.investId;
                    [investors_ setObject: investor_ forKey: @(investor_.investId)];
                }
                investor_.capital += invest_group_.capital;
                investor_.currCapital += invest_group_.currCapital;
            }
        }
    }
    
    for (PFAccount* account_ in self.accounts)
    {
        double curr_cap_ = account_.currentFundCapital;
        double start_cap_ = account_.startPammCapital;
        PFPammInvestor* investor_ = [investors_ objectForKey: @(account_.accountId)];
        
        if (investor_)
        {
            account_.currentFundCapital = investor_.currCapital;
            account_.startPammCapital = investor_.capital;
        }
        else
        {
            account_.currentFundCapital = 0;
            account_.startPammCapital = 0;
        }
        
        if ((curr_cap_ != account_.currentFundCapital) || (start_cap_ != account_.startPammCapital))
        {
            [ delegate_ accounts: self didUpdateAccount: account_ ];
        }
    }
}

-(void)updatePositionWithMessage:( PFMessage* )message_
                        delegate:( id< PFPositionsDelegate > )delegate_
{
   PFInteger account_id_ = [ (PFIntegerField*)([ message_ fieldWithId: PFFieldAccountId ]) integerValue ];

   PFAccount* account_ = [ self writeAccountWithId: account_id_ ];

   PFPosition* position_ = [ account_ updatePositionWithMessage: message_ ];
   [ self.positions updatePosition: position_ delegate: delegate_ ];
}

-(void)removePosition:( PFPosition* )position_ delegate:( id< PFPositionsDelegate > )delegate_
{
   PFAccount* account_ = [ self accountWithId: position_.accountId ];
   [ account_ removePosition: position_ ];

   [ self.positions removePosition: position_ delegate: delegate_ ];
}

-(void)updateOrderWithMessage:( PFMessage* )message_
                     delegate:( id< PFOrdersDelegate > )delegate_
{
   PFInteger account_id_ = [ (PFIntegerField*)([ message_ fieldWithId: PFFieldAccountId ]) integerValue ];
   
   PFAccount* account_ = [ self writeAccountWithId: account_id_ ];
   
   PFOrder* order_ = [ account_ updateOrderWithMessage: message_ ];
   [ self.orders updateOrder: order_ delegate: delegate_ ];
}

-(void)updateOrder:( PFOrder* )order_
          delegate:( id< PFOrdersDelegate > )delegate_
{
   PFAccount* account_ = [ self writeAccountWithId: order_.accountId ];

   [ account_ updateOrder: order_ ];
   [ self.orders updateOrder: order_ delegate: delegate_ ];
}

-(void)updateTradeWithMessage:( PFMessage* )message_
                     delegate:( id< PFTradesDelegate > )delegate_
{
   PFInteger account_id_ = [ (PFIntegerField*)[ message_ fieldWithId: PFFieldAccountId ] integerValue ];

   PFAccount* account_ = [ self writeAccountWithId: account_id_ ];

   PFTrade* trade_ = [ account_ updateTradeWithMessage: message_ ];
   [ self.trades updateTrade: trade_ delegate: delegate_ ];
}

-(void)connectToSymbols:( PFSymbols* )symbols_
{
   [ self.orders connectToSymbols: symbols_ ];
   [ self.positions connectToSymbols: symbols_ ];
   [ self.trades connectToSymbols: symbols_ ];
   
   for ( id account_key_ in self.accountsById )
   {
      PFAccount* account_ = [ self.accountsById objectForKey: account_key_ ];
      [ account_ connectToSymbols: symbols_ ];
   }
}

-(void)addRule:( PFRule* )rule_ withTransferFinished:( BOOL )transfer_finished_
{
  // NSAssert( rule_.accountId != -1, @"incorrect rule" );
   
//   PFAccount* account_ = transfer_finished_ ? [ self accountWithId: rule_.accountId ] : [ self writeAccountWithId: rule_.accountId ];

    PFRule * existingRule = nil;
    PFAccount* account_ = nil;
    for(int i=0;i<self.accounts.count;i++)
    {
        account_ =[self.accounts objectAtIndex:i];
        
        existingRule =[account_.ruleByName objectForKey:rule_.name];
        if(existingRule)
        {
            if([PFRule compareOwnerTypes:existingRule.ownerType withNew:rule_.ownerType] )
                if((account_.accountId == rule_.accountId|| rule_.ownerType == OWNER_USER || rule_.ownerType == OWNER_USER_GROUP) && existingRule.ownerType!=rule_.ownerType && existingRule.value!=rule_.value)
                {
                    [account_ removeRule:existingRule];
                    [account_ addRule:rule_];
                }

        }
        else
        {
            if(account_.accountId == rule_.accountId|| rule_.ownerType == OWNER_USER || rule_.ownerType == OWNER_USER_GROUP )
                [account_ addRule:rule_];
        }
        
    }
  // [ account_ addRule: rule_ ];
}

-(void)removeRule:( PFRule* )rule_
{
    PFAccount* account_ =  [ self accountWithId: rule_.accountId ];
    
    if(account_){
        [account_ removeRule:rule_];
    }
    
}
-(PFRule*)getRuleByName:(NSString*) ruleName andAccountId:(int) acId;{
     PFAccount* account_ =  [ self accountWithId: acId];
    
    if(account_){
      return  [account_ getRule:ruleName andAccountId:acId];
    }
    
    return nil;
}


#pragma mark Write & Read default account id

-(void)writeDefaultAccountId:( PFInteger )account_id_
{
   [ [ NSString stringWithFormat: @"%d", account_id_ ] writeToFile: self.fileName
                                                       atomically: YES
                                                         encoding: NSUTF8StringEncoding
                                                            error: nil ];
}

-(PFLong)readDefaultAccountId
{
   NSStringEncoding encoding_ = 0;
   NSString* account_id_ = [ NSString stringWithContentsOfFile: self.fileName
                                                  usedEncoding: &encoding_
                                                         error: nil ];
   if ( !account_id_ )
      return -1;

   return [ account_id_ integerValue ];
}

@end
