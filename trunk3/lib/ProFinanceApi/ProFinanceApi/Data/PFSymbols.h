#import <Foundation/Foundation.h>

@protocol PFSymbols <NSObject>

-(NSArray*)symbols;
-(NSArray*)optionSymbols;
-(NSArray*)symbolsForNames:( NSArray* )names_;

@end

@class PFInstruments;
@class PFSymbol;
@class PFMessage;

@protocol PFSymbolConnection;

@interface PFSymbols : NSObject< PFSymbols >

@property ( nonatomic, strong, readonly ) NSArray* symbols;

+(id)symbolsWithInstruments:( PFInstruments* )instruments_;

-(NSArray*)addSymbolConnectionByQuoteRouteId:( id< PFSymbolConnection > )connection_;
-(PFSymbol*)addSymbolConnection:( id< PFSymbolConnection > )connection_;
-(NSArray*)addSymbolConnections:( NSArray* )connections_;

-(NSArray*)updateWithQuoteMessage:( PFMessage* )message_;

-(NSArray*)updateWithTradeQuoteMessage:( PFMessage* )message_;

-(PFSymbol*)symbolForName:( NSString* )name_;

-(NSArray*)symbolsForNames:( NSArray* )names_;

@end
