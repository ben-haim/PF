#import <Foundation/Foundation.h>

@protocol PFReportTable <NSObject>

-(NSString*)name;
-(NSArray*)rows;
-(NSArray*)header;
-(NSDate*)date;
-(NSString*)dialog;

@end

//#define reportLocalizatedStringWithValue( value_ )\
//[PFReportTable reportLocalizatedStringWithValue: (value_)]

@interface PFReportTable : NSObject< PFReportTable >

@property ( nonatomic, strong ) NSString* name;
@property ( nonatomic, strong ) NSDate* date;
@property ( nonatomic, strong ) NSString* dialog;

@property ( nonatomic, strong, readonly ) NSArray* rows;
@property ( nonatomic, strong, readonly ) NSArray* header;

-(void)addRow:( NSArray* )values_;

+(id)reportWithString:( NSString* )message_;
//+(NSString*)reportLocalizatedKeyWithValue:( NSString* )value_;
//+(NSString*)reportLocalizatedStringWithValue:( NSString* )value_;

@end
