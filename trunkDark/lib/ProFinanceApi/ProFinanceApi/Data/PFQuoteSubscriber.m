#import "PFQuoteSubscriber.h"

#import "PFSymbol.h"
#import "PFSymbolId.h"
#import "PFSymbolConnection.h"
#import "PFMarketOperation.h"

@interface NSObject (PFQuoteDependence)

@end

@implementation NSObject (PFQuoteDependence)

-(NSString*)dependenceIdentifier
{
   return [ NSString stringWithFormat: @"%p", self ];
}

@end

@interface PFQuoteSubscriber ()

@property ( nonatomic, assign ) PFSubscriptionType subscriptionType;
@property ( nonatomic, strong ) NSMutableDictionary* subscribersBySymbol;

@end

@implementation PFQuoteSubscriber

@synthesize subscriptionType;
@synthesize subscribersBySymbol = _subscribersBySymbol;
@synthesize delegate;

-(id)initWithSubscriptionType:( PFSubscriptionType )subscription_type_
{
   self = [ super init ];
   if ( self )
   {
      self.subscriptionType = subscription_type_;
      self.subscribersBySymbol = [ NSMutableDictionary new ];
   }
   return self;
}

+(id)level1Subscriber
{
   return [ [ self alloc ] initWithSubscriptionType: PFSubscriptionTypeQuoteLevel1 ];
}

+(id)level2Subscriber
{
   return [ [ self alloc ] initWithSubscriptionType: PFSubscriptionTypeQuoteLevel2 ];
}

+(id)level3Subscriber
{
   return [ [ self alloc ] initWithSubscriptionType: PFSubscriptionTypeQuoteLevel3 ];
}

+(id)level4Subscriber
{
   return [ [ self alloc ] initWithSubscriptionType: PFSubscriptionTypeQuoteLevel4 ];
}

-(NSArray*)symbolIds
{
   return [ self.subscribersBySymbol allKeys ];
}

-(NSMutableSet*)subscribersForSymbolWithId:( PFSymbolIdKey* )symbol_id_
{
   return [ self.subscribersBySymbol objectForKey: symbol_id_ ];
}

-(NSMutableSet*)writeSubscribersForSymbolWithId:( PFSymbolIdKey* )symbol_id_
{
   NSMutableSet* subscribers_ = [ self subscribersForSymbolWithId: symbol_id_ ];
   if ( !subscribers_ )
   {
      subscribers_ = [ NSMutableSet new ];
      [ self.subscribersBySymbol setObject: subscribers_ forKey: symbol_id_ ];
   }
   return subscribers_;
}

-(void)addDependence:( id< PFQuoteDependence > )dependence_
      forSymbolIdKey:( PFSymbolIdKey* )symbol_id_key_
{
   NSMutableSet* subscribers_ = [ self writeSubscribersForSymbolWithId: symbol_id_key_ ];
   BOOL subscribed_before_ = [ subscribers_ count ] > 0;
   
   [ subscribers_ addObject: [ dependence_ dependenceIdentifier ] ];
   if ( !subscribed_before_ )
   {
      [ self.delegate quoteSubscriber: self didAddSymbolWithId: symbol_id_key_ ];
   }
}

-(void)addDependence:( id< PFQuoteDependence > )dependence_
           forSymbol:( id< PFSymbolId > )symbol_
{
   if ( [ symbol_ isMemberOfClass: [ PFSymbol class ] ] )
   {
      [ self addDependence: dependence_
            forSymbolIdKey: [ PFSymbolIdKey quotesKeyWithSymbol: (PFSymbol*)symbol_ ] ];
   }
   else if ( [ symbol_ isKindOfClass: [ PFMarketOperation class ] ] )
   {
      PFMarketOperation* market_operation_ = (PFMarketOperation*)symbol_;
      if ( market_operation_.symbol )
      {
         [ self addDependence: dependence_
               forSymbolIdKey: [ PFSymbolIdKey quotesKeyWithSymbol: market_operation_.symbol ] ];
      }
   }
   else
   {
      [ self addDependence: dependence_
            forSymbolIdKey: [ PFSymbolIdKey keyWithSymbolId: symbol_ ] ];
   }
}

-(void)addDependence:( id< PFQuoteDependence > )dependence_
          forSymbols:( NSArray* )symbols_
{
   for ( id< PFSymbolId > symbol_ in symbols_ )
   {
      [ self addDependence: dependence_ forSymbol: symbol_ ];
   }
}

-(void)addDependence:( id< PFQuoteDependence > )dependence_
    forGeneralOption:( id< PFSymbolId > )option_symbol_
{
   [ self addDependence: dependence_
         forSymbolIdKey: [ PFSymbolIdKey generalOptionKeyWithSymbolId: option_symbol_ ] ];
}

-(void)removeDependence:( id< PFQuoteDependence > )dependence_
         forSymbolIdKey:( PFSymbolIdKey* )symbol_id_key_
{
   NSMutableSet* subscribers_ = [ self subscribersForSymbolWithId: symbol_id_key_ ];
   BOOL subscribed_before_ = [ subscribers_ count ] > 0;

   [ subscribers_ removeObject: [ dependence_ dependenceIdentifier ] ];
   if ( [ subscribers_ count ] == 0 && subscribed_before_ )
   {
      [ self.subscribersBySymbol removeObjectForKey: symbol_id_key_ ];
      [ self.delegate quoteSubscriber: self didRemoveSymbolWithId: symbol_id_key_ ];
   }
}

-(void)removeDependence:( id< PFQuoteDependence > )dependence_
              forSymbol:( id< PFSymbolId > )symbol_
{
   if ( [ symbol_ isMemberOfClass: [ PFSymbol class ] ] )
   {
      [ self removeDependence: dependence_
               forSymbolIdKey: [ PFSymbolIdKey quotesKeyWithSymbol: (PFSymbol*)symbol_ ] ];
   }
   else if ( [ symbol_ isKindOfClass: [ PFMarketOperation class ] ] )
   {
      PFMarketOperation* market_operation_ = (PFMarketOperation*)symbol_;
      if ( market_operation_.symbol )
      {
         [ self removeDependence: dependence_
                  forSymbolIdKey: [ PFSymbolIdKey quotesKeyWithSymbol: market_operation_.symbol ] ];
      }
   }
   else
   {
      [ self removeDependence: dependence_
               forSymbolIdKey: [ PFSymbolIdKey keyWithSymbolId: symbol_ ] ];
   }
}

-(void)removeDependence:( id< PFQuoteDependence > )dependence_
             forSymbols:( NSArray* )symbols_
{
   for ( id< PFSymbolId > symbol_ in symbols_ )
   {
      [ self removeDependence: dependence_ forSymbol: symbol_ ];
   }
}

-(void)removeDependence:( id< PFQuoteDependence > )dependence_
       forGeneralOption:( id< PFSymbolId > )option_symbol_
{
   [ self removeDependence: dependence_
            forSymbolIdKey: [ PFSymbolIdKey generalOptionKeyWithSymbolId: option_symbol_ ] ];
}

-(void)addSymbolConnection:( id< PFSymbolConnection > )symbol_connection_
{
   [ self addDependence: symbol_connection_
              forSymbol: symbol_connection_ ];
}

-(void)removeSymbolConnection:( id< PFSymbolConnection > )symbol_connection_
{
   [ self removeDependence: symbol_connection_
                 forSymbol: symbol_connection_ ];
}

-(NSString*)description
{
   return [ self.subscribersBySymbol description ];
}

@end