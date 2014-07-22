#import "PFFilteredInstrumentGroup.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFFilteredInstrumentGroup ()

@property ( nonatomic, strong ) id< PFInstrumentGroup > group;
@property ( nonatomic, strong ) NSArray* symbols;

@end

@implementation PFFilteredInstrumentGroup

@synthesize group;
@synthesize symbols;

-(PFInteger)groupId
{
   return self.group.groupId;
}

-(PFInteger)superId
{
   return self.group.superId;
}

-(NSString*)name
{
   return self.group.name;
}

+(id)filteredGroupWithGroup:( id< PFInstrumentGroup > )group_
                    symbols:( NSArray* )symbols_
{
   PFFilteredInstrumentGroup* filtered_group_ = [ self new ];
   filtered_group_.group = group_;
   filtered_group_.symbols = symbols_;
   return filtered_group_;
}

+(NSArray*)filterSymbols:( NSArray* )symbols_
            forWatchlist:( id< PFWatchlist > )watchlist_
              searchTerm:( NSString* )term_
                    type:( PFInstrumentGroupFilterType )type_
{
   NSMutableArray* filtered_symbols_ = [ NSMutableArray arrayWithCapacity: [ symbols_ count ] ];
   
   if ( [ term_ length ] == 0 && type_ == PFInstrumentGroupFilterAll )
   {
      for ( id< PFSymbol > symbol_ in symbols_ )
      {
         if ( symbol_.isOption )
            continue;
         
         [ filtered_symbols_ addObject: symbol_ ];
      }
   }
   else
   {
      for ( id< PFSymbol > symbol_ in symbols_ )
      {
         if ( ( type_ == PFInstrumentGroupFilterActive && ![ watchlist_ containsSymbol: symbol_ ] ) || symbol_.isOption )
            continue;
         
         if ( [ term_ length ] == 0 || [ symbol_.name rangeOfString: term_ options: NSCaseInsensitiveSearch ].location != NSNotFound )
         {
            [ filtered_symbols_ addObject: symbol_ ];
         }
      }
   }

   return filtered_symbols_;
}

+(NSArray*)filterGroups:( NSArray* )groups_
           forWatchlist:( id< PFWatchlist > )watchlist_
             searchTerm:( NSString* )term_
                   type:( PFInstrumentGroupFilterType )type_
              skipEmpty:( BOOL )skip_empty_
{
   NSMutableArray* filtered_groups_ = [ NSMutableArray arrayWithCapacity: [ groups_ count ] ];
   for ( id< PFInstrumentGroup > group_ in groups_ )
   {
      NSArray* filtered_symbols_ = [ self filterSymbols: group_.symbols
                                           forWatchlist: watchlist_
                                             searchTerm: term_
                                                   type: type_ ];

      if ( [ filtered_symbols_ count ] > 0 || !skip_empty_ )
      {
         [ filtered_groups_ addObject: [ self filteredGroupWithGroup: group_
                                                             symbols: [ filtered_symbols_ sortedArrayUsingComparator: ^NSComparisonResult( id first_symbol_, id second_symbol_ )
                                                                       {
                                                                          return [ [ first_symbol_ name ] compare: [ second_symbol_ name ] ];
                                                                       } ] ] ];
      }
   }

   return [ filtered_groups_ sortedArrayUsingComparator:
           ^NSComparisonResult( id first_group_, id second_group_ )
           {
              return [ [ first_group_ name ] compare: [ second_group_ name ] ];
           } ];
}

-(void)addSymbols:( NSArray* )symbols_
{
   [ self doesNotRecognizeSelector: _cmd ];
}

-(void)removeSymbols:( NSArray* )symbols_
{
   [ self doesNotRecognizeSelector: _cmd ];
}

@end
