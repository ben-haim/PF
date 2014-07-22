#import "PFMarketOperationsDataSource.h"
#import "PFTableViewController.h"
#import "PFTableView.h"
#import "PFTableViewCategory+ActiveOperations.h"
#import "PFTableViewCategory+FilledOperations.h"
#import "PFTableViewCategory+AllOperations.h"

#import <ProFinanceApi/ProFinanceApi.h>
#import "PFNavigationController.h"
#import <JFFMessageBox/JFFMessageBox.h>

@interface PFMarketOperationsDataSource () < PFSessionDelegate >

@property ( nonatomic, weak ) PFTableViewController* controller;

@end

@implementation PFMarketOperationsDataSource

@synthesize controller;

-(void)dealloc
{
   [ [ PFSession sharedSession ] removeDelegate: self ];
}

-(void)updateCategoriesWithTitle:( NSString* )title_
{
   [self updateCategories];

   self.controller.pfNavigationWrapperController.title = title_;
   self.controller.pfNavigationController.navigationTitle = title_;
}

-(void)activateInController:( PFTableViewController* )controller_
{
   [ [ PFSession sharedSession ] addDelegate: self ];
   
   self.controller = controller_;
   self.controller.tableView.skipCellsBackground = YES;
   [ self updateCategories ];
}

-(void)deactivate
{
   self.controller = nil;
   [ [ PFSession sharedSession ] removeDelegate: self ];
}

-(NSArray*)categoriesWithController:( PFTableViewController* )controller_
{
   [ self doesNotRecognizeSelector: _cmd ];
   return nil;
}

-(NSString*)title
{
   [ self doesNotRecognizeSelector: _cmd ];
   return nil;
}

-(void)updateCategories
{
   if ( self.controller.pfNavigationWrapperController )
   {
      self.controller.pfNavigationWrapperController.navigationItem.rightBarButtonItem = nil;
   }
   else
   {
      self.controller.navigationItem.rightBarButtonItem = nil;
   }

   self.controller.tableView.categories = [ self categoriesWithController: self.controller ];
   [ self.controller.tableView reloadData ];
}

-(void)handleOperation:( id< PFMarketOperation > )operation_
{
   [ self updateCategories ];
}

#pragma mark - PFSessionDelegate

-(void)didReconnectedSessionWithNewSession:( PFSession* )session_
{
   [ [ PFSession sharedSession ] addDelegate: self ];
   [ self updateCategories ];
}

@end

@implementation PFActiveOperationsDataSource

-(NSString*)title
{
   return NSLocalizedString( @"ACTIVE_ORDERS", nil );
}

-(NSArray*)categoriesWithController:( PFTableViewController* )controller_
{
   UIBarButtonItem* right_button_ = [ [ UIBarButtonItem alloc ] initWithImage: [ UIImage imageNamed: @"PFTrashButton" ]
                                                                        style: UIBarButtonItemStylePlain
                                                                       target: self
                                                                       action: @selector( cancelAllOrders ) ];
   
   if ( controller_.pfNavigationWrapperController )
   {
      controller_.pfNavigationWrapperController.navigationItem.rightBarButtonItem = right_button_;
   }
   else
   {
      controller_.navigationItem.rightBarButtonItem = right_button_;
   }

   return [ PFTableViewCategory activeOperationCategoriesWithOrders: [ PFAccounts sortedOrdersByDateCreatedWithArray:
                                                                      [ PFSession sharedSession ].accounts.allActiveOrders ]
                                                         controller: controller_ ];
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

#pragma mark - PFSessionDelegate

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

-(NSString*)title
{
   return NSLocalizedString( @"FILLED", nil );
}

-(NSArray*)categoriesWithController:( PFTableViewController* )controller_
{
   return [ PFTableViewCategory filledOperationCategoriesWithTrades: [ PFAccounts sortedOrdersByDateCreatedWithArray:
                                                                      [ PFSession sharedSession ].accounts.allTrades ]
                                                         controller: controller_ ];
}

#pragma mark - PFSessionDelegate

-(void)session:( PFSession* )session_ didAddTrade:( id< PFTrade > )trade_
{
   [ self handleOperation: trade_ ];
}

@end

@implementation PFAllOperationsDataSource

-(NSString*)title
{
   return NSLocalizedString( @"ALL", nil );
}

-(NSArray*)categoriesWithController:( PFTableViewController* )controller_
{
   return [ PFTableViewCategory allOperationCategoriesWithOperations: [ PFAccounts sortedOrdersByDateCreatedWithArray:
                                                                       [ PFSession sharedSession ].accounts.allOperations ]
                                                          controller: controller_ ];
}

#pragma mark - PFSessionDelegate

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

-(void)session:( PFSession* )session_
   didAddTrade:( id< PFTrade > )trade_
{
   [ self handleOperation: trade_ ];
}

@end
