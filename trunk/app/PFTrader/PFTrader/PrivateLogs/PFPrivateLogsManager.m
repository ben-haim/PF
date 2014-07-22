#import "PFPrivateLogsManager.h"

#import <CommonCrypto/CommonCryptor.h>
#import <ProFinanceApi/ProFinanceApi.h>

const int BLOCK_LENGTH = 128;

static PFPrivateLogsManager* logs_manager_ = nil;
static NSString* logger_key_= @"5076afc526ffd9e75a38841035cf8ea3994f7d56dd41467291ae7f68e1328912";

NSString* logFileNameFromDate( NSDate* date_ )
{
   NSCalendar* gregorian_ = [ [ NSCalendar alloc ] initWithCalendarIdentifier: NSGregorianCalendar ];
   NSDateComponents* now_components_ = [ gregorian_ components: NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                                      fromDate: date_ ];
   
   NSString* logs_directory_ = [ [ NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES ) lastObject ] stringByAppendingPathComponent: @"/SecureLogs" ];
   NSError* error_;
   
   if ( ![ [ NSFileManager defaultManager ] fileExistsAtPath: logs_directory_ ] )
   {
      [ [ NSFileManager defaultManager ] createDirectoryAtPath: logs_directory_
                                   withIntermediateDirectories: NO
                                                    attributes: nil
                                                         error: &error_ ];
   }

   NSString* file_name_ = [ NSString stringWithFormat: @"%d_%d_%d.enc", (int)now_components_.day, (int)now_components_.month, (int)now_components_.year ];
   
   return [ logs_directory_ stringByAppendingPathComponent: file_name_ ];
}

@interface PFPrivateLogsManager ()

@property ( nonatomic, strong ) dispatch_queue_t loggerQueue;

@end

@implementation PFPrivateLogsManager

@synthesize  loggerQueue;

+(PFPrivateLogsManager*)manager
{
   if ( !logs_manager_ )
   {
      logs_manager_ = [ PFPrivateLogsManager new ];
      logs_manager_.loggerQueue = dispatch_queue_create( "PFPrivateLogsManager.Queue", DISPATCH_QUEUE_SERIAL );
   }
   
   return logs_manager_;
}

-(void)appendLogByText:( NSString* )message_text_
{
   NSString* text_ = [ message_text_ stringByAppendingString: @"\n\n" ];
   int tail_ = text_.length % BLOCK_LENGTH;
   NSString* text_block_ = tail_ > 0 ? [ text_ stringByPaddingToLength: text_.length + BLOCK_LENGTH - tail_ withString: @"^" startingAtIndex: 0 ] : text_;
   NSData* data_block_ = [ NSData dataWithBytes: [ text_block_ cStringUsingEncoding: NSUTF8StringEncoding ] length: text_block_.length ];
   NSMutableData* encrypted_data_ = [ [ NSMutableData alloc ] initWithCapacity: data_block_.length ];

   for ( int i = 0; i < data_block_.length; i += BLOCK_LENGTH )
   {
      [ encrypted_data_ appendData: [ PFAESUtility encryptData: [ data_block_ subdataWithRange: NSMakeRange( i, BLOCK_LENGTH ) ]
                                                       withKey: logger_key_
                                                 algorithmMode: kCCOptionECBMode ] ];
   }
   
   NSString* file_path_ = logFileNameFromDate( [ NSDate date ] );
   NSFileHandle* file_handle_ = [ NSFileHandle fileHandleForWritingAtPath: file_path_ ];
   
   if( !file_handle_ )
   {
      [ [ NSFileManager defaultManager ] createFileAtPath: file_path_ contents: nil attributes: nil ];
      file_handle_ = [ NSFileHandle fileHandleForWritingAtPath: file_path_ ];
   }
   
   if ( file_handle_ )
   {
      [ file_handle_ seekToEndOfFile ];
      [ file_handle_ writeData: encrypted_data_ ];
      [ file_handle_ closeFile ];
   }
}

-(void)writeToLog:( NSString* )message_
{
   dispatch_async( self.loggerQueue, ^{ [ self appendLogByText: message_ ]; } );
}

-(NSString*)logStringWithDate:( NSDate* )date_
{
   NSFileHandle* file_handle_ = [ NSFileHandle fileHandleForReadingAtPath: logFileNameFromDate( date_ ) ];
   
   if ( file_handle_ )
   {
      unsigned long long file_length_ = [ file_handle_ seekToEndOfFile ];
      
      if ( file_length_ % BLOCK_LENGTH != 0 )
         return nil;
      
      NSMutableData* decrypted_data_ = [ [ NSMutableData alloc ] initWithCapacity: file_length_ ];
      for ( int i = 0; i < file_length_; i += BLOCK_LENGTH )
      {
         [ file_handle_ seekToFileOffset: i ];
         [ decrypted_data_ appendData: [ PFAESUtility decryptData: [ file_handle_ readDataOfLength: BLOCK_LENGTH ]
                                                          withKey: logger_key_
                                                    algorithmMode: kCCOptionECBMode ] ];
      }
      [ file_handle_ closeFile ];
      
      return [ [ [ NSString alloc ] initWithData: decrypted_data_ encoding: NSUTF8StringEncoding ] stringByReplacingOccurrencesOfString: @"^"
                                                                                                                             withString: @"" ];
   }
   else
   {
      return nil;
   }
}

-(void)readTodayLogWithDoneBlock:( PFPrivateLogsDoneBlock )done_block_
{
   [ self readLogWithDate: [ NSDate date ]
             andDoneBlock: done_block_ ];
}

-(void)readLogWithDate:( NSDate* )date_ andDoneBlock:( PFPrivateLogsDoneBlock )done_block_
{
   dispatch_async( self.loggerQueue, ^
   {
      if ( done_block_ )
      {
         NSString* content_ = [ self logStringWithDate: date_ ];
         dispatch_async(dispatch_get_main_queue(), ^{ done_block_(content_); } );
      }
   } );
}

@end