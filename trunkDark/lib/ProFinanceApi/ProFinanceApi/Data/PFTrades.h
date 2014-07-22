#import "../PFTypes.h"

#import <Foundation/Foundation.h>

@protocol PFTrades <NSObject>

-(NSArray*)trades;

@end

@class PFTrade;
@class PFSymbols;
@class PFMessage;

@protocol PFTradesDelegate;

@interface PFTrades : NSObject< PFTrades >

@property ( nonatomic, strong, readonly ) NSArray* trades;

-(PFTrade*)updateTradeWithMessage:( PFMessage* )message_
                         delegate:( id< PFTradesDelegate > )delegate_;

-(void)updateTrade:( PFTrade* )trade_ delegate:( id< PFTradesDelegate > )delegate_;

-(void)connectToSymbols:( PFSymbols* )symbols_;

@end

@protocol PFTradesDelegate<NSObject>

-(void)trades:( PFTrades* )trades_ didAddTrade:( PFTrade* )trade_;

@end
