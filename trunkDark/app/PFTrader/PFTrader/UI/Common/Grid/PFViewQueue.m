#import "PFViewQueue.h"

@interface PFViewQueue ()

@property ( nonatomic, strong ) NSMutableDictionary* viewsByIdentifier;

@end

@implementation PFViewQueue

@synthesize viewsByIdentifier = _viewsByIdentifier;

-(NSMutableDictionary*)viewsByIdentifier
{
   if ( !_viewsByIdentifier )
   {
      _viewsByIdentifier = [ NSMutableDictionary new ];
   }
   return _viewsByIdentifier;
}

-(void)enqueueView:( UIView* )view_
    withIdentifier:( NSString* )identifier_
{
   NSMutableArray* views_ = (self.viewsByIdentifier)[identifier_];
   if ( !views_ )
   {
      views_ = [ NSMutableArray arrayWithObject: view_ ];
      (self.viewsByIdentifier)[identifier_] = views_;
   }
   else
   {
      [ views_ addObject: view_ ];
   }
}

-(UIView*)dequeueViewWithIdentifier:( NSString* )identifier_
{
   NSMutableArray* views_ = (self.viewsByIdentifier)[identifier_];
   if ( [ views_ count ] == 0 )
      return nil;

   //Can be any element from array
   UIView* last_object_ = [ views_ lastObject ];
   [ views_ removeLastObject ];
   return last_object_;
}

@end
