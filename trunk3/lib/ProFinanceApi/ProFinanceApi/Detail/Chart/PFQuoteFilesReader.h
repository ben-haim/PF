#import "../../PFTypes.h"

#import "../../Data/PFChartPeriodType.h"

#import <Foundation/Foundation.h>

@protocol PFQuoteFilesReaderDelegate;

@protocol PFQuoteFilesReader< NSObject >

-(NSString*)server;
-(PFChartPeriodType)basePeriod;

-(void)startWithDelegate:( id< PFQuoteFilesReaderDelegate > )delegate_;
-(void)stop;

@end

@class PFServerInfo;

@interface PFQuoteFilesReader : NSObject< PFQuoteFilesReader >

@property ( nonatomic, strong, readonly ) NSArray* files;

+(id)readerWithServerInfo:( PFServerInfo* )server_info_
                    files:( NSArray* )files_
                  lastBar:( id )last_bar_
                 fromDate:( NSDate* )from_date_
               basePeriod:( PFChartPeriodType )base_period_
        destinationPeriod:( PFChartPeriodType )period_
           timeZoneOffset:( PFInteger )time_zone_offset_;

-(void)startWithDelegate:( id< PFQuoteFilesReaderDelegate > )delegate_;
-(void)stop;

@end

@protocol PFQuoteFilesReaderDelegate <NSObject>

-(void)reader:( id< PFQuoteFilesReader > )reader_
didFailWithError:( NSError* )error_;

-(void)reader:( id< PFQuoteFilesReader > )reader_ didLoadQuotes:( NSArray* )quotes_;

-(NSData*)reader:( id< PFQuoteFilesReader > )reader_
    dataFromFile:( NSString* )file_name_
   WithSignature:( NSString* )signature_;

-(void)reader:( id< PFQuoteFilesReader > )reader_
saveFileWithName: (NSString*)name_
         data: (NSData*)data_
         hash: (NSString*)md5_hash_;

@end
