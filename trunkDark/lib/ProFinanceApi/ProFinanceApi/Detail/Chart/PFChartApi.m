#import "PFChartApi.h"

#import "PFServerInfo.h"

#import "NSDate+PFTimeStamp.h"
#import "PFQuoteFile+XMLParser.h"
#import "NSError+ProFinanceApi.h"
#import "NSBundle+PFResources.h"
#import "NSString+PFEscape.h"

#import "CXMLDocument+PFConstructors.h"

#import <AsyncDispatcher/AsyncDispatcher.h>

#import <TouchXML.h>

@implementation NSURLRequest ( PFChartApi )

+(BOOL)allowsAnyHTTPSCertificateForHost:( NSString* )host_
{
	return YES;
}

@end

typedef id (^PFParseBlock)( CXMLDocument* document_, NSError** error_ );

static CXMLDocument* PFDataToDocument( NSData* data_, NSError** error_, NSString* error_message_ )
{
   NSError* parse_error_ = nil;

   CXMLDocument* document_ = [ CXMLDocument documentWithData: data_ error: &parse_error_ ];

   if ( parse_error_ )
   {
      if ( error_ )
      {
         *error_ = [ NSError PFErrorWithDescription: error_message_ ];
      }
      return nil;
   }

   return document_;
}

static ADTransformBlock PFXMLTransform( PFParseBlock parse_block_, NSString* error_message_ )
{
   return ADNoTransformForFailedResult
   ( ^( id< ADMutableResult > result_ )
    {
       NSError* local_error_ = nil;
       CXMLDocument* document_ = PFDataToDocument( result_.result, &local_error_, error_message_ );
       
       if ( !local_error_ )
       {
          result_.result = parse_block_( document_, &local_error_ );
       }
       
       result_.error = local_error_;
       
       if ( local_error_ )
       {
          result_.result = nil;
       }
    }
    );
}

@interface PFChartApi ()

@property ( nonatomic, strong ) PFServerInfo* serverInfo;

@end

@implementation PFChartApi

@synthesize serverInfo;

-(id)initWithServerInfo:( PFServerInfo* )server_info_
{
   self = [ super init ];
   if ( self )
   {
      self.serverInfo = server_info_;
   }
   return self;
}

+(id)apiWithServerInfo:( PFServerInfo* )server_info_
{
   return [ [ self alloc ] initWithServerInfo: server_info_ ];
}

-(NSString*)chartServer
{
   NSString* scheme_ = self.serverInfo.secure ? @"https" : @"http";
   return [ NSString stringWithFormat: @"%@://%@:%d"
           , scheme_
           , self.serverInfo.host
           , self.serverInfo.port ];
}

-(ADOperation*)operationForQuoteFile:( PFQuoteFile* )quote_file_
                           sessionId:( NSString* )session_id_
{
   NSString* url_string_ = [ NSString stringWithFormat: @"%@/proftrading/history?m=1&fn=%@&sid=%@"
                            , self.chartServer
                            , [ quote_file_.name stringByAddingPFEscapes ]
                            , session_id_ ];

   NSURL* url_ = [ NSURL URLWithString: url_string_ ];

   ADOperation* operation_ = [ [ ADBlockOperation alloc ] initWithName: quote_file_.name worker: ADURLWorker( url_ ) ];

   operation_.transformBlock = ADNoTransformForFailedResult( ^( id< ADMutableResult > result_ )
   {
      NSError* local_error_ = nil;
      [ quote_file_ assignData: result_.result error: &local_error_ ];
      if ( local_error_ )
      {
         result_.result = nil;
         result_.error = local_error_;
      }
   } );

   return operation_;
}

-(void)historyForInstrumentWithId:( PFInteger )instrument_id_
                        routeName:( NSString* )route_name_
                           userId:( PFInteger )user_id_
                        sessionId:( NSString* )session_id_
                           period:( PFChartPeriodType )period_
                             type:( PFByte )type_
                         fromDate:( NSDate* )from_date_
                           toDate:( NSDate* )to_date_
                        doneBlock:( PFHistoryDoneBlock )history_done_block_
{
   NSString* url_string_ = [ NSString stringWithFormat: @"%@/proftrading/history?getid=1&i=%d&p=%d&t=%d&u=%d&r=%@&b=%lld&e=%lld&m=0"
                            , self.chartServer
                            , instrument_id_
                            , period_
                            , type_
                            , user_id_
                            , route_name_
                            , [ from_date_ msecondsTimeStamp ]
                            , [ to_date_ msecondsTimeStamp ] ];

   NSURL* url_ = [ NSURL URLWithString: [ url_string_ stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding ] ];

   ADOperation* operation_ = [ [ ADBlockOperation alloc ] initWithName: NSStringFromSelector( _cmd ) worker: ADURLWorker( url_ ) ];

   PFParseBlock parse_block_ = ^id( CXMLDocument* document_, NSError** error_ )
   {
      NSArray* quote_elements_ = [ [ document_ rootElement ] nodesForXPath: @"quote-file" error: nil ];
      NSMutableArray* files_ = [ NSMutableArray arrayWithCapacity: [ quote_elements_ count ] ];
      for ( CXMLElement* element_ in quote_elements_ )
      {
         [ files_ addObject: [ PFQuoteFile quoteFileWithElement: element_ ] ];
      }
      return files_;
   };

   operation_.transformBlock = PFXMLTransform( parse_block_, PFLocalizedString( @"PARSE_CHART_ERROR", nil ) );

   operation_.doneBlock = ADFilterCancelledResult
   ( ^( id< ADResult > result_ )
    {
       NSArray* quote_files_ = result_.result;
       NSMutableArray* operations_ = [ NSMutableArray arrayWithCapacity: [ quote_files_ count ] ];
       for ( PFQuoteFile* quote_file_ in quote_files_ )
       {
          [ operations_ addObject: [ self operationForQuoteFile: quote_file_
                                                      sessionId: session_id_ ] ];
       }

       ADConcurrent* concurrent_ = [ [ ADConcurrent alloc ] initWithName: @"Read quote files data"
                                                              operations: operations_ ];

       concurrent_.transformBlock = ADNoTransformForFailedResult
       (
        ^( id< ADMutableResult > result_ )
        {
           NSMutableArray* quotes_ = [ NSMutableArray array ];
           
           for ( PFQuoteFile* file_ in quote_files_ )
           {
              [ quotes_ addObjectsFromArray: file_.quotes ];
           }
           result_.result = quotes_;
        }
        );
   
       concurrent_.doneBlock = ADFilterCancelledResult
       (
        ADDoneOnMainThread
        (
         ^( id< ADResult > result_ )
         {
            if ( history_done_block_ )
            {
               history_done_block_( result_.error ? nil : result_.result, result_.error );
            }
         }
         )
        );

       [ concurrent_ async ];
    });

   [ operation_ async ];
}

@end
