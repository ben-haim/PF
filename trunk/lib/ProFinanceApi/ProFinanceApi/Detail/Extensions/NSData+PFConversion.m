#import "NSData+PFConversion.h"

#import "PFTypes.h"
#import "PFField.h"

#define PF_IMPLEMENT_APPEND_VALUE( Type ) -(void)appendPF##Type:( PF##Type )value_\
{\
   [ self appendReverseBytes: &value_ length: PF##Type##Size ];\
}

#define PF_IMPLEMENT_DATA_WITH_VALUE( Type ) +(id)dataWithPF##Type:( PF##Type )value_\
{\
   return [ self dataWithReverseBytes: &value_ length: PF##Type##Size ];\
}

#define PF_IMPLEMENT_GET_VALUE( Type ) -(void)getPF##Type:( PF##Type* )value_ location:( NSUInteger )location_\
{\
   [ self getReverseBytes: ( unsigned char* )value_ range: NSMakeRange( location_, PF##Type##Size ) ];\
}

@implementation NSMutableData (PFConversion)

-(void)appendReverseBytes:( const void* )pointer_ length:( NSUInteger )length_
{
   const char* bytes_ = ( const char* )pointer_;
   
   for ( NSUInteger i_ = length_; i_ > 0; --i_ )
   {
      [ self appendBytes: bytes_ + i_ - 1 length: 1 ];
   }
}

PF_IMPLEMENT_APPEND_VALUE(Bool)
PF_IMPLEMENT_APPEND_VALUE(Byte)
PF_IMPLEMENT_APPEND_VALUE(Short)
PF_IMPLEMENT_APPEND_VALUE(Integer)
PF_IMPLEMENT_APPEND_VALUE(Long)
PF_IMPLEMENT_APPEND_VALUE(Float)
PF_IMPLEMENT_APPEND_VALUE(Double)

-(void)appendPFFields:( NSArray* )fields_
{
   for ( PFField* field_ in fields_ )
   {
      [ self appendPFShort: field_.fieldId ];
      [ self appendData: field_.data ];
   }
}

@end

@implementation NSData (PFConversion)

+(id)dataWithPFString:( NSString* )string_
{
   PFShort length_ = ( PFShort )[ string_ lengthOfBytesUsingEncoding: NSUTF8StringEncoding ];

   NSMutableData* data_ = [ NSMutableData dataWithPFShort: length_ ];

   [ data_ appendBytes: [ string_ UTF8String ] length: length_ ];

   return data_;
}

+(id)dataWithPFData:( NSData* )data_
{
   NSMutableData* protocol_data_ = [ NSMutableData dataWithPFInteger: (PFInteger)[ data_ length ] ];

   [ protocol_data_ appendData: data_ ];

   return protocol_data_;
}

+(id)dataWithReverseBytes:( const void* )bytes_ length:( NSUInteger )length_
{
   NSMutableData* data_ = [ NSMutableData dataWithCapacity: length_ ];

   [ data_ appendReverseBytes: bytes_ length: length_ ];

   return data_;
}

PF_IMPLEMENT_DATA_WITH_VALUE(Bool)
PF_IMPLEMENT_DATA_WITH_VALUE(Byte)
PF_IMPLEMENT_DATA_WITH_VALUE(Short)
PF_IMPLEMENT_DATA_WITH_VALUE(Integer)
PF_IMPLEMENT_DATA_WITH_VALUE(Long)
PF_IMPLEMENT_DATA_WITH_VALUE(Float)
PF_IMPLEMENT_DATA_WITH_VALUE(Double)

-(void)getBytes:( unsigned char* )output_
          range:( NSRange )bytes_range_
   reverseOrder:( BOOL )reverse_order_
{
   if ( reverse_order_ )
   {
      unsigned char bytes_[ bytes_range_.length ];
      
      [ self getBytes: bytes_ range: bytes_range_ ];
      
      for ( NSUInteger i_ = 0; i_ < bytes_range_.length; ++i_, ++output_ )
      {
         NSUInteger byte_index_ =  bytes_range_.length - i_ - 1;
         *output_ = bytes_[ byte_index_ ];
      }
   }
   else
   {
      [ self getBytes: output_ range: bytes_range_ ];
   }
   
   //! To remove
   /*
    unsigned char bytes_[ bytes_range_.length ];
    
    [ self getBytes: bytes_ range: bytes_range_ ];
    
    for ( NSUInteger i_ = 0; i_ < bytes_range_.length; ++i_, ++output_ )
   {
      NSUInteger byte_index_ = reverse_order_ ? bytes_range_.length - i_ - 1 : i_;
      *output_ = bytes_[ byte_index_ ];
   }*/
}

-(void)getReverseBytes:( unsigned char* )output_
                 range:( NSRange )bytes_range_
{
   return [ self getBytes: output_ range: bytes_range_ reverseOrder: YES ];
}

PF_IMPLEMENT_GET_VALUE(Bool)
PF_IMPLEMENT_GET_VALUE(Byte)
PF_IMPLEMENT_GET_VALUE(Short)
PF_IMPLEMENT_GET_VALUE(Integer)
PF_IMPLEMENT_GET_VALUE(Long)
PF_IMPLEMENT_GET_VALUE(Float)
PF_IMPLEMENT_GET_VALUE(Double)

@end
