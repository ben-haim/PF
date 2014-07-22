#import "PFMessage.h"

#import "PFField.h"

#import "NSData+PFConversion.h"
#import "PFDataScanner.h"

@implementation PFMessage

-(PFShort)type
{
   return [ [ self fieldWithId: PFFieldMessageType ] shortValue ];
}

+(id)messageWithScanner:( PFDataScanner* )scanner_
                   tail:( NSData** )tail_
{
   //No bytes even for size
   if ( scanner_.availableBytes < PFIntegerSize )
      return nil;

   NSUInteger begin_location_ = scanner_.location;

   NSUInteger length_ = [ scanner_ scanIntegerValue ];
   NSArray* fields_ = [ scanner_ scanFieldsWithLength: length_ ];
   if ( !fields_ )
      return nil;

   NSUInteger end_location_ = scanner_.location;
   NSAssert( length_ + PFIntegerSize == end_location_ - begin_location_, @"invalid message length" );
   PFMessage* message_ = [ self new ];

   for ( PFField* field_ in fields_ )
   {
      [ message_ addField: field_ ];
   }

   return message_;
}

+(id)messageWithType:( PFShort )type_
{
   PFMessage* message_ = [ PFMessage new ];
   [ [ message_ writeFieldWithId: PFFieldMessageType ] setShortValue: type_ ];
   return message_;
}

-(PFInteger)length
{
   PFInteger length_ = 0;
   for ( PFField* field_ in self.fields )
   {
      length_ += ( PFShortSize /*field id size*/ + field_.length );
   }
   return length_;
}

-(NSData*)data
{
   PFInteger length_ = [ self length ];

   NSMutableData* fields_data_ = [ NSMutableData dataWithCapacity: PFIntegerSize/*message length*/ + length_ ];

   [ fields_data_ appendPFInteger: length_ ];
   [ fields_data_ appendPFFields: self.fields ];

   return fields_data_;
}

@end


@implementation NSArray (PFMessage)

+(id)arrayOfMessagesWithData:( NSData* )data_
                        tail:( NSData** )tail_
{
   NSAssert( tail_, @"tail should be defined" );

   PFDataScanner* scanner_ = [ PFDataScanner scannerWithData: data_ ];

   NSMutableArray* messages_ = [ NSMutableArray new ];

   while ( !scanner_.eof )
   {
      NSUInteger saved_location_ = scanner_.location;

      PFMessage* message_ = [ PFMessage messageWithScanner: scanner_ tail: tail_ ];
      if ( !message_ )
      {
         *tail_ = [ scanner_ bytesFromLocation: saved_location_ ];
         break;
      }

      [ messages_ addObject: message_ ];
   }

   return messages_;
}

@end
