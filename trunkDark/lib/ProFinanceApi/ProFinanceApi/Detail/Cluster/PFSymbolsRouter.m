#import "PFSymbolsRouter.h"

@interface PFSymbolsRouter ()

@property ( nonatomic, strong ) id< PFQuoteCommander > commander;
@property ( nonatomic, strong ) NSMutableArray* mutableSymbols;

@end

@implementation PFSymbolsRouter

@synthesize commander;
@synthesize mutableSymbols;

+(id)routerWithCommander:( id< PFQuoteCommander > )commander_
                 symbols:( NSArray* )symbols_
{
   PFSymbolsRouter* router_ = [ self new ];
   router_.commander = commander_;
   router_.mutableSymbols = [ symbols_ mutableCopy ];
   return router_;
}

-(NSArray*)symbols
{
   return self.mutableSymbols;
}

-(void)addSymbol:( id< PFSymbolId > )symbol_
{
   if ( !self.mutableSymbols )
   {
      self.mutableSymbols = [ NSMutableArray arrayWithObject: symbol_ ];
   }
   else
   {
      [ self.mutableSymbols addObject: symbol_ ];
   }
}

@end
