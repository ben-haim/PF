#import "PFTableViewCategory+Positions.h"
#import "PFTableViewPositionItem.h"

#import <ProFinanceApi/ProFinanceApi.h>

@implementation PFTableViewCategory ( Positions )

+(NSArray*)positionCategoriesWithPositions:( NSArray* )positions_
                                controller:( UIViewController* )controller_
{
   NSMutableArray* categories_array_ = [ NSMutableArray arrayWithCapacity: positions_.count ];
   
   for ( id< PFPosition > position_ in positions_ )
   {
      PFTableViewPositionItem* position_item_ = [ PFTableViewPositionItem itemWithPosition: position_
                                                                                controller: controller_ ];
      position_item_.action = ^( PFTableViewItem* item_ ) { [ (PFTableViewPositionItem*)item_ selectCurrentItem ]; };
      [ categories_array_ addObject: [ PFTableViewCategory categoryWithTitle: nil items: [ NSArray arrayWithObject: position_item_ ] ] ];
   }
   
   return categories_array_;
}

@end
