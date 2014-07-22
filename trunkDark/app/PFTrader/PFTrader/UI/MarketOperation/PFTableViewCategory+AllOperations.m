#import "PFTableViewCategory+AllOperations.h"
#import "PFTableViewAllOperationsItem.h"

#import <ProFinanceApi/ProFinanceApi.h>

@implementation PFTableViewCategory ( AllOperations )

+(NSArray*)allOperationCategoriesWithOperations:( NSArray* )operations_
                                     controller:( UIViewController* )controller_
{
   NSMutableArray* categories_array_ = [ NSMutableArray arrayWithCapacity: operations_.count ];
   
   for ( id< PFMarketOperation > operation_ in operations_ )
   {
      PFTableViewAllOperationsItem* operation_item_ = [ PFTableViewAllOperationsItem itemWithOperation: operation_
                                                                                            controller: controller_ ];
      operation_item_.action = ^( PFTableViewItem* item_ ) { [ (PFTableViewAllOperationsItem*)item_ selectCurrentItem ]; };
      [ categories_array_ addObject: [ PFTableViewCategory categoryWithTitle: nil items: @[operation_item_] ] ];
   }
   
   return categories_array_;
}

@end
