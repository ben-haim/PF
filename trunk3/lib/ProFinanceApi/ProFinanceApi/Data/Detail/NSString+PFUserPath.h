#import "../../PFTypes.h"

#import <Foundation/Foundation.h>

@interface NSString (PFUserPath)

+(id)pathForUserWithId:( PFInteger )user_id_
              filename:( NSString* )file_name_;

+(id)pathForWatchlistWithId:( NSString* )watchlist_id_
                 userWithId:( PFInteger )user_id_;

+(id)defaultAccountPathForUserWithId:( PFInteger )user_id_;

@end
