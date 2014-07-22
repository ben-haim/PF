#import "PFDemoAccountManager.h"

#import "PFMessageBuilder.h"

#import "PFApi.h"
#import "PFApiDelegate.h"

#import "PFField.h"
#import "PFMessage.h"

#import "NSBundle+PFResources.h"
#import "NSError+ProFinanceApi.h"
#import "CXMLDocument+PFConstructors.h"

#import <TouchXML.h>

static NSString* const PFRegistrationDone = @"registration done";

@interface PFDemoAccountManager ()< PFApiDelegate >

@property ( nonatomic, strong ) PFApi* api;

@end

@implementation PFDemoAccountManager

@synthesize api;

@synthesize delegate;

-(id)init
{
   self = [ super init ];
   if ( self )
   {
      
   }
   return self;
}

-(BOOL)connectToServerWithInfo:( PFServerInfo* )server_info_
{
   NSAssert( !self.api, @"already connected" );
   
   self.api = [ PFApi apiWithDelegate: self ];
   return [ self.api connectToServerWithInfo: server_info_ ];
}

-(void)disconnect
{
   self.api.delegate = nil;
   [ self.api disconnect ];
   self.api = nil;
}

-(void)registerDemoAccount:( id< PFDemoAccount > )demo_account_
                 doneBlock:( PFDemoAccountManagerDoneBlock )done_block_
{
   PFMessageBuilder* message_builder_ = [ PFMessageBuilder new ];

   [ self.api sendMessage: [ message_builder_ messageForDemoAccount: demo_account_ ]
                doneBlock: ^( PFMessage* message_ )
    {
       PFGroupField* group_ = [ message_ groupFieldWithId: PFGroupLine ];

       NSString* xml_ = [ [ group_ fieldWithId: PFFieldText ] stringValue ];

       NSError* parse_error_ = nil;
       CXMLDocument* document_ = [ CXMLDocument documentWithXMLString: xml_ error: &parse_error_ ];
       if ( parse_error_ )
       {
          done_block_( nil, [ NSError PFErrorWithDescription: PFLocalizedString( @"PARSE_RESPONSE_ERROR", nil ) ] );
       }
       else
       {
          CXMLElement* root_element_ = [ document_ rootElement ];
          CXMLNode* response_element_ = [ root_element_ nodeForXPath: @"//registerDemoReturn" error: nil ];

          NSString* response_ = [ response_element_ stringValue ];

          if ( [ response_ hasPrefix: PFRegistrationDone ] )
          {
             done_block_( response_, nil );
          }
          else
          {
             done_block_( nil, [ NSError PFErrorWithDescription: response_ ] );
          }
       }
    } ];
}

#pragma mark PFApiDelegate

-(void)api:( PFApi* )api_ didFailConnectWithError:( NSError* )error_
{
   [ self.delegate demoAccountManager: self didFailWithError: error_ ];
}

-(void)api:( PFApi* )api_ didFailParseWithError:( NSError* )error_
{
   [ self.delegate demoAccountManager: self didFailWithError: error_ ];
}

-(void)didConnectApi:( PFApi* )api_
{
   
}

@end
