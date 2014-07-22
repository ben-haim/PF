#import "PFIpManager.h"

#import "PFBrandingSettings.h"

@implementation PFIpManager

+(PFIpManager*)sharedManager
{
   static PFIpManager* shared_manager_ = nil;
   
   static dispatch_once_t once_token_;
   dispatch_once( &once_token_, ^{ shared_manager_ = [ PFIpManager new ]; } );
   
   return shared_manager_;
}

-(NSString*)ipFromService:( NSString* )service_
{
   NSURLRequest* request_ = [ NSURLRequest requestWithURL: [ NSURL URLWithString: service_ ] cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 3.0 ];
   NSURLResponse* response_ = nil;
   NSError* error_ = nil;
   NSData* data_ = [ NSURLConnection sendSynchronousRequest: request_ returningResponse: &response_ error: &error_ ];
   
   if ( data_ )
   {
      NSString* responce_string_ = [ [ NSString alloc ] initWithData: data_ encoding: NSUTF8StringEncoding ];
      NSRegularExpression* regex_ = [ NSRegularExpression regularExpressionWithPattern:@"[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}"
                                                                               options: NSRegularExpressionCaseInsensitive
                                                                                 error: &error_];
      
      NSRange first_match_range_ = [ regex_ rangeOfFirstMatchInString: responce_string_
                                                              options: 0
                                                                range: NSMakeRange( 0, responce_string_.length ) ];
      if ( !NSEqualRanges(first_match_range_, NSMakeRange(NSNotFound, 0) ) )
      {
         return [ responce_string_ substringWithRange: first_match_range_ ];
      }
   }
   
   return nil;
}

-(NSString*)myIpAddress
{
   NSArray* ip_services_ = [ PFBrandingSettings sharedBranding ].ipServices;
   
   if ( ip_services_ )
   {
      for ( NSString* service_ in ip_services_ )
      {
         NSString* address_ = [ self ipFromService: service_ ];
         if ( address_ )
            return address_;
      }
      
      return @"0.0.0.0";
   }
   
   return @"";
}

@end
