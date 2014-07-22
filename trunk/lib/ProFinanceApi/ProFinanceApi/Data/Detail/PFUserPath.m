#import "PFUserPath.h"

NSString* PFUserPath( PFInteger user_id_ )
{
   NSString* document_directory_ = [ NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES ) lastObject ];
   
   NSString* user_directory_ = [ document_directory_ stringByAppendingPathComponent: [ NSString stringWithFormat: @"%d", user_id_ ] ];
   
   if ( ![ [ NSFileManager defaultManager] fileExistsAtPath: user_directory_ ] )
   {
      NSError* error_ = nil;
		[ [ NSFileManager defaultManager ] createDirectoryAtPath: user_directory_
                                   withIntermediateDirectories: NO attributes: nil
                                                         error: &error_ ];
      if ( error_ )
      {
         NSLog( @"create user directory: %d error: %@", user_id_, error_ );
      }
	}

   return user_directory_;
}
