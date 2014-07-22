#import "PFTrades.h"

#import "PFTrade.h"
#import "PFSymbols.h"

#import "PFMessage.h"
#import "PFField.h"

#import "PFOrderedDictionary+PFConstructors.h"

@interface PFTrades ()

@property ( nonatomic, strong ) PFMutableOrderedDictionary* tradesById;
@property ( nonatomic, strong ) PFSymbols* symbols;

@end

@implementation PFTrades

@synthesize tradesById = _tradesById;
@synthesize symbols;

@dynamic trades;

-(id)init
{
   self = [ super init ];
   if ( self )
   {
      self.tradesById = [ PFMutableOrderedDictionary new ];
   }
   return self;
}

-(NSArray*)trades
{
   return self.tradesById.array;
}

-(PFTrade*)tradeWithId:( PFInteger )trade_id_
{
   return [ self.tradesById objectForKey: @(trade_id_) ];
}

-(PFTrade*)tradeWithMessageMessage:( PFMessage* )message_
{
   PFInteger trade_id_ = [ (PFIntegerField*)[ message_ fieldWithId: PFFieldTradeId ] integerValue ];
   
   PFTrade* trade_ = [ self tradeWithId: trade_id_ ];
   if ( !trade_ )
   {
      return [ PFTrade objectWithFieldOwner: message_ ];
   }
   
   [ trade_ readFromFieldOwner: message_ ];
   
   return trade_;
}

-(PFTrade*)updateTradeWithMessage:( PFMessage* )message_
                         delegate:( id< PFTradesDelegate > )delegate_
{
   PFTrade* trade_ = [ self tradeWithMessageMessage: message_ ];
   [ self updateTrade: trade_ delegate: delegate_ ];
   return trade_;
}

-(void)updateTrade:( PFTrade* )trade_ delegate:( id< PFTradesDelegate > )delegate_
{
   BOOL inconnected_ = self.symbols && [ self.symbols addSymbolConnection: trade_ ] == nil;
   if ( inconnected_ )
   {
      NSLog( @"Could not connect trade: %@", trade_ );
      return;
   }

   BOOL is_new_ = [ self tradeWithId: trade_.tradeId ] == nil;

   [ self.tradesById setObject: trade_ forKey: @(trade_.tradeId) ];

   if ( is_new_ )
   {
      [ delegate_ trades: self didAddTrade: trade_ ];
   }
}

-(void)connectToSymbols:( PFSymbols* )symbols_
{
   NSArray* connected_ = [ symbols_ addSymbolConnections: self.tradesById.array ];
   if ( [ connected_ count ] != [ self.tradesById count ] )
   {
      self.tradesById = [ PFMutableOrderedDictionary dictionaryWithTrades: connected_ ];
   }

   self.symbols = symbols_;
}

@end
