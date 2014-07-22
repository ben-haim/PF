#import "PFMarketOperationsDataSource.h"

#import "PFOrderColumn.h"
#import "PFTradeColumn.h"

#import "PFModifyOrderViewController.h"
#import "PFGridViewController.h"
#import "PFGridView.h"

#import <ProFinanceApi/ProFinanceApi.h>
#import <JFFMessageBox/JFFMessageBox.h>

@interface PFMarketOperationsDataSource ()< PFSessionDelegate >

@property ( nonatomic, weak ) PFGridViewController* controller;
@property ( nonatomic, strong ) NSArray* columns;

@end

@implementation PFMarketOperationsDataSource

@synthesize controller;
@synthesize columns;

//!Workaround for assign delegate
-(void)dealloc
{
   [ [ PFSession sharedSession ] removeDelegate: self ];
}

-(id)initWithColumns:( NSArray* )columns_
{
   self = [ super init ];
   if ( self )
   {
      self.columns = columns_;
   }
   return self;
}

-(BOOL)summaryButtonHidden
{
   return YES;
}

-(void)activateInController:( PFGridViewController* )controller_
{
   PFSession* session_ = [ PFSession sharedSession ];
   [ session_ addDelegate: self ];
   
   controller_.elements = self.elements;
   controller_.columns = self.columns;

   [ controller_ setSummaryButtonHidden: self.summaryButtonHidden ];
   
   [ controller_ reloadData ];

   self.controller = controller_;
}

-(void)deactivate
{
   self.controller = nil;
   [ [ PFSession sharedSession ] removeDelegate: self ];
}

-(NSArray*)elements
{
   return nil;
}

-(NSString*)title
{
   [ self doesNotRecognizeSelector: _cmd ];
   return nil;
}

-(void)selectElementAtIndex:( NSUInteger )index_
{
}

-(void)showSummaryActions
{
   NSAssert( [ self summaryButtonHidden ], @"Should have summary action" );
}

-(void)cancelAllOrders
{
   JFFAlertButton* cancel_all_button_ = [ JFFAlertButton alertButton: NSLocalizedString( @"CANCEL_ALL", nil )
                                                              action: ^( JFFAlertView* sender_ )
                                         {
                                            PFSession* session_ = [ PFSession sharedSession ];
                                            [ session_ cancelAllOrdersForAccount: nil ];
                                         } ];
   
   JFFActionSheet* action_sheet_ = [ JFFActionSheet actionSheetWithTitle: NSLocalizedString( @"CANCEL_ALL_ORDERS_PROMPT", nil )
                                                       cancelButtonTitle: NSLocalizedString( @"CANCEL", nil )
                                                  destructiveButtonTitle: cancel_all_button_
                                                       otherButtonsArray: nil ];
   
   action_sheet_.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
   [ action_sheet_ showInView: self.controller.view ];
}

-(void)handleOperation:( id< PFMarketOperation > )operation_
{
   self.controller.elements = self.elements;
   [ self.controller reloadData ];
}

-(void)didReconnectedSessionWithNewSession:( PFSession* )session_
{
   [ [ PFSession sharedSession ] addDelegate: self ];
   
   self.controller.elements = self.elements;
   [ self.controller reloadData ];
}

@end

@implementation PFActiveOperationsDataSource

-(id)init
{
   NSArray* columns_ = [ NSArray arrayWithObjects: [ PFOrderColumn symbolColumn ]
                        , [ PFOrderColumn quantityColumn ]
                        , [ PFOrderColumn typeColumn ]
                        , [ PFOrderColumn lastColumn ]
                        , [ PFOrderColumn tifColumn ]
                        , [ PFOrderColumn instrumentColumn ]
                        , [ PFOrderColumn orderIdColumn ]
                        , nil ];

   return [ self initWithColumns: columns_ ];
}

-(NSString*)title
{
   return NSLocalizedString( @"ACTIVE_ORDERS", nil );
}

-(NSArray*)elements
{
   return [PFAccounts sortedOrdersByDateCreatedWithArray: [ PFSession sharedSession ].accounts.allActiveOrders];
}

-(void)selectElementAtIndex:( NSUInteger )index_
{
   id< PFOrder > order_ = [ self.elements objectAtIndex: index_ ];
   
   if ( ![ [ PFSession sharedSession ] allowsTradingForSymbol: order_.symbol ] )
      return;
   
   [ [ [ PFModifyOrderViewController alloc ] initWithOrder: order_ ] showControllerWithController: self.controller ];
}

-(void)showSummaryActions
{
   [ self cancelAllOrders ];
}

-(BOOL)summaryButtonHidden
{
   return NO;
}

#pragma mark PFSessionDelegate

-(void)session:( PFSession* )session_
   didAddOrder:( id< PFOrder > )order_
{
   [ self handleOperation: order_ ];
}

-(void)session:( PFSession* )session_
didRemoveOrder:( id< PFOrder > )order_
{
   [ self handleOperation: order_ ];
}

@end

@implementation PFFilledOperationsDataSource

-(id)init
{
   NSArray* columns_ = [ NSArray arrayWithObjects: [ PFTradeColumn symbolColumn ]
                        , [ PFTradeColumn quantityColumn ]
                        , [ PFTradeColumn typeColumn ]
                        , [ PFTradeColumn grossPlColumn ]
                        , [ PFTradeColumn netPlColumn ]
                        , [ PFTradeColumn instrumentColumn ]
                        , [ PFTradeColumn orderIdColumn ]
                        , nil ];

   return [ self initWithColumns: columns_ ];
}

-(NSString*)title
{
   return NSLocalizedString( @"FILLED", nil );
}

-(NSArray*)elements
{
   return [PFAccounts sortedOrdersByDateCreatedWithArray: [ PFSession sharedSession ].accounts.allTrades];
}

-(BOOL)summaryButtonHidden
{
   return YES;
}

#pragma mark PFSessionDelegate

-(void)session:( PFSession* )session_ didAddTrade:( id< PFTrade > )trade_
{
   [ self handleOperation: trade_ ];
}

@end

@implementation PFAllOperationsDataSource

-(id)init
{
   NSArray* columns_ = [ NSArray arrayWithObjects: [ PFMarketOperationColumn symbolColumn ]
                        , [ PFMarketOperationColumn quantityColumn ]
                        , [ PFMarketOperationColumn typeColumn ]
                        , [ PFMarketOperationColumn accountColumn ]
                        , [ PFMarketOperationColumn tifColumn ]
                        , [ PFMarketOperationColumn instrumentTypeColumn ]
                        , [ PFMarketOperationColumn statusColumn ]
                        , nil ];

   return [ self initWithColumns: columns_ ];
}

-(NSString*)title
{
   return NSLocalizedString( @"ALL", nil );
}

-(NSArray*)elements
{
   return [PFAccounts sortedOrdersByDateCreatedWithArray: [ PFSession sharedSession ].accounts.allOperations];
}

-(BOOL)summaryButtonHidden
{
   return YES;
}

#pragma mark PFSessionDelegate

-(void)session:( PFSession* )session_
   didAddOrder:( id< PFOrder > )order_
{
   [ self handleOperation: order_ ];
}

-(void)session:( PFSession* )session_
didRemoveOrder:( id< PFOrder > )order_
{
   [ self handleOperation: order_ ];
}

-(void)session:( PFSession* )session_ didAddTrade:( id< PFTrade > )trade_
{
   [ self handleOperation: trade_ ];
}

@end


