#import "PFHTTPAsyncSocketWrapper.h"

#import <AsyncSocket/AsyncSocket.h>

@interface PFHTTPAsyncSocketWrapper ()

@property ( nonatomic, strong ) NSString* wrapperId;
@property ( nonatomic, strong ) NSString* urlString;
@property ( nonatomic, strong ) NSMutableArray* cachedMessages;
@property ( nonatomic, strong ) NSMutableData* dataBuffer;
@property ( nonatomic, strong ) dispatch_queue_t clearingQueue;

@end

@implementation PFHTTPAsyncSocketWrapper

@synthesize wrapperId;
@synthesize urlString;
@synthesize cachedMessages;
@synthesize dataBuffer;
@synthesize clearingQueue = _clearingQueue;

-(BOOL)connectToHost:( NSString* )host_
                port:( NSInteger )port_
              secure:( BOOL )secure_
{
   BOOL result_ = [ super connectToHost: host_
                                   port: port_
                                 secure: secure_ ];
   
   if ( result_ )
   {
      self.dataBuffer = [ NSMutableData new ];
      self.cachedMessages = [ NSMutableArray new ];
      self.urlString = [ NSString stringWithFormat: @"%@://%@:%d/", secure_ ? @"https" : @"http", host_, (int)port_ ];
      
      //send empty get
      const char* raw_empty_get_ =[ [ NSString stringWithFormat: @"GET / HTTP/1.0\r\n\r\n" ] UTF8String ];
      [ super sendData: [ NSData dataWithBytes: raw_empty_get_ length: strlen( raw_empty_get_ ) ] ];
   }
   
   return result_;
}

-(dispatch_queue_t)clearingQueue
{
    if ( !_clearingQueue )
    {
        _clearingQueue = dispatch_queue_create( "HTTP_CLEARING_QUEUE", DISPATCH_QUEUE_SERIAL );
    }
    
    return _clearingQueue;
}

-(NSString*)wrapperIdFromString:( NSString* )full_string_
{
   NSString* start_ = @"X-pfs-CONNECTION-ID: ";
   NSString* end_ = @"\r\nConnection";
   
   NSRange start_range_ = [ full_string_ rangeOfString: start_ ];
   if ( start_range_.location != NSNotFound )
   {
      NSRange target_range_;
      target_range_.location = start_range_.location + start_range_.length;
      target_range_.length = full_string_.length - target_range_.location;
      
      NSRange end_range_ = [ full_string_ rangeOfString: end_ options:0 range: target_range_ ];
      if ( end_range_.location != NSNotFound )
      {
         target_range_.length = end_range_.location - target_range_.location;
         return [ full_string_ substringWithRange: target_range_ ];
      }
   }
   
   return nil;
}

-(void)processData:( NSData* )data_
        fromSocket:( AsyncSocket* )socket_
           withTag:( long )tag_
{
    static NSData* crlf_data_;
    static dispatch_once_t onceToken;
    dispatch_once( &onceToken, ^{ crlf_data_ = [ NSData dataWithBytes:"\x0D\x0A" length: 2 ]; } );
    
    dispatch_async( self.clearingQueue, ^
                   {
                       NSMutableData* clear_data_ = [ NSMutableData new ];
                       [ self.dataBuffer appendData: data_ ];
                       
                       while ( YES )
                       {
                           NSRange crlf_range_ = [ dataBuffer rangeOfData: crlf_data_ options: 0 range: NSMakeRange( 0, self.dataBuffer.length ) ];
                           if ( crlf_range_.location != NSNotFound )
                           {
                               long data_block_length_ = strtol( [ [ self.dataBuffer subdataWithRange: NSMakeRange( 0, crlf_range_.location ) ] bytes ], nil, 16 );
                               NSUInteger next_block_start_ = crlf_range_.location + crlf_range_.length + data_block_length_ + crlf_range_.length;
                               
                               if ( next_block_start_ <= self.dataBuffer.length )
                               {
                                   [ clear_data_ appendData: [ self.dataBuffer subdataWithRange: NSMakeRange( crlf_range_.location + crlf_range_.length, data_block_length_ ) ] ];
                                   
                                   self.dataBuffer = self.dataBuffer.length == next_block_start_ ?
                                   [ NSMutableData new ] :
                                   [ [ self.dataBuffer subdataWithRange: NSMakeRange( next_block_start_, self.dataBuffer.length - next_block_start_ ) ] mutableCopy ];
                               }
                               else
                                   break;
                           }
                           else
                               break;
                       }
                       
                       if ( clear_data_.length > 0 )
                       {
                           dispatch_async( dispatch_get_main_queue(), ^{ [ self.delegate socket: self didReceiveData: clear_data_ ]; } );
                       }
                   } );
    
    [ self.socket readDataWithTimeout: -1 tag: 10 ];
}

-(void)sendData:( NSData* )data_
{
   if ( self.wrapperId )
   {
      NSMutableURLRequest* request_ = [ NSMutableURLRequest requestWithURL: [ NSURL URLWithString: self.urlString ]
                                                               cachePolicy: NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval: 5.0 ];
      
      [ request_ setHTTPMethod: @"POST" ];
      [ request_ setValue: @"application/text" forHTTPHeaderField: @"Content-Type" ];
      [ request_ setValue: [ NSString stringWithFormat: @"%d", (int)data_.length ] forHTTPHeaderField: @"Content-Length" ];
      [ request_ setValue: self.wrapperId forHTTPHeaderField: @"X-pfs-CONNECTION-ID" ];
      [ request_ setHTTPBody: data_ ];
      
      [ NSURLConnection sendAsynchronousRequest: request_ queue: [ NSOperationQueue new ] completionHandler: nil ];
   }
   else
   {
      [ self.cachedMessages addObject: data_ ];
   }
}

-(void)onSocket:( AsyncSocket* )socket_ didReadData:( NSData* )data_ withTag:( long )tag_
{
   if ( self.wrapperId )
   {
       [ self processData: data_
               fromSocket: socket_
                  withTag: tag_ ];
   }
   else
   {
      self.wrapperId = [ self wrapperIdFromString: [ [ NSString alloc ] initWithData: data_ encoding: NSUTF8StringEncoding ] ];
      
      for ( NSData* data_ in  self.cachedMessages )
         [ self sendData: data_ ];
      
      [ self.cachedMessages removeAllObjects ];
      [ self.socket readDataWithTimeout: -1 tag: 10 ];
   }
}

@end
