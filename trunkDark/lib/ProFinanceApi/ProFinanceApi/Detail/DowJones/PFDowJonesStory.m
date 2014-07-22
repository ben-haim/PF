#import "PFDowJonesStory.h"

#import "PFDowJonesStory+XMLParser.h"

#import "CXMLDocument+PFConstructors.h"

#import <AsyncDispatcher/AsyncDispatcher.h>

#import <TouchXML.h>

@implementation PFDowJonesStoryDetails

@synthesize contentLines;

@end

@implementation PFDowJonesStory

@synthesize detailsUrl;
@synthesize details;
@synthesize asyncSession;

-(void)detailsWithDoneBlock:( PFStoryDetailsDoneBlock )done_block_
{
   [ self asyncValueForKey: @"details"
                 doneBlock: ADFilterCancelledResult
    (ADDoneOnMainThread(^( id< ADResult > result_ )
                        {
                           done_block_( self.details, result_.error );
                        }
                        ))
    ];
}

-(ADSession*)sessionForAsyncOperationWithKey:( NSString* )key_
{
   return self.asyncSession;
}

-(ADOperation*)asyncOperationForDetails
{
   ADOperation* operation_ = [ [ ADBlockOperation alloc ] initWithName: NSStringFromSelector( _cmd )
                                                                worker: ADURLWorker( self.detailsUrl ) ];

   operation_.transformBlock = ADNoTransformForFailedResult
   (^( id< ADMutableResult > result_ )
    {
       NSError* parse_error_ = nil;
       CXMLDocument* document_ = [ CXMLDocument documentWithData: ( NSData* )result_.result error: &parse_error_ ];
       result_.result = nil;
       result_.error = parse_error_;
       
       if ( parse_error_ )
          return;
       
       CXMLElement* article_element_ = ( CXMLElement* )[ [ document_ rootElement ] nodeForXPath: @"//Article" error: nil ];
       result_.result = [ PFDowJonesStoryDetails storyDetailsWithElement: article_element_ ];
    }
    );

   return operation_;
}

@end
