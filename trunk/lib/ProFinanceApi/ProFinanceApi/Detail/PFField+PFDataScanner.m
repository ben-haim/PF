#import "PFField+PFDataScanner.h"

#import "PFDataScanner.h"

#import "NSDate+PFTimeStamp.h"

@implementation PFField (PFDataScanner)

-(void)assignWithScanner:( PFDataScanner* )scanner_
{
   [ self doesNotRecognizeSelector: _cmd ];
}

+(id)fieldWithId:( PFShort )field_id_
         scanner:( PFDataScanner* )scanner_
{
   PFField* field_ = [ self fieldWithId: field_id_ ];
   [ field_ assignWithScanner: scanner_ ];
   return field_;
}

@end

@implementation PFBoolField (PFDataScanner)

-(void)assignWithScanner:( PFDataScanner* )scanner_
{
   self.boolValue = scanner_.scanBoolValue;
}

@end

@implementation PFByteField (PFDataScanner)

-(void)assignWithScanner:( PFDataScanner* )scanner_
{
   self.byteValue = scanner_.scanByteValue;
}

@end

@implementation PFShortField (PFDataScanner)

-(void)assignWithScanner:( PFDataScanner* )scanner_
{
   self.shortValue = scanner_.scanShortValue;
}

@end

@implementation PFIntegerField (PFDataScanner)

-(void)assignWithScanner:( PFDataScanner* )scanner_
{
   self.integerValue = scanner_.scanIntegerValue;
}

@end

@implementation PFLongField (PFDataScanner)

-(void)assignWithScanner:( PFDataScanner* )scanner_
{
   self.longValue = scanner_.scanLongValue;
}

@end

@implementation PFStringField (PFDataScanner)

-(void)assignWithScanner:( PFDataScanner* )scanner_
{
   PFShort length_ = scanner_.scanShortValue;
   
   NSData* string_data_ = [ scanner_ scanDataWithLength: length_ ];

   self.stringValue = [ [ NSString alloc ] initWithData: string_data_ encoding: NSUTF8StringEncoding ];
}

@end

@implementation PFFloatField (PFDataScanner)

-(void)assignWithScanner:( PFDataScanner* )scanner_
{
   self.floatValue = scanner_.scanFloatValue;
}

@end

@implementation PFDoubleField (PFDataScanner)

-(void)assignWithScanner:( PFDataScanner* )scanner_
{
   self.doubleValue = scanner_.scanDoubleValue;
}

@end

@implementation PFDateField (PFDataScanner)

-(void)assignWithScanner:( PFDataScanner* )scanner_
{
   self.dateValue = [ NSDate dateWithMsecondsTimeStamp: scanner_.scanLongValue ];
}

@end

@implementation PFDataField (PFDataScanner)

-(void)assignWithScanner:( PFDataScanner* )scanner_
{
   PFInteger length_ = [ scanner_ scanIntegerValue ];
   self.dataValue = [ scanner_ scanDataWithLength: length_ ];
}

@end

@implementation PFGroupField (PFDataScanner)

-(void)assignWithScanner:( PFDataScanner* )scanner_
{
   self.groupId = scanner_.scanIntegerValue;

   NSArray* fields_ = [ scanner_ scanFieldsWithLength: [ scanner_ scanShortValue ] ]; //Размер группы int16 

   for ( PFField* field_ in fields_ )
   {
      [ self addField: field_ ];
   }
}

@end

@implementation PFGroupLongField (PFDataScanner)

-(void)assignWithScanner:( PFDataScanner* )scanner_
{
    self.groupId = scanner_.scanIntegerValue;

    NSArray* fields_ = [ scanner_ scanFieldsWithLength: [ scanner_ scanIntegerValue ] ]; //Размер группы int32 

    for ( PFField* field_ in fields_ )
    {
        [ self addField: field_ ];
    }
}

@end
