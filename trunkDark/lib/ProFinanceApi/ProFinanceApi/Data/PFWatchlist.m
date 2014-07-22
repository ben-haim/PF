#import "PFWatchlist.h"

#import "PFSession.h"
#import "PFUser.h"

#import "PFSymbols.h"
#import "PFSymbol.h"

#import "PFOrderedSet.h"

#import "NSString+PFUserPath.h"

@interface PFWatchlist ()

@property ( nonatomic, strong ) NSString* watchlistId;
@property ( nonatomic, strong ) NSString* filePath;
@property ( nonatomic, strong ) PFMutableOrderedSet* symbolNames;
@property ( nonatomic, strong ) NSMutableArray* mutableSymbols;

@property ( nonatomic, weak ) id< PFWatchlistDelegate > delegate;

-(BOOL)save;

@end

@implementation PFWatchlist

@synthesize watchlistId;
@synthesize filePath;
@synthesize symbolNames = _symbolNames;
@synthesize mutableSymbols = _mutableSymbols;

@synthesize delegate;

-(NSArray*)symbols
{
   return self.mutableSymbols;
}

-(NSMutableArray*)mutableSymbols
{
   if ( !_mutableSymbols )
   {
      _mutableSymbols = [ NSMutableArray new ];
   }
   return _mutableSymbols;
}

-(PFMutableOrderedSet*)symbolNames
{
   if ( !_symbolNames )
   {
      _symbolNames = [ PFMutableOrderedSet new ];
   }
   return _symbolNames;
}

-(id)initWithId:( NSString* )watchlist_id_
{
   self = [ super init ];
   if ( self )
   {
      self.watchlistId = watchlist_id_;
   }
   return self;
}

+(id)watchlistWithId:( NSString* )watchlist_id_
{
   return [ [ self alloc ] initWithId: watchlist_id_ ];
}

-(void)connectToSession:( PFSession* )session_
{
   NSAssert( !self.delegate, @"delegate already initialized" );

   self.delegate = session_;

   NSAssert( session_.user.userId, @"userId should be initialized" );

   self.filePath = [ NSString pathForWatchlistWithId: self.watchlistId userWithId: session_.user.userId ];

   NSArray* symbol_names_ = [ NSArray arrayWithContentsOfFile: self.filePath ];
   
   if ( !symbol_names_ )
   {
      symbol_names_ = session_.defaultSymbolNames;
   }

   self.symbolNames = [ PFMutableOrderedSet orderedSetWithArray: symbol_names_ ];

   NSArray* wathlist_symbols_ = [ session_.symbols symbolsForNames: symbol_names_ ];
   self.mutableSymbols = [ wathlist_symbols_ mutableCopy ];
}

-(void)addSymbol:( id< PFSymbol > )symbol_
{
   if ( ![ self.symbolNames containsObject: symbol_.name ] )
   {
      [ self.symbolNames addObject: symbol_.name ];
      [ self.mutableSymbols addObject: symbol_ ];

      [ self save ];

      [ self.delegate watchlist: self didAddSymbol: symbol_ ];
   }
}

-(void)removeSymbol:( id< PFSymbol > )symbol_
{
   if ( [ self.symbolNames containsObject: symbol_.name ] )
   {
      [ self.symbolNames removeObject: symbol_.name ];
      [ self.mutableSymbols removeObject: symbol_ ];

      [ self save ];

      [ self.delegate watchlist: self didRemoveSymbols: [ NSArray arrayWithObject: symbol_ ] ];
   }
}

-(void)removeAllSymbols
{
   NSArray* removed_symbols_ = self.mutableSymbols;
   self.symbolNames = nil;
   self.mutableSymbols = nil;
   [ self save ];

   [ self.delegate watchlist: self didRemoveSymbols: removed_symbols_ ];
}

-(BOOL)containsSymbol:( id< PFSymbol > )symbol_
{
   return [ self.symbolNames containsObject: symbol_.name ];
}

-(BOOL)save
{
   return [ self.symbolNames.array writeToFile: self.filePath atomically: YES ];
}

@end
