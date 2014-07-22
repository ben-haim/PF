#import <Foundation/Foundation.h>

@protocol PFQuoteCommander;

@protocol PFSymbolId;

@interface PFSymbolsRouter : NSObject

@property ( nonatomic, strong, readonly ) id< PFQuoteCommander > commander;
@property ( nonatomic, strong, readonly ) NSArray* symbols;

+(id)routerWithCommander:( id< PFQuoteCommander > )commander_
                 symbols:( NSArray* )symbols_;

-(void)addSymbol:( id< PFSymbolId > )symbol_;

@end
