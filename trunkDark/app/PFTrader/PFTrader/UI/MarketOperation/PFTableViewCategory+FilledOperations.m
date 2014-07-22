#import "PFTableViewCategory+FilledOperations.h"
#import "PFTableViewFilledOperationsItem.h"

#import <ProFinanceApi/ProFinanceApi.h>

@implementation PFTableViewCategory ( FilledOperations )

+(NSArray*)filledOperationCategoriesWithTrades:( NSArray* )trades_
                                    controller:( UIViewController* )controller_
{
   NSMutableArray* categories_array_ = [ NSMutableArray arrayWithCapacity: trades_.count ];
   
   for ( id< PFTrade > trade_ in trades_ )
   {
      PFTableViewFilledOperationsItem* trade_item_ = [ PFTableViewFilledOperationsItem itemWithTrade: trade_
                                                                                          controller: controller_ ];
      trade_item_.action = ^( PFTableViewItem* item_ ) { [ (PFTableViewFilledOperationsItem*)item_ selectCurrentItem ]; };
      [ categories_array_ addObject: [ PFTableViewCategory categoryWithTitle: nil items: [ NSArray arrayWithObject: trade_item_ ] ] ];
   }
   
   return categories_array_;
}

@end
