#import "PFDataScanner.h"

#import "NSData+PFConversion.h"
#import "PFField+PFDataScanner.h"

#define PF_IMPLEMENT_SCAN_VALUER( Type ) -(PF##Type)scan##Type##Value\
{\
    PF##Type result_ = 0;\
    if ((self.location + PF##Type##Size) > [self.data length])\
    {\
        NSLog(@"History not matching %d", [self.data length]-self.location);\
        self.location = [self.data length];\
        return 0;\
    }\
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
   return self.location >= [ self.data length ];
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

//PF_IMPLEMENT_SCAN_VALUER( Bool )
//PF_IMPLEMENT_SCAN_VALUER( Byte )
//PF_IMPLEMENT_SCAN_VALUER( Short )
//PF_IMPLEMENT_SCAN_VALUER( Integer )
//PF_IMPLEMENT_SCAN_VALUER( Long )
//PF_IMPLEMENT_SCAN_VALUER( Float )
//PF_IMPLEMENT_SCAN_VALUER( Double )
//PF_IMPLEMENT_SCAN_VALUER( StringBytes )

-(void)idleScanBoolValue {
    self.location += PFBoolSize;
}

-(void)idleScanByteValue {
    self.location += PFByteSize;
}

-(void)idleScanShortValue {
    self.location += PFShortSize;
}

-(void)idleScanIntegerValue {
    self.location += PFIntegerSize;
}

-(void)idleScanLongValue {
    self.location += PFLongSize;
}

-(void)idleScanFloatValue {
    self.location += PFFloatSize;
}

-(void)idleScanDoubleValue {
    self.location += PFDoubleSize;
}

-(void)idleScanStringBytesValue {
    self.location += PFStringBytesSize;
}

-(void)idleScanDataWithLength:( NSUInteger )length_ {
    self.location += length_;
}

-(PFBool)scanBoolValue
{
    PFBool result_ = 0;
    if ((self.location + PFBoolSize) > [self.data length])
    {
        self.location = [self.data length];
        return 0;
    }
    [ self.data getBytes: ( unsigned char* )&result_ range: NSMakeRange( self.location, PFBoolSize ) reverseOrder: !self.directBytesOrder ];
    self.location += PFBoolSize;
    return result_;
}

-(PFByte)scanByteValue
{
    PFByte result_ = 0;
    if ((self.location + PFByteSize) > [self.data length])
    {
        self.location = [self.data length];
        return 0;
    }
    [ self.data getBytes: ( unsigned char* )&result_ range: NSMakeRange( self.location, PFByteSize ) reverseOrder: !self.directBytesOrder ];
    self.location += PFByteSize;
    return result_;
}

-(PFShort)scanShortValue
{
    PFShort result_ = 0;
    if ((self.location + PFShortSize) > [self.data length])
    {
        self.location = [self.data length];
        return 0;
    }
    [ self.data getBytes: ( unsigned char* )&result_ range: NSMakeRange( self.location, PFShortSize ) reverseOrder: !self.directBytesOrder ];
    self.location += PFShortSize;
    return result_;
}

-(PFInteger)scanIntegerValue
{
    PFInteger result_ = 0;
    if ((self.location + PFIntegerSize) > [self.data length])
    {
        self.location = [self.data length];
        return 0;
    }
    [ self.data getBytes: ( unsigned char* )&result_ range: NSMakeRange( self.location, PFIntegerSize ) reverseOrder: !self.directBytesOrder ];
    self.location += PFIntegerSize;
    return result_;
}

-(PFLong)scanLongValue
{
    PFLong result_ = 0;
    if ((self.location + PFLongSize) > [self.data length])
    {
        self.location = [self.data length];
        return 0;
    }
    [ self.data getBytes: ( unsigned char* )&result_ range: NSMakeRange( self.location, PFLongSize ) reverseOrder: !self.directBytesOrder ];
    self.location += PFLongSize;
    return result_;
}

-(PFFloat)scanFloatValue
{
    PFFloat result_ = 0;
    if ((self.location + PFFloatSize) > [self.data length])
    {
        self.location = [self.data length];
        return 0;
    }
    [ self.data getBytes: ( unsigned char* )&result_ range: NSMakeRange( self.location, PFFloatSize ) reverseOrder: !self.directBytesOrder ];
    self.location += PFFloatSize;
    return result_;
}

-(PFDouble)scanDoubleValue
{
    PFDouble result_ = 0;
    if ((self.location + PFDoubleSize) > [self.data length])
    {
        self.location = [self.data length];
        return 0;
    }
    [ self.data getBytes: ( unsigned char* )&result_ range: NSMakeRange( self.location, PFDoubleSize ) reverseOrder: !self.directBytesOrder ];
    self.location += PFDoubleSize;
    return result_;
}

-(PFStringBytes)scanStringBytesValue
{
    PFStringBytes result_ = 0;
    if ((self.location + PFStringBytesSize) > [self.data length])
    {
        self.location = [self.data length];
        return 0;
    }
    [ self.data getBytes: ( unsigned char* )&result_ range: NSMakeRange( self.location, PFStringBytesSize ) reverseOrder: !self.directBytesOrder ];
    self.location += PFStringBytesSize;
    return result_;
}

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
