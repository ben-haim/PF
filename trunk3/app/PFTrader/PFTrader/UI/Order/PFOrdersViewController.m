#import "PFOrdersViewController.h"

#import "PFModifyOrderViewController.h"
#import "PFGridView.h"
#import "PFOrderColumn.h"

#import <ProFinanceApi/ProFinanceApi.h>
#import <JFFMessageBox/JFFMessageBox.h>

@class PFGridFooterView;

@interface PFOrdersViewController ()< PFSessionDelegate >

@end

@implementation PFOrdersViewController

//!Workaround for assign delegate
-(void)dealloc
{
   [ [ PFSession sharedSession ] removeDelegate: self ];
}

-(id)init
{
   self = [ super init ];
   if ( self )
   {
      self.title = NSLocalizedString( @"ORDERS", nil );
   }
   return self;
}

-(void)viewDidLoad
{
   PFSession* session_ = [ PFSession sharedSession ];
   [ session_ addDelegate: self ];
   
   self.elements = [PFAccounts sortedOrdersByDateCreatedWithArray: session_.accounts.allActiveOrders];
   
   self.columns = [ NSArray arrayWithObjects: [ PFOrderColumn symbolColumn ]
                   , [ PFOrderColumn quantityColumn ]
                   , [ PFOrderColumn typeColumn ]
                   , [ PFOrderColumn lastColumn ]
                   , [ PFOrderColumn tifColumn ]
                   , [ PFOrderColumn instrumentColumn ]
                   , [ PFOrderColumn orderIdColumn ]
                   , nil ];

   [ super viewDidLoad ];
}

#pragma mark PFGridFooterViewDelegate

-(void)didTapSummaryInFootterView:( PFGridFooterView* )footer_view_
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
   [ action_sheet_ showInView: self.view ];
}

-(void)gridView:( PFGridView* )grid_view_
didSelectRowAtIndex:( NSUInteger )row_index_
{
   [ [ [ PFModifyOrderViewController alloc ] initWithOrder: [ self.elements objectAtIndex: row_index_ ] ] showControllerWithController: self ];
}

-(void)handleOrder:( id< PFOrder > )order_
{
   PFSession* session_ = [ PFSession sharedSession ];
   self.elements = [PFAccounts sortedOrdersByDateCreatedWithArray: session_.accounts.allActiveOrders];
   [ self reloadData ];
}

-(void)session:( PFSession* )session_
   didAddOrder:( id< PFOrder > )order_
{
   [ self handleOrder: order_ ];
}

-(void)session:( PFSession* )session_
didRemoveOrder:( id< PFOrder > )order_
{
   [ self handleOrder: order_ ];
}

-(void)session:( PFSession* )session_
didUpdateOrder:( id< PFOrder > )order_
{
   //[ self handleOrder: order_ ];
}

@end