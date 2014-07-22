#import "PFTableViewCategory+PFIndicatorLine.h"

#import "PFIndicator.h"

#import "PFIndicatorAttribute+PFTableViewItem.h"

#import <JFF/Utils/NSArray+BlocksAdditions.h>

@implementation PFTableViewCategory (PFIndicatorLine)

+(id)categoryWithLine:( PFIndicatorLine* )line_
{
   PFTableViewCategory* category_ = [ self categoryWithTitle: line_.title ];
   category_.items = [ line_.attributes map: ^id( id attribute_ )
                      {
                         return [ attribute_ tableViewItem ];
                      }];
   return category_;
}

@end
