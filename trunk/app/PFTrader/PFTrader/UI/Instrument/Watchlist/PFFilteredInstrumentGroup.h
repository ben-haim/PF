#import <UIKit/UIKit.h>

#import <ProFinanceApi/ProFinanceApi.h>

typedef enum
{
   PFInstrumentGroupFilterActive
   , PFInstrumentGroupFilterAll
} PFInstrumentGroupFilterType;

@protocol PFWatchlist;

@interface PFFilteredInstrumentGroup : NSObject< PFInstrumentGroup >

+(NSArray*)filterGroups:( NSArray* )groups_
           forWatchlist:( id< PFWatchlist > )watchlist_
             searchTerm:( NSString* )term_
                   type:( PFInstrumentGroupFilterType )type_
              skipEmpty:( BOOL )skip_empty_;

@end
