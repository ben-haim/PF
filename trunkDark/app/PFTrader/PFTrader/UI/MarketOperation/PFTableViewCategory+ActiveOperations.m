#import "PFTableViewCategory+ActiveOperations.h"
#import "PFTableViewActiveOperationsItem.h"

#import <ProFinanceApi/ProFinanceApi.h>

@implementation PFTableViewCategory ( ActiveOperations )

+(NSArray*)activeOperationCategoriesWithOrders:( NSArray* )orders_
                                    controller:( UIViewController* )controller_
{
   NSMutableArray* categories_array_ = [ NSMutableArray arrayWithCapacity: orders_.count ];
   
   for ( id< PFOrder > order_ in orders_ )
   {
      PFTableViewActiveOperationsItem* order_item_ = [ PFTableViewActiveOperationsItem itemWithOrder: order_
                                                                                          controller: controller_ ];
      order_item_.action = ^( PFTableViewItem* item_ ) { [ (PFTableViewActiveOperationsItem*)item_ selectCurrentItem ]; };
      [ categories_array_ addObject: [ PFTableViewCategory categoryWithTitle: nil items: @[order_item_] ] ];
   }
   
   return categories_array_;
}

@end
