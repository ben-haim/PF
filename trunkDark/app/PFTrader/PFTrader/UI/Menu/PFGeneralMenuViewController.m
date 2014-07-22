#import "PFGeneralMenuViewController.h"
#import "PFChatViewController.h"
#import "PFNavigationController.h"
#import "PFMenuTableViewCell.h"
#import "PFMenuItem.h"
#import "UIColor+Skin.h"
#import "UIImage+Icons.h"
#import "NSString+DoubleFormatter.h"
#import "UILabel+Price.h"

#import <JFF/Utils/NSArray+BlocksAdditions.h>
#import <ProFinanceApi/ProFinanceApi.h>

const int kColumnsCount = 3;

@interface PFGeneralMenuViewController () < PFSessionDelegate >

@property ( nonatomic, strong ) NSArray* menuItems;

@end

@implementation PFGeneralMenuViewController

@synthesize menuTable;
@synthesize accountInfoView;
@synthesize accountTitleLabel;
@synthesize accountValueLabel;
@synthesize balanceTitleLabel;
@synthesize balanceValueLabel;
@synthesize openNetPLTitleLabel;
@synthesize openNetPLValueLabel;
@synthesize marginTitleLabel;
@synthesize marginValueLabel;
@synthesize marginAvailableTitleLabel;
@synthesize marginAvailableValueLabel;
@synthesize chatButton;
@synthesize menuItems;
@synthesize currentItem;

-(void)dealloc
{
   self.currentItem = nil;
   self.menuItems = nil;
   
   [ [ PFSession sharedSession ] removeDelegate: self ];
   [ [ NSNotificationCenter defaultCenter ] removeObserver: self ];
}

-(id)initWithMenuItems:( NSArray* )menu_items_
{
   self = [ self initWithNibName: NSStringFromClass( [ PFGeneralMenuViewController class ] )
                          bundle: nil ];

   if ( self )
   {
      self.menuItems = menu_items_;
   }

   return self;
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];

   [ [ PFSession sharedSession ] addDelegate: self ];

   [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                               selector: @selector( badgeValueDidChangeNotification: )
                                                   name: PFMenuItemBadgeValueDidChangeNotification
                                                 object: nil ];

   self.accountInfoView.backgroundColor = [ UIColor colorWithRed: 26.f / 255.f green: 27.f / 255.f blue: 30.f / 255.f alpha: 1.f ];

   self.accountTitleLabel.textColor = [ UIColor grayTextColor ];
   self.balanceTitleLabel.textColor = [ UIColor grayTextColor ];
   self.openNetPLTitleLabel.textColor = [ UIColor grayTextColor ];
   self.marginTitleLabel.textColor = [ UIColor grayTextColor ];
   self.marginAvailableTitleLabel.textColor = [ UIColor grayTextColor ];

   self.accountValueLabel.textColor = [ UIColor mainTextColor ];
   self.balanceValueLabel.textColor = [ UIColor mainTextColor ];
   self.openNetPLValueLabel.textColor = [ UIColor mainTextColor ];
   self.marginValueLabel.textColor = [ UIColor mainTextColor ];
   self.marginAvailableValueLabel.textColor = [ UIColor mainTextColor ];

   [ self.chatButton setImage: [ UIImage chatIcon ] forState: UIControlStateNormal ];
   [ self.chatButton setImage: [ UIImage chatIcon ] forState: UIControlStateHighlighted ];
   self.chatButton.hidden = ![ PFChatViewController isAvailable ];

   self.accountTitleLabel.text = [ NSString stringWithFormat: @"%@:", NSLocalizedString( @"ACCOUNT", nil ) ];
   self.balanceTitleLabel.text = [ NSString stringWithFormat: @"%@:", NSLocalizedString( @"REPORT_BALANCE", nil ) ];
   self.openNetPLTitleLabel.text = [ NSString stringWithFormat: @"%@:", NSLocalizedString( @"OPEN_NET_PL", nil ) ];
   self.marginTitleLabel.text = [ NSString stringWithFormat: @"%@:", NSLocalizedString( @"CURRENT_MARGIN", nil ) ];
   self.marginAvailableTitleLabel.text = [ NSString stringWithFormat: @"%@:", NSLocalizedString( @"MARGIN_AVAILABLE", nil ) ];

   self.accountValueLabel.text = self.balanceValueLabel.text = self.marginValueLabel.text = self.marginAvailableValueLabel.text = self.openNetPLValueLabel.text = @"";
}

-(void)viewDidAppear:( BOOL )animated_
{
   [ super viewDidAppear: animated_ ];
   [ self.menuTable reloadData ];
}

-(void)updateMenuWithItems:( NSArray* )menu_items_
{
   self.menuItems = menu_items_;
   [ self.menuTable reloadData ];
}

-(IBAction)chatAction:( id )sender_
{
   [ self presentViewController: [ PFNavigationController navigationControllerWithController: [ PFChatViewController new ] ]
                       animated: YES
                     completion: nil ];
}

-(void)updateAccountValues
{
   id< PFAccount > default_account_ = [ PFSession sharedSession ].accounts.defaultAccount;

   self.accountValueLabel.text = default_account_.name;

   self.balanceValueLabel.text = [ NSString stringWithFormat: @"%@ %@", [ NSString stringWithMoney: default_account_.balance
                                                                                      andPrecision: default_account_.precision ], default_account_.currency ];

   self.marginValueLabel.text = [ NSString stringWithFormat: @"%@ %@", [ NSString stringWithMoney: default_account_.usedMargin
                                                                                     andPrecision: default_account_.precision ], default_account_.currency ];

   self.marginAvailableValueLabel.text = [ NSString stringWithFormat: @"%@ %@", [ NSString stringWithMoney: default_account_.marginAvailable
                                                                                              andPrecision: default_account_.precision ], default_account_.currency ];

   [ self.openNetPLValueLabel showPositiveNegativeColouredValue: default_account_.totalNetPl
                                                      precision: default_account_.precision
                                                       currency: default_account_.currency
                                              negativeTextColor: [UIColor redTextColor]
                                              positiveTextColor: [UIColor greenTextColor]
                                                  zeroTextColor: [UIColor mainTextColor]
                                                dashIfValueZero: NO isPositiveSign: NO ];

   [ self menuItemWithType: PFMenuItemTypePositions ].badgeValue = [PFSession sharedSession].accounts.allPositions.count;
   [ self menuItemWithType: PFMenuItemTypeOrders ].badgeValue = [PFSession sharedSession].accounts.allActiveOrders.count;
}

-(void)badgeValueDidChangeNotification:( NSNotification* )notification_
{
   [ self.menuTable reloadData ];
}

-(NSArray*)menuItemsForRow:( NSUInteger )row_
{
   NSUInteger start_index_ = row_ * kColumnsCount;

   if ( start_index_ > self.menuItems.count - 1 )
   {
      return nil;
   }
   else
   {
      NSUInteger needed_count_ = start_index_ + kColumnsCount;
      NSUInteger length_ = needed_count_ > self.menuItems.count ? kColumnsCount - ( needed_count_ - self.menuItems.count ) : kColumnsCount;

      return [ self.menuItems subarrayWithRange: NSMakeRange( start_index_, length_ ) ];
   }
}

-(PFMenuItem*)menuItemWithType:( PFMenuItemType )type_
{
   return [ self.menuItems firstMatch: ^BOOL( id object_ ) { return [ ( PFMenuItem* )object_ type ] == type_; } ];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:( UITableView* )table_view_ numberOfRowsInSection:( NSInteger )section_
{
   return ceilf( ( (float)self.menuItems.count ) / kColumnsCount );
}

-(UITableViewCell*)tableView:( UITableView* )table_view_
       cellForRowAtIndexPath:( NSIndexPath* )index_path_
{
   static NSString* cell_identifier_ = @"PFMenuTableViewCell";
   PFMenuTableViewCell* cell_ = ( PFMenuTableViewCell* )[ table_view_ dequeueReusableCellWithIdentifier: cell_identifier_ ];

   if ( !cell_ )
   {
      cell_ = [ [ PFMenuTableViewCell alloc ] initWithFrame: CGRectMake( 0, 0, self.menuTable.frame.size.width, 120.f )
                                            reuseIdentifier: cell_identifier_ ];
   }

   cell_.menuItems = [ self menuItemsForRow: index_path_.row ];
   cell_.menuController = self;

   return cell_;
}

#pragma mark - UITableViewDelegate

-(void)tableView:( UITableView* )table_view_ didSelectRowAtIndexPath:( NSIndexPath* )index_path_
{

}

- (CGFloat)tableView:( UITableView* )table_view_ heightForRowAtIndexPath:( NSIndexPath* )index_path_
{
   return 120.f;
}

#pragma - mark PFSessionDelegate

-(void)session:( PFSession* )session_
didLoadChatMessage:( id< PFChatMessage > )message_
{
   if ( message_.senderId != session_.user.userId )
   {
      [ self menuItemWithType: PFMenuItemTypeChat ].badgeValue++;
   }
}

-(void)session:( PFSession* )session_
didLoadStories:( NSArray* )stories_
{
   [ self menuItemWithType: PFMenuItemTypeNews ].badgeValue += stories_.count;
}

-(void)session:( PFSession* )session_
didUpdateAccount:( id< PFAccount > )account_
{
   if ( [ PFSession sharedSession ].accounts.defaultAccount == account_ )
   {
      [ self updateAccountValues ];
   }
}

-(void)session:( PFSession*)session_
didSelectDefaultAccount:( id< PFAccount > )account_
{
   [ self updateAccountValues ];
}

@end
