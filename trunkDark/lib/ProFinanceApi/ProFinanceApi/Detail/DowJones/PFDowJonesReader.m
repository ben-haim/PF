#import "PFDowJonesReader.h"

#import "PFDowJonesStory+XMLParser.h"

#import "CXMLDocument+PFConstructors.h"
#import "CXMLElement+Parser.h"

#import <URLHelpers/URLHelpers.h>
#import <AsyncDispatcher/AsyncDispatcher.h>
#import <JFF/Utils/NSArray+BlocksAdditions.h>

#import <TouchXML.h>

static NSString* const PFDowJonesServer = @"http://api.beta.dowjones.com/api/1.0/RealTimeHeadlines/alert/xml";
static NSString* const PFDowJonesPrefix = @"DJ";

@interface PFDowJonesResponse : NSObject

@property ( nonatomic, strong ) NSArray* news;
@property ( nonatomic, strong ) NSString* alertContext;

@end

@implementation PFDowJonesResponse

@synthesize news;
@synthesize alertContext;

@end

@interface PFDowJonesReader ()

@property ( nonatomic, strong ) NSString* publicToken;
@property ( nonatomic, strong ) ADSession* asyncSession;

@end

@implementation PFDowJonesReader

@synthesize publicToken;
@synthesize asyncSession;

-(id)initWithPublicToken:( NSString* )public_token_
{
   if ( [ public_token_ length ] == 0 )
      return nil;
   
   self = [ super init ];
   if ( self )
   {
      self.publicToken = public_token_;
      self.asyncSession = [ ADSession new ];
   }
   return self;
}

+(id)readerWithPublicToken:( NSString* )token_
{
   return [ [ self alloc ] initWithPublicToken: token_ ];
}

-(void)disconnect
{
   [ self.asyncSession cancelAll ];
   self.asyncSession = nil;
}

-(void)readNewsWithAlertContext:( NSString* )context_
                      doneBlock:( PFPFDowJonesDoneBlock )done_block_
{
   if ( !self.asyncSession )
      return;

   NSMutableDictionary* arguments_ = [ NSMutableDictionary dictionaryWithObjectsAndKeys: @"All", @"SearchString"
                                      , self.publicToken, @"encryptedtoken"
                                      , nil ];
   

   [ arguments_ setIfNotNilObject: context_ forKey: @"AlertContext" ];

   if ( !context_ )
   {
      arguments_[@"Records"] = @"25";
   }

   NSURL* url_ = [ NSURL URLWithString: PFDowJonesServer arguments: arguments_ ];

   ADOperation* operation_ = [ [ ADBlockOperation alloc ] initWithName: NSStringFromSelector( _cmd )
                                                                worker: ADURLWorker( url_ ) ];

   operation_.transformBlock = ADNoTransformForFailedResult
   (^( id< ADMutableResult > result_ )
    {
       NSError* parse_error_ = nil;
       CXMLDocument* document_ = [ CXMLDocument documentWithData: ( NSData* )result_.result error: &parse_error_ ];
       result_.result = nil;
       result_.error = parse_error_;

       if ( parse_error_ )
          return;

       NSArray* article_elements_ = [ [ document_ rootElement ] nodesForXPath: @"//Article" error: nil ];

       PFDowJonesResponse* response_ = [ PFDowJonesResponse new ];
       response_.news = [ article_elements_ map: ^id( id element_ )
                         {
                            PFDowJonesStory* dj_story_ = [ PFDowJonesStory storyWithElement: ( CXMLElement* )element_ ];
                            dj_story_.asyncSession = self.asyncSession;
                            return dj_story_;
                         }];
       response_.alertContext = [ [ [ document_ rootElement ] elementForName: @"AlertContext" ] stringValue ];

       result_.result = response_;
    }
    );

   operation_.doneBlock = ADFilterCancelledResult(ADDoneOnMainThread(^( id< ADResult > result_ )
   {
      PFDowJonesResponse* response_ = ( PFDowJonesResponse* )result_.result;
      done_block_( response_.news, response_.alertContext, result_.error );
   }));

   [ operation_ asyncInSession: self.asyncSession ];
}

@end
