#import "../../PFTypes.h"

#import <Foundation/Foundation.h>

@interface NSData (PFConversion)

+(id)dataWithPFString:( NSString* )string_;
+(id)dataWithPFData:( NSData* )data_;

+(id)dataWithPFBool:( PFBool )bool_;
+(id)dataWithPFByte:( PFByte )byte_;
+(id)dataWithPFShort:( PFShort )short_;
+(id)dataWithPFInteger:( PFInteger )integer_;
+(id)dataWithPFLong:( PFLong )long_;

+(id)dataWithPFFloat:( PFFloat )float_;
+(id)dataWithPFDouble:( PFDouble )double_;

-(void)getPFBool:( PFBool* )bool_ location:( NSUInteger )location_;
-(void)getPFByte:( PFByte* )byte_ location:( NSUInteger )location_;
-(void)getPFShort:( PFShort* )short_ location:( NSUInteger )location_;
-(void)getPFInteger:( PFInteger* )integer_ location:( NSUInteger )location_;
-(void)getPFLong:( PFLong* )long_ location:( NSUInteger )location_;

-(void)getPFFloat:( PFFloat* )float_ location:( NSUInteger )location_;
-(void)getPFDouble:( PFDouble* )double_ location:( NSUInteger )location_;

-(void)getBytes:( unsigned char* )output_
          range:( NSRange )bytes_range_
   reverseOrder:( BOOL )reverse_order_;

@end

@interface NSMutableData (PFConversion)

-(void)appendPFBool:( PFBool )bool_;
-(void)appendPFByte:( PFByte )byte_;
-(void)appendPFShort:( PFShort )short_;
-(void)appendPFInteger:( PFInteger )integer_;
-(void)appendPFLong:( PFLong )long_;
-(void)appendPFFloat:( PFFloat )float_;
-(void)appendPFDouble:( PFDouble )double_;
-(void)appendPFFields:( NSArray* )fields_;

@end
