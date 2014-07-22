#import "PFMarketOperationsViewController_iPad.h"

#import "PFMarketOperationsDataSource_iPad.h"

@interface PFMarketOperationsViewController_iPad ()

@end

@implementation PFMarketOperationsViewController_iPad

-(NSArray*)operationDataSources
{
   return @[ [ PFActiveOperationsDataSource_iPad new ]
   , [ PFFilledOperationsDataSource_iPad new ]
   , [ PFAllOperationsDataSource_iPad new ] ];
}

@end
