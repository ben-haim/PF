#import "PFQuoteFile.h"

#import "PFQuoteHistory.h"

#import "PFMetaObject.h"
#import "PFField.h"

#import "NSBundle+PFResources.h"
#import "NSError+ProFinanceApi.h"
#import "NSData+MD5.h"

#import <ZipKit/ZKDataArchive.h>
#import <ZipKit/ZKDefs.h>

@interface PFQuoteFile ()

@property ( nonatomic, strong ) NSArray* quotes;
@property ( nonatomic, strong ) NSData* data;

@end

@implementation PFQuoteFile

@synthesize name = _name;
@synthesize signature = _signature;
@synthesize compressed;
@synthesize quotes = _quotes;
@synthesize data;

+(PFMetaObject*)metaObject
{
   return [ PFMetaObject metaObjectWithFields:
           [ NSArray arrayWithObjects: [ PFMetaObjectField fieldWithId: PFFieldName name: @"name" ]
            , [ PFMetaObjectField fieldWithId: PFFieldFingerPrint name: @"signature" ]
            , [ PFMetaObjectField fieldWithId: PFFieldIsCompressed name: @"compressed" ]
            , [ PFMetaObjectField fieldWithName: @"quotes" ]
            , nil ] ];
}

-(BOOL)verifyData:( NSData* )data_
            error:( NSError** )error_
{
   if ( !self.signature )
      return YES;

   BOOL verified_ = [ [ data_ MD5 ] isEqual: self.signature ];

   if ( !verified_ && error_ )
   {
      *error_ = [ NSError PFErrorWithDescription: PFLocalizedString( @"CHART_SIGNATURE_ERROR", nil ) ];
   }

   return verified_;
}

-(BOOL)parseData:( NSData* )data_
           error:( NSError** )error_
{
   @try
   {
      PFQuoteHistory* history_ = [ PFQuoteHistory historyWithData: data_ error: error_ ];
      self.quotes = history_.quotes;
      return self.quotes != nil;
   }
   @catch ( NSException* exception_ )
   {
      if ( error_ )
      {
         *error_ = [ NSError PFErrorWithDescription: PFLocalizedString( @"PARSE_CHART_ERROR", nil ) ];
      }
      return NO;
   }
}

-(NSData*)unzipData:( NSData* )data_
              error:( NSError** )error_
{
   //!Error in interface of ZK lib, don't want to copy plenty of data
   ZKDataArchive* archive_ = [ ZKDataArchive archiveWithArchiveData: ( NSMutableData* )data_ ];

   NSData* decompressed_data_ = nil;

   if ( [ archive_ inflateAll ] == zkSucceeded )
   {
      NSArray* files_ = [ archive_ inflatedFiles ];
      if ( [ files_ count ] == 1 )
      {
         decompressed_data_ = [ [ files_ objectAtIndex: 0 ] objectForKey: ZKFileDataKey ];
      }
   }

   if ( !decompressed_data_ && error_ )
   {
      *error_ = [ NSError PFErrorWithDescription: PFLocalizedString( @"CHART_UNZIP_ERROR", nil ) ];
   }

   return decompressed_data_;
}

-(BOOL)assignData:( NSData* )data_
            error:( NSError** )error_
{
   if ( ![ self verifyData: data_ error: error_ ] )
      return NO;

   self.data = data_;
   
   if ( !self.isCompressed )
      return [ self parseData: data_ error: error_ ];

   NSData* decompressed_data_ = [ self unzipData: data_ error: error_ ];
   if ( !decompressed_data_ )
      return NO;

   return [ self parseData: decompressed_data_ error: error_ ];
}

@end
