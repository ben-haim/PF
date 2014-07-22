#import "PFDataScanner.h"

#import "NSData+PFConversion.h"
#import "PFField+PFDataScanner.h"

#define PF_IMPLEMENT_SCAN_VALUER( Type ) -(PF##Type)scan##Type##Value\
{\
   PF##Type result_ = 0;\
   [ self.data getBytes: ( unsigned char* )&result_ range: NSMakeRange( self.location, PF##Type##Size ) reverseOrder: !self.directBytesOrder ];\
   self.location += PF##Type##Size;\
   return result_;\
}

@interface PFDataScanner ()

@property ( nonatomic, strong ) NSData* data;
@property ( nonatomic, assign ) NSUInteger location;

@end

@implementation PFDataScanner

@synthesize data = _data;
@synthesize location;
@synthesize directBytesOrder;

-(id)initWithData:( NSData* )data_
{
   self = [ super init ];
   if ( self )
   {
      self.data = data_;
   }
   return self;
}

+(id)scannerWithData:( NSData* )data_
{
   return [ [ self alloc ] initWithData: data_ ];
}

-(BOOL)eof
{
   return self.location == [ self.data length ];
}

-(NSUInteger)availableBytes
{
   return [ self.data length ] - self.location;
}

-(NSData*)bytesFromLocation:( NSUInteger )location_
{
   if ( location_ == 0 )
      return self.data;

   return [ self.data subdataWithRange: NSMakeRange( location_, self.data.length - location_ ) ];
}

PF_IMPLEMENT_SCAN_VALUER( Bool )
PF_IMPLEMENT_SCAN_VALUER( Byte )
PF_IMPLEMENT_SCAN_VALUER( Short )
PF_IMPLEMENT_SCAN_VALUER( Integer )
PF_IMPLEMENT_SCAN_VALUER( Long )
PF_IMPLEMENT_SCAN_VALUER( Float )
PF_IMPLEMENT_SCAN_VALUER( Double )

-(NSData*)scanDataWithLength:( NSUInteger )length_
{
   NSData* data_ = [ self.data subdataWithRange: NSMakeRange( self.location, length_ ) ];
   self.location += length_;
   return data_;
}

-(PFField*)scanField
{
   PFShort field_id_ = [ self scanShortValue ];
   PFField* field_ = [ PFField fieldWithId: field_id_ scanner: self ];
   return field_;
}

-(NSArray*)scanFieldsWithLength:( NSUInteger )length_
{
   if ( [ self availableBytes ] < length_ )
      return nil;

   NSUInteger new_message_location_ = self.location + length_;

   NSMutableArray* fields_ = [ NSMutableArray array ];

   while ( self.location < new_message_location_ )
   {
      [ fields_ addObject: [ self scanField ] ];
   }

   return fields_;
}

@end
