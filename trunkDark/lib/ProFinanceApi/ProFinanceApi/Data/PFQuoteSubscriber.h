#import "PFSubscriptionType.h"

#import <Foundation/Foundation.h>

@protocol PFQuoteDependence;
@protocol PFSymbolId;

@protocol PFQuoteSubscriber <NSObject>

-(void)addDependence:( id< PFQuoteDependence > )dependence_
           forSymbol:( id< PFSymbolId > )symbol_;

-(void)removeDependence:( id< PFQuoteDependence > )dependence_
              forSymbol:( id< PFSymbolId > )symbol_;

-(void)removeDependence:( id< PFQuoteDependence > )dependence_
             forSymbols:( NSArray* )symbols_;

-(void)addDependence:( id< PFQuoteDependence > )dependence_
          forSymbols:( NSArray* )symbols_;

-(void)addDependence:( id< PFQuoteDependence > )dependence_
    forGeneralOption:( id< PFSymbolId > )option_symbol_;

-(void)removeDependence:( id< PFQuoteDependence > )dependence_
       forGeneralOption:( id< PFSymbolId > )option_symbol_;

@end

@protocol PFQuoteSubscriberDelegate;
@protocol PFSymbolConnection;

@interface PFQuoteSubscriber : NSObject< PFQuoteSubscriber >

@property ( nonatomic, assign, readonly ) PFSubscriptionType subscriptionType;
@property ( nonatomic, strong, readonly ) NSArray* symbolIds;

@property ( nonatomic, assign ) id< PFQuoteSubscriberDelegate > delegate;

-(id)initWithSubscriptionType:( PFSubscriptionType )subscription_type_;

+(id)level1Subscriber;
+(id)level2Subscriber;
+(id)level3Subscriber;
+(id)level4Subscriber;

-(void)addSymbolConnection:( id< PFSymbolConnection > )symbol_connection_;
-(void)removeSymbolConnection:( id< PFSymbolConnection > )symbol_connection_;

@end

@protocol PFSymbolId;

@protocol PFQuoteSubscriberDelegate< NSObject >

-(void)quoteSubscriber:( PFQuoteSubscriber* )subscriber_
    didAddSymbolWithId:( id< PFSymbolId > )symbol_id_;

-(void)quoteSubscriber:( PFQuoteSubscriber* )subscriber_
 didRemoveSymbolWithId:( id< PFSymbolId > )symbol_id_;

@end
