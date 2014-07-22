#import "PFModifyPositionViewController.h"

#import "PFTableView.h"
#import "PFTableViewCategory+MarketOperation.h"

#import "NSString+DoubleFormatter.h"

#import "PFSettings.h"

#import "UIColor+Skin.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFModifyPositionViewController ()

@property ( nonatomic, strong ) id< PFPosition > position;
@property ( nonatomic, strong ) NSArray* categories;

@end

@implementation PFModifyPositionViewController

@synthesize position;
@synthesize categories = _categories;
@synthesize modifyButton;
@synthesize closeButton;
@synthesize bidTextLabel;
@synthesize askTextLabel;

+(void)showWithPosition:( id< PFPosition > )position_
{
   [ [ [ PFModifyPositionViewController alloc ] initWithPosition: position_ ] showAsDialog ];
}

-(PFMarketOperationType)operationType
{
   return self.position.operationType;
}

-(NSArray*)categories
{
   if ( self.position.strikePrice > 0 )
      return nil;
   
   if ( !_categories )
   {
      self.slCategory = [ PFTableViewCategory stopLossCategoryWithController: self marketOperation: self.position ];
      self.tpCategory = [ PFTableViewCategory takeProfitCategoryWithController: self marketOperation: self.position ];
      
      _categories = @[self.slCategory
                     , self.tpCategory];
   }
   return _categories;
}

-(id)initWithPosition:( id< PFPosition > )position_
{
   self = [ super initWithTitle: NSLocalizedString( @"MODIFY_POSITION", nil ) symbol: position_.symbol ];
   
   if ( self )
   {
      self.position = position_;
   }
   
   return self;
}

-(void)dealloc
{
   self.modifyButton = nil;
   self.closeButton = nil;
   self.bidTextLabel = nil;
   self.askTextLabel = nil;
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];

   NSString* operation_type_ = self.position.operationType == PFMarketOperationBuy
      ? NSLocalizedString( @"LONG", nil )
      : NSLocalizedString( @"SHORT", nil );
   
   [ self.modifyButton setTitle: NSLocalizedString( @"MODIFY_POSITION_BUTTON", nil ) forState: UIControlStateNormal ];
   [ self.closeButton setTitle: NSLocalizedString( @"CLOSE_POSITION_BUTTON", nil ) forState: UIControlStateNormal ];

   self.overviewLabel.text = [ operation_type_ stringByAppendingFormat: @" %@"
                              , [ NSString stringWithDouble: self.position.openPrice
                                                  precision: self.position.symbol.instrument.precision ] ];
   
   self.tableView.categories = self.categories;
   
   if ( self.categories.count == 0 )
   {
      NSDateFormatter* date_formatter_ = [ [ NSDateFormatter alloc ] init ];
      date_formatter_.dateFormat = @"MMM dd";
      
      self.nameLabel.text = [ NSString stringWithFormat: @"%@ %@ %@ %@"
                             , self.symbol.instrumentName
                             , self.position.optionType == PFSymbolOptionTypeCallVanilla ? @"C" : @"P"
                             , [ date_formatter_ stringFromDate: self.position.expirationDate ]
                             , [ NSString stringWithPrice: self.position.strikePrice symbol: self.symbol ] ];
      
      
      self.modifyButton.hidden = self.askLabel.hidden = self.askTextLabel.hidden = self.bidTextLabel.hidden = self.bidLabel.hidden = YES;
      self.closeButton.frame = self.modifyButton.frame;
   }
   
   [ self.tableView reloadData ];
}

-(void)viewDidUnload
{
   self.modifyButton = nil;
   self.closeButton = nil;
   self.bidTextLabel = nil;
   self.askTextLabel = nil;
   
   [ super viewDidUnload ];
}

-(void)updateButtonsVisibility
{
   self.modifyButton.hidden = ![ [ PFSession sharedSession ] allowsModifyOperationsForSymbol: self.position.symbol ] || ![ self.position.account allowsSLTP ];
//   self.closeButton.hidden = ![ [ PFSession sharedSession ] allowsPlaceOperationsForSymbol: self.position.symbol ];
   self.closeButton.hidden = YES; // За ненадобностью

   if (self.modifyButton.hidden)
      self.closeButton.frame = self.modifyButton.frame;

   [ self.tableView reloadData ];
}

-(void)closePosition
{
   [ [ PFSession sharedSession ] closePosition: self.position ];
   [ self close ];
}

-(void)modifyPosition
{
   id< PFMutablePosition > modified_position_ = [ self.position mutablePosition ];
   
   [ self.categories makeObjectsPerformSelector: @selector( performApplierForObject: )
                                     withObject: modified_position_ ];
   
   if ( !( ( (float) self.position.stopLossPrice ) == ( (float) modified_position_.stopLossPrice )
          && ( (float) self.position.takeProfitPrice ) == ( (float) modified_position_.takeProfitPrice )
          && ( (float) self.position.slTrailingOffset ) == ( (float) modified_position_.slTrailingOffset ) ) )
   {
      if ( [ self checkSLTPForMarketOperation: modified_position_ ] )
      {
         [ [ PFSession sharedSession ] replacePosition: self.position
                                          withPosition: modified_position_ ];
      }
   }
   
   [ self close ];
}

-(IBAction)modifyPositionAction:( id )sender_
{
   if ( [ PFSettings sharedSettings ].shouldConfirmModifyPosition )
   {
      [ PFMarketOperationViewController showConfirmWithText: NSLocalizedString( @"MODIFY_POSITION_CONFIRMATION", nil )
                                                 actionText: NSLocalizedString( @"MODIFY_POSITION_BUTTON", nil )
                                         confirmActionBlock: ^{ [ self modifyPosition ]; } ];
   }
   else
   {
      [ self modifyPosition ];
   }
}

-(IBAction)closePositionAction:( id )sender_
{
   if ( [ PFSettings sharedSettings ].shouldConfirmClosePosition )
   {
      [ PFMarketOperationViewController showConfirmWithText: NSLocalizedString( @"CLOSE_CONFIRMATION", nil )
                                                 actionText: NSLocalizedString( @"CLOSE_POSITION", nil )
                                         confirmActionBlock: ^{ [ self closePosition ]; } ];
   }
   else
   {
      [ self closePosition ];
   }
}

#pragma mark - PFSessionDelegate

-(void)session:( PFSession* )session_
didRemovePosition:( id< PFPosition > )position_
{
   if ( position_.positionId == self.position.positionId )
   {
      [ self close ];
   }
}

@end
