#import "NSString+PFUserPath.h"

#import "PFUserPath.h"

@implementation NSString (PFUserPath)

+(id)pathForUserWithId:( PFInteger )user_id_
              filename:( NSString* )file_name_
{
   return [ PFUserPath( user_id_ ) stringByAppendingPathComponent: file_name_ ];
}

+(id)pathForWatchlistWithId:( NSString* )watchlist_id_
                 userWithId:( PFInteger )user_id_
{
   return [ PFUserPath( user_id_ ) stringByAppendingPathComponent: [ NSString stringWithFormat: @"PFWatchlist_%@.plist", watchlist_id_ ] ];
}

+(id)defaultAccountPathForUserWithId:( PFInteger )user_id_
{
   return [ PFUserPath( user_id_ ) stringByAppendingPathComponent: @"PFDefaultAccount.plist" ];
}

@end
