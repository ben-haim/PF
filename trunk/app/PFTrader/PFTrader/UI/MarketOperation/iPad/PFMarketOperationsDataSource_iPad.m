#import "PFMarketOperationsDataSource_iPad.h"

#import "PFOrderColumn_iPad.h"
#import "PFTradeColumn_iPad.h"

@implementation PFActiveOperationsDataSource_iPad

-(id)init
{
   NSArray* columns_ = [ NSArray arrayWithObjects: [ PFOrderColumn_iPad symbolColumn ]
                        , [ PFOrderColumn_iPad sideColumn ]
                        , [ PFOrderColumn_iPad typeColumn ]
                        , [ PFOrderColumn_iPad quantityColumn ]
                        , [ PFOrderColumn_iPad priceColumn ]
                        , [ PFOrderColumn_iPad lastColumn ]
                        , [ PFOrderColumn_iPad tifColumn ]
                        , [ PFOrderColumn_iPad slColumn ]
                        , [ PFOrderColumn_iPad tpColumn ]
                        , [ PFOrderColumn_iPad dateTimeColumn ]
                        , [ PFOrderColumn_iPad accountColumn ]
                        , [ PFOrderColumn_iPad instrumentTypeColumn ]
                        , [ PFOrderColumn_iPad statusColumn ]
                        , [ PFOrderColumn_iPad orderIdColumn ]
                        , nil ];

   return [ self initWithColumns: columns_ ];
}

@end

@implementation PFFilledOperationsDataSource_iPad

-(id)init
{
   NSArray* columns_ = [ NSArray arrayWithObjects: [ PFTradeColumn_iPad symbolColumn ]
                        , [ PFTradeColumn_iPad sideColumn ]
                        , [ PFTradeColumn_iPad typeColumn ]
                        , [ PFTradeColumn_iPad quantityColumn ]
                        , [ PFTradeColumn_iPad priceColumn ]
                        , [ PFTradeColumn_iPad grossPlColumn ]
                        , [ PFTradeColumn_iPad commissionColumn ]
                        , [ PFTradeColumn_iPad netPlColumn ]
                        , [ PFTradeColumn_iPad accountColumn ]
                        , [ PFTradeColumn_iPad dateTimeColumn ]
                        , [ PFTradeColumn_iPad tradeIdColumn ]
                        , [ PFTradeColumn_iPad instrumentTypeColumn ]
                        , [ PFTradeColumn_iPad statusColumn ]
                        , [ PFTradeColumn_iPad orderIdColumn ]
                        , nil ];
   
   return [ self initWithColumns: columns_ ];
}

@end

@implementation PFAllOperationsDataSource_iPad

-(id)init
{
   NSArray* columns_ = [ NSArray arrayWithObjects: [ PFMarketOperationColumn_iPad symbolColumn ]
                        , [ PFMarketOperationColumn_iPad sideColumn ]
                        , [ PFMarketOperationColumn_iPad typeColumn ]
                        , [ PFMarketOperationColumn_iPad quantityColumn ]
                        , [ PFMarketOperationColumn_iPad priceColumn ]
                        , [ PFMarketOperationColumn_iPad stopPriceColumn ]
                        , [ PFMarketOperationColumn_iPad tifColumn ]
                        , [ PFMarketOperationColumn_iPad accountColumn ]
                        , [ PFMarketOperationColumn_iPad dateTimeColumn ]
                        , [ PFMarketOperationColumn_iPad instrumentTypeColumn ]
                        , [ PFMarketOperationColumn_iPad statusColumn ]
                        , [ PFMarketOperationColumn_iPad orderIdColumn ]
                        , nil ];
   
   return [ self initWithColumns: columns_ ];
}

@end
