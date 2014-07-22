#import "PFSymbols.h"

#import "PFSymbol.h"
#import "PFSymbolId.h"

#import "PFRoute.h"
#import "PFInstruments.h"
#import "PFInstrumentGroup.h"

#import "PFInstrument.h"
#import "PFQuote.h"
#import "PFLevel3Quote.h"

#import "PFSymbolConnection.h"

#import "PFMessage.h"

@interface PFSymbols ()

@property ( nonatomic, strong ) NSDictionary* symbolsById;
@property ( nonatomic, strong ) NSDictionary* symbolsByName;
@property ( nonatomic, strong ) NSDictionary* symbolsByQuoteRouteId;

@end


@implementation PFSymbols

@synthesize symbolsById;
@synthesize symbolsByName;
@synthesize symbolsByQuoteRouteId;

-(NSArray*)symbols
{
   return [ self.symbolsById allValues ];
}

-(NSArray*)optionSymbols
{
   NSArray* all_symbols_ = self.symbols;
   
   NSMutableArray* option_symbols_ = [ NSMutableArray new ];
   
   for ( PFSymbol* symbol_ in  all_symbols_ )
   {
      if ( symbol_.isOption )
      {
         [ option_symbols_ addObject: symbol_ ];
      }
   }
   
   return option_symbols_;
}

+(id)symbolsWithInstruments:( PFInstruments* )instruments_
{
   NSMutableDictionary* symbols_by_id_ = [ NSMutableDictionary new ];
   NSMutableDictionary* symbols_by_name_ = [ NSMutableDictionary new ];
   NSMutableDictionary* symbols_by_quote_route_id_ = [ NSMutableDictionary new ];

   for ( PFInstrument* instrument_ in instruments_.instruments )
   {
      NSArray* filtered_symbols_ = instrument_.symbols;

      // routes agregation
      if ( instrument_.routes.count == 2 )
      {
         BOOL need_change_name_ = NO;
         PFRoute* first_route_ = (instrument_.routes)[0];
         PFRoute* second_route_ = (instrument_.routes)[1];
         
         if ( first_route_.quoteRouteId == second_route_.routeId )
         {
            filtered_symbols_ = [ instrument_ symbolsForRouteId: first_route_.routeId ];
            [ instrument_.group removeSymbols: [ instrument_ symbolsForRouteId: second_route_.routeId ] ];
            need_change_name_ = YES;
            
         }
         else if ( second_route_.quoteRouteId == first_route_.routeId )
         {
            filtered_symbols_ = [ instrument_ symbolsForRouteId: second_route_.routeId ];
            [ instrument_.group removeSymbols: [ instrument_ symbolsForRouteId: first_route_.routeId ] ];
            need_change_name_ = YES;
         }
         
         if ( need_change_name_ )
         {
            for ( PFSymbol* symbol_ in filtered_symbols_ )
               symbol_.name = symbol_.shortName;
         }
      }

      for ( PFSymbol* symbol_ in filtered_symbols_ )
      {
         symbols_by_id_[[ PFSymbolIdKey keyWithSymbolId: symbol_ ]] = symbol_;

         symbols_by_name_[symbol_.name] = symbol_;
         
         
         NSMutableArray* symbols_array_ = symbols_by_quote_route_id_[[ PFSymbolIdKey quotesKeyWithSymbol: symbol_ ]];
         
         if ( !symbols_array_ )
         {
            symbols_by_quote_route_id_[[ PFSymbolIdKey quotesKeyWithSymbol: symbol_ ]] = [ NSMutableArray arrayWithObject: symbol_ ];
         }
         else if ( ![ symbols_array_ containsObject: symbol_ ] )
         {
            [ symbols_array_ addObject: symbol_ ];
         }
      }
   }

   PFSymbols* symbols_ = [ self new ];
   symbols_.symbolsById = symbols_by_id_;
   symbols_.symbolsByName = symbols_by_name_;
   symbols_.symbolsByQuoteRouteId = symbols_by_quote_route_id_;
   return symbols_;
}

-(PFSymbol*)symbolForId:( id< PFSymbolId > )symbol_id_
{
   return (self.symbolsById)[[ PFSymbolIdKey keyWithSymbolId: symbol_id_ ]];
}

-(NSArray*)symbolsForQuoteRouteId:( id< PFSymbolId > )symbol_id_
{
   return (self.symbolsByQuoteRouteId)[[ PFSymbolIdKey keyWithSymbolId: symbol_id_ ]];
}

-(PFSymbol*)symbolForName:( NSString* )name_
{
   return (self.symbolsByName)[name_];
}

-(NSArray*)addSymbolConnectionByQuoteRouteId:( id< PFSymbolConnection > )connection_
{
   NSArray* symbols_array_ = [ self symbolsForQuoteRouteId: connection_ ];
   
   for ( PFSymbol* symbol_ in symbols_array_ )
   {
      [ connection_ connectToSymbol: symbol_ ];
   }
   
   return symbols_array_;
}

-(PFSymbol*)addSymbolConnection:( id< PFSymbolConnection > )connection_
{
   PFSymbol* symbol_ = [ self symbolForId: connection_ ];
   if ( symbol_ )
   {
      [ connection_ connectToSymbol: symbol_ ];
   }
   return symbol_;
}

-(NSArray*)addSymbolConnections:( NSArray* )connections_
{
   NSMutableArray* connected_ = [ NSMutableArray arrayWithCapacity: [ connections_ count ] ];
   for ( id< PFSymbolConnection > connection_ in connections_ )
   {
      PFSymbol* symbol_ = [ self addSymbolConnection: connection_ ];
      if ( symbol_ )
      {
         [ connected_ addObject: connection_ ];
      }
   }
   return connected_;
}

-(NSArray*)updateWithQuoteMessage:( PFMessage* )message_
{
   NSArray* symbols_array_ = [ self symbolsForQuoteRouteId: [ PFSymbolId objectWithFieldOwner: message_ ] ];
   
   for ( PFSymbol* symbol_ in symbols_array_ )
   {
      if ( symbol_.realQuote )
      {
         [ symbol_.realQuote readFromFieldOwner: message_ ];
      }
      else
      {
         PFQuote* quote_ = [ PFQuote objectWithFieldOwner: message_ ];
         [ quote_ connectToSymbol: symbol_ ];
      }
   }
   
   return symbols_array_;
}

-(NSArray*)updateWithTradeQuoteMessage:( PFMessage* )message_
{
   NSArray* symbols_array_ = [ self symbolsForQuoteRouteId: [ PFSymbolId objectWithFieldOwner: message_ ] ];
   
   for ( PFSymbol* symbol_ in symbols_array_ )
   {
      [ [ PFLevel3Quote objectWithFieldOwner: message_ ] connectToSymbol: symbol_ ];
   }
   
   return symbols_array_;
}

-(NSArray*)symbolsForNames:( NSArray* )names_
{
   NSMutableArray* symbols_ = [ NSMutableArray arrayWithCapacity: [ names_ count ] ];
   for ( NSString* name_ in names_ )
   {
      PFSymbol* symbol_ = [ self symbolForName: name_ ];
      if ( symbol_ )
      {
         [ symbols_ addObject: symbol_ ];
      }
   }
   return symbols_;
}

@end
