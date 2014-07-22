#import "PFModifyOrderViewController.h"

#import "PFTableView.h"
#import "PFTableViewCategory+Order.h"
#import "PFTableViewCategory+MarketOperation.h"

#import "PFOrderTypeConversion.h"
#import "PFMarketOperationTypeConversion.h"

#import "UIColor+Skin.h"

#import "PFSettings.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFModifyOrderViewController ()

@property ( nonatomic, strong ) id< PFOrder > order;
@property ( nonatomic, strong ) NSArray* categories;

@end

@implementation PFModifyOrderViewController

@synthesize order;
@synthesize categories = _categories;

@synthesize modifyButton;
@synthesize cancelButton;
@synthesize executeButton;

-(PFMarketOperationType)operationType
{
   return self.order.operationType;
}

-(NSArray*)categories
{
   if ( !_categories )
   {
      NSMutableArray* categories_ = [ NSMutableArray arrayWithObjects: [ PFTableViewCategory orderTypeCategoryWithController: self order: self.order ]
                                     , [ PFTableViewCategory quantityCategoryWithController: self order: self.order ]
                                     , nil ];

      if ( self.order.symbol.allowsTifModification )
      {
         self.validityCategory = [ PFTableViewCategory validityCategoryWithOrder: self.order
                                                                      controller: self ];
         [ categories_ addObject: self.validityCategory ];
      }

      self.slCategory = [ PFTableViewCategory stopLossCategoryWithController: self marketOperation: self.order ];
      self.tpCategory = [ PFTableViewCategory takeProfitCategoryWithController: self marketOperation: self.order ];
      
      [ categories_ addObjectsFromArray: @[ self.slCategory, self.tpCategory ] ];

      _categories = categories_;
   }
   return _categories;
}

-(void)dealloc
{
   self.modifyButton = nil;
   self.cancelButton = nil;
   self.executeButton = nil;
}

-(id)initWithOrder:( id< PFOrder > )order_
{
   self = [ super initWithTitle: NSLocalizedString( @"MODIFY_ORDER", nil ) symbol: order_.symbol ];

   if ( self )
   {
      self.order = order_;
   }

   return self;
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];

   [ self.modifyButton setTitle: NSLocalizedString( @"MODIFY_ORDER_BUTTON", nil ) forState: UIControlStateNormal ];
   [ self.cancelButton setTitle: NSLocalizedString( @"CANCEL_ORDER_BUTTON", nil ) forState: UIControlStateNormal ];
   [ self.executeButton setTitle: NSLocalizedString( @"EXECUTE_ORDER_BUTTON", nil ) forState: UIControlStateNormal ];
   
   self.overviewLabel.text = [ NSStringFromPFMarketOperationType( self.order.operationType ) stringByAppendingFormat: @" %@", NSStringFromPFOrderType( self.order.orderType ) ];

   self.tableView.categories = self.categories;
   [ self.tableView reloadData ];
}

-(void)updateButtonsVisibility
{
   self.modifyButton.hidden = ![ [ PFSession sharedSession ] allowsModifyOperationsForSymbol: self.order.symbol ];
   self.cancelButton.hidden = ![ [ PFSession sharedSession ] allowsCancelOperationsForSymbol: self.order.symbol ];
   self.executeButton.hidden = ![ [ PFSession sharedSession ] allowsPlaceOperationsForSymbol: self.order.symbol ];

   if ( self.modifyButton.isHidden)
   {
      self.executeButton.frame = self.cancelButton.frame;
      self.cancelButton.frame = self.modifyButton.frame;
   }

   if (self.cancelButton.isHidden)
      self.executeButton.frame = self.cancelButton.frame;

   [self.tableView reloadData];
}

-(void)modifyOrder
{
   id< PFMutableOrder > modified_order_ = [ self.order mutableOrder ];
   
   [ self.categories makeObjectsPerformSelector: @selector( performApplierForObject: )
                                     withObject: modified_order_ ];
   
   if ( !( self.order.price == modified_order_.price
          && self.order.stopPrice == modified_order_.stopPrice
          && self.order.amount == modified_order_.amount
          && self.order.validity == modified_order_.validity
          && ( (float) self.order.stopLossPrice ) == ( (float) modified_order_.stopLossPrice )
          && ( (float) self.order.takeProfitPrice ) == ( (float) modified_order_.takeProfitPrice )
          && ( (float) self.order.slTrailingOffset ) == ( (float) modified_order_.slTrailingOffset )
          && self.order.expireAtDate == modified_order_.expireAtDate ) )
   {
      if ( [ self checkSLTPForMarketOperation: modified_order_ ] )
      {
         [ [ PFSession sharedSession ] replaceOrder: self.order
                                          withOrder: modified_order_ ];
      }
   }
   
   [ self close ];
}

-(void)cancelOrder
{
   [ [ PFSession sharedSession ] cancelOrder: self.order ];
   [ self close ];
}

-(void)executeOrder
{
   [ [ PFSession sharedSession ] executeOrder: self.order ];
   [ self close ];
}

-(IBAction)modifyOrderAction:( id )sender_
{
   
   if ( [ PFSettings sharedSettings ].shouldConfirmModifyOrder )
   {
      [ PFMarketOperationViewController showConfirmWithText: NSLocalizedString( @"MODIFY_CONFIRMATION", nil )
                                                 actionText: NSLocalizedString( @"MODIFY_ORDER_BUTTON", nil )
                                         confirmActionBlock: ^{ [ self modifyOrder ]; } ];
   }
   else
   {
      [ self modifyOrder ];
   }  
}

-(IBAction)cancelOrderAction:( id )sender_
{
   if ( [ PFSettings sharedSettings ].shouldConfirmCancelOrder )
   {
      [ PFMarketOperationViewController showConfirmWithText: NSLocalizedString( @"CANCEL_CONFIRMATION", nil )
                                                 actionText: NSLocalizedString( @"CANCEL_ORDER_BUTTON", nil )
                                         confirmActionBlock: ^{ [ self cancelOrder ]; } ];
   }
   else
   {
      [ self cancelOrder ];
   }
}

-(IBAction)executeAtMarketAction:( id )sender_
{
   if ( [ PFSettings sharedSettings ].shouldConfirmExecuteAsMarket )
   {
      [ PFMarketOperationViewController showConfirmWithText: NSLocalizedString( @"EXECUTE_CONFIRMATION", nil )
                                                 actionText: NSLocalizedString( @"EXECUTE_ORDER_BUTTON", nil )
                                         confirmActionBlock: ^{ [ self executeOrder ]; } ];
   }
   else
   {
      [ self executeOrder ];
   }
}

-(void)session:( PFSession* )session_
didRemoveOrder:( id< PFOrder > )order_
{
   if ( order_.orderId == self.order.orderId )
   {
      [ self remove ];
   }
}

@end
