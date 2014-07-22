#import "../PFTypes.h"

#import <Foundation/Foundation.h>

@class PFField;

@interface PFDataScanner : NSObject

@property ( nonatomic, strong,readonly ) NSData* data;

@property ( nonatomic, assign, readonly ) NSUInteger location;
@property ( nonatomic, assign, readonly ) BOOL eof;
@property ( nonatomic, assign, readonly ) NSUInteger availableBytes;
@property ( nonatomic, assign ) BOOL directBytesOrder;

-(id)initWithData:( NSData* )data_;
+(id)scannerWithData:( NSData* )data_;

-(NSData*)bytesFromLocation:( NSUInteger )location_;

-(PFBool)scanBoolValue;
-(PFByte)scanByteValue;
-(PFShort)scanShortValue;
-(PFInteger)scanIntegerValue;
-(PFLong)scanLongValue;
-(PFFloat)scanFloatValue;
-(PFDouble)scanDoubleValue;
-(PFStringBytes)scanStringBytesValue;

-(NSData*)scanDataWithLength:( NSUInteger )length_;

-(PFField*)scanField;

-(NSArray*)scanFieldsWithLength:( NSUInteger )length_;

@end
