#import "PFQuoteFileLoader.h"

#import "PFConnection.h"
#import "PFServerInfo.h"

#import "PFQuoteFile.h"

#import "PFMessage.h"
#import "PFField.h"

@interface PFQuoteFileLoader ()< PFConnectionDelegate >

@property ( nonatomic, strong ) PFQuoteFile* file;
@property ( nonatomic, strong ) PFConnection* connection;
@property ( nonatomic, strong ) NSMutableDictionary* chunkByOffset;
@property ( nonatomic, assign ) PFLong currentSize;
@property ( nonatomic, weak ) id< PFQuoteFileLoaderDelegate > delegate;

@end

@implementation PFQuoteFileLoader

@synthesize file;
@synthesize connection;
@synthesize chunkByOffset = _chunkByOffset;
@synthesize currentSize;
@synthesize delegate;

+(id)loaderWithFile:( PFQuoteFile* )file_
           delegate:( id< PFQuoteFileLoaderDelegate > )delegate_
{
   PFQuoteFileLoader* loader_ = [ PFQuoteFileLoader new ];
   loader_.file = file_;
   loader_.delegate = delegate_;
   return loader_;
}

-(BOOL)connectToServerWithInfo:( PFServerInfo* )server_info_
{
   NSAssert( !self.connection, @"already connected" );

   PFConnection* connection_ = [ PFConnection connectionWithDelegate: self ];

   if ( ![ connection_ connectToHost: server_info_.host port: server_info_.port secure: server_info_.secure useHTTP: server_info_.useHTTP ] )
   {
      return NO;
   }

   self.chunkByOffset = [ NSMutableDictionary new ];
   self.currentSize = 0;

   PFMessage* message_ = [ PFMessage messageWithType: PFMessageHistoryFileRequest ];
   [ self.file writeToFieldOwner: message_ ];
   [ connection_ sendMessage: message_ ];

   self.connection = connection_;

   return YES;
}

-(void)disconnect
{
   self.connection.delegate = nil;
   [ self.connection disconnect ];
   self.connection = nil;
}

-(void)loadData:( NSData* )data_
{
   NSError* error_ = nil;
   [ self.file assignData: data_ error: &error_ ];
   if ( error_ )
   {
      [ self.delegate loader: self didFailWithError: error_ ];
   }
   else
   {
      [ self.delegate loader: self didLoadQuotes: self.file.quotes needSave: NO ];
   }
}

#pragma mark PFConnectionDelegate

-(void)connection:( PFConnection* )connection_
didFailParseWithError:( NSError* )error_
{
   [ self.delegate loader: self didFailWithError: error_ ];
}

-(NSData*)dataWithSize:( PFLong )size_
{
   NSMutableData* all_chunk_data_ = [ NSMutableData dataWithCapacity: size_ ];
   NSData* current_chunk_ = nil;
   for ( PFLong offset_ = 0; offset_ < size_; offset_ += [ current_chunk_ length ] )
   {
      current_chunk_ = [ self.chunkByOffset objectForKey: @(offset_) ];
      NSAssert( current_chunk_, @"invalid chunk offset" );
      [ all_chunk_data_ appendData: current_chunk_ ];
   }
   return all_chunk_data_;
}

-(void)connection:( PFConnection* )connection_
didReceiveMessage:( PFMessage* )message_
{
   if ( message_.type != PFMessageHistoryFileResponse )
   {
      NSLog( @"undefined message type: %d", message_.type );
      return;
   }

   NSData* data_ = [ [ message_ fieldWithId: PFFieldRawBytes ] dataValue ];
   self.currentSize += [ data_ length ];

   PFLong pointer_ = [ ( PFLongField* )[ message_ fieldWithId: PFFieldPointer ] longValue ];
   [ self.chunkByOffset setObject: data_ forKey: @(pointer_) ];

   PFLong size_ = [ ( PFLongField* )[ message_ fieldWithId: PFFieldSize ] longValue ];
   if ( self.currentSize != size_ )
      return;

   //don't listen any event
   self.connection.delegate = nil;

   NSError* error_ = nil;
   [ self.file assignData: [ self dataWithSize: size_ ] error: &error_ ];
   if ( error_ )
   {
      [ self.delegate loader: self didFailWithError: error_ ];
   }
   else
   {
      [ self.delegate loader: self didLoadQuotes: self.file.quotes ];
   }
}

-(void)connection:( PFConnection* )connection_
 didFailWithError:( NSError* )error_
{
   [ self.delegate loader: self didFailWithError: error_ ];
}

@end
