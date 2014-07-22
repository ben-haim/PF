#import "PFBrandingManager.h"

#import "PFMessageBuilder.h"

#import "PFApi.h"
#import "PFApiDelegate.h"

#import "PFField.h"
#import "PFMessage.h"

#import "NSBundle+PFResources.h"
#import "NSError+ProFinanceApi.h"
#import "CXMLDocument+PFConstructors.h"

#import "PFServerInfo.h"

#import <TouchXML.h>

@interface PFBrandingManager ()< PFApiDelegate >

@property ( nonatomic, strong ) PFApi* api;
@property ( nonatomic, weak ) id< PFBrandingManagerDelegate > delegate;

@property ( nonatomic, strong ) NSString* brandingServer;
@property ( nonatomic, strong ) NSString* brandingKey;


-(BOOL)connectToServer;
-(void)disconnect;

@end

@implementation PFBrandingManager

@synthesize api;
@synthesize delegate;
@synthesize brandingServer;
@synthesize brandingKey;

-(id)initWithDelegate:( id< PFBrandingManagerDelegate > )delegate_
       brandingServer:( NSString* )branding_server_
          brandingKey:( NSString* )branding_key_
{
   self = [ super init ];
   
   if ( self )
   {
      self.delegate = delegate_;
      self.brandingServer = branding_server_;
      self.brandingKey = branding_key_;
   }
   
   return self;
}

-(BOOL)connectToServer
{
   NSAssert( !self.api, @"already connected" );
   
   PFServerInfo* server_info_ = [ [ PFServerInfo alloc ]  initWithServers: self.brandingServer
                                                                   secure: NO
                                                                  useHTTP: NO ];
   
   self.api = [ PFApi apiWithDelegate: self ];
   return [ self.api connectToServerWithInfo: server_info_ ];
}

-(void)disconnect
{
   self.api.delegate = nil;
   [ self.api disconnect ];
   self.api = nil;
}

-(void)getBrandingWithDoneBlock:( PFBrandingManagerDoneBlock )done_block_
{
   if ( [ self connectToServer ] )
   {
      PFMessageBuilder* message_builder_ = [ PFMessageBuilder new ];
      
      [ self.api sendMessage: [ message_builder_ messageForBrandingWithKey: self.brandingKey ]
                   doneBlock: ^( PFMessage* message_ )
       {
          PFGroupField* group_ = [ message_ groupFieldWithId: PFGroupLine ];
          
          NSString* xml_ = [ [ group_ fieldWithId: PFFieldText ] stringValue ];
          
          NSError* parse_error_ = nil;
          CXMLDocument* document_ = [ CXMLDocument documentWithXMLString: xml_ error: &parse_error_ ];
          if ( parse_error_ )
          {
             [ self disconnect ];
             done_block_( nil, [ NSError PFErrorWithDescription: PFLocalizedString( @"PARSE_RESPONSE_ERROR", nil ) ] );
          }
          else
          {
             CXMLElement* root_element_ = [ document_ rootElement ];
             CXMLNode* response_element_ = [ root_element_ nodeForXPath: @"//getBrandingRulesReturn" error: nil ];
             
             if ( response_element_.childCount > 0 )
             {
                CXMLDocument* rules_document_ = [ CXMLDocument documentWithXMLString: [ [ response_element_ childAtIndex: 0 ] stringValue ] error: &parse_error_ ];
                if ( parse_error_ )
                {
                   done_block_( nil, [ NSError PFErrorWithDescription: PFLocalizedString( @"PARSE_RESPONSE_ERROR", nil ) ] );
                }
                
                NSArray* rule_nodes_ = [ [ rules_document_ rootElement ] nodesForXPath: @"//rule" error: nil ];
                NSMutableDictionary* branding_rules_ = [ [ NSMutableDictionary alloc ] initWithCapacity: [ rule_nodes_ count ] ];
                
                
                for ( CXMLElement* rule_element_ in rule_nodes_)
                {
                   [ branding_rules_ setObject: [ [ rule_element_ attributeForName: @"value" ] stringValue ]
                                        forKey: [ [ rule_element_ attributeForName: @"name" ] stringValue ] ];
                }
                
                [ self disconnect ];
                done_block_( branding_rules_, nil );
             }
             else
             {
                [ self disconnect ];
                done_block_( nil, [ NSError PFErrorWithDescription: [ response_element_ stringValue ] ] );
             }
          }
       } ];
   }
}

#pragma mark PFApiDelegate

-(void)api:( PFApi* )api_ didFailConnectWithError:( NSError* )error_
{
   [ self.delegate brandingManager: self didFailWithError: error_ ];
}

-(void)api:( PFApi* )api_ didFailParseWithError:( NSError* )error_
{
   [ self.delegate brandingManager: self didFailWithError: error_ ];
}

-(void)didConnectApi:( PFApi* )api_
{
   
}

@end
