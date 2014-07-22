#import "PFMainMenuViewController.h"

#import "PFMenuItem.h"
#import "PFMenuItemCell.h"

#import "DDMenuController+PFTrader.h"
#import "UIColor+Skin.h"
#import "PFSystemHelper.h"

#import <JFF/Utils/NSArray+BlocksAdditions.h>

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFMainMenuViewController ()< UITableViewDataSource, UITableViewDelegate, PFSessionDelegate >

@property ( nonatomic, strong ) UITableView* tableView;
@property ( nonatomic, strong ) NSArray* items;
@property ( nonatomic, strong ) PFMenuItem* currentItem;
@property ( nonatomic, strong ) UILabel* accountName;
@property ( nonatomic, strong ) UILabel* accountValue;

@end

@implementation PFMainMenuViewController

@synthesize tableView = _tableView;
@synthesize accountName;
@synthesize accountValue;
@synthesize items;
@synthesize currentItem;

-(void)dealloc
{
   self.accountName = nil;
   self.accountValue = nil;
   
   _tableView.dataSource = nil;
   _tableView.delegate = nil;
   _tableView = nil;
   
   [ [ PFSession sharedSession ] removeDelegate: self ];
   [ [ NSNotificationCenter defaultCenter ] removeObserver: self ];

   self.tableView = nil;
   self.accountName = nil;
   self.accountValue = nil;
}

-(id)initWithItems:( NSArray* )items_
{
   self = [ super init ];
   if ( self )
   {
      self.items = items_;
   }
   return self;
}

-(UITableView*)tableView
{
   if ( !_tableView )
   {
      _tableView = [ [ UITableView alloc ] initWithFrame: CGRectZero style: UITableViewStylePlain ];
      _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
      _tableView.backgroundColor = [ UIColor clearColor ];
      _tableView.dataSource = self;
      _tableView.delegate = self;
   }
   return _tableView;
}

-(UILabel*)accountLabelWithFrame:( CGRect )frame_rect_
                       textColor:( UIColor* )color_
                        fontSize:( CGFloat ) font_size_
{
   UILabel* account_label_ = [ [ UILabel alloc ] initWithFrame: frame_rect_ ];
   account_label_.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
   
   account_label_.font = [ UIFont systemFontOfSize: font_size_ ];
   account_label_.textColor = color_;
   
   account_label_.shadowColor = [ UIColor clearColor ];
   account_label_.shadowOffset = CGSizeMake( 0.f, 0.f );
   account_label_.backgroundColor = [ UIColor clearColor ];
   account_label_.textAlignment = NSTextAlignmentLeft;
   
   return account_label_;
}

-(void)setAccountValueString:( NSString* )name_
{
   self.accountValue.text = name_;
   [ self.accountValue sizeToFit ];
}

-(void)loadView
{
   self.view = [ [ UIView alloc ] initWithFrame: [ UIScreen mainScreen ].bounds ];
   self.view.backgroundColor = [ UIColor mainBackgroundColor ];

   CGRect header_rect_ = CGRectZero;
   CGRect footer_rect_ = CGRectZero;

   CGFloat footer_height_ = 80.f;

   CGRect display_rect_ = self.view.bounds;
   display_rect_.size.width = [ DDMenuController displayControllerWidth ];

   CGRectDivide( display_rect_
                , &footer_rect_
                , &header_rect_
                , footer_height_
                , CGRectMaxYEdge );

   footer_rect_.origin.x += 10.f;
   footer_rect_.size.width -= 10.f;
   
   if ( useFlatUI() )
   {
      header_rect_.origin.y += 20;
      header_rect_.size.height -= 20;
   }
   
   self.tableView.frame = header_rect_;
   self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin;

   [ self.view addSubview: self.tableView ];

   UIView* account_view_ = [ [ UIView alloc ] initWithFrame: footer_rect_ ];
   account_view_.contentMode = UIViewContentModeTop;
   account_view_.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
   account_view_.backgroundColor = [ UIColor clearColor ];
   
   [ self.view addSubview: account_view_ ];
   
   CGRect name_rect_ = CGRectZero;
   CGRect value_rect_ = CGRectZero;
   CGFloat value_height_ = 60.f;
   
   CGRectDivide( account_view_.bounds
                , &value_rect_
                , &name_rect_
                , value_height_
                , CGRectMaxYEdge );
   
   self.accountName = [ self accountLabelWithFrame: name_rect_
                                         textColor: [ UIColor colorWithRed: 100.f / 255 green: 100.f / 255 blue: 100.f / 255 alpha: 1.f ]
                                          fontSize: 15.f ];
   self.accountName.text = [ NSString stringWithFormat: @"%@:", NSLocalizedString( @"ACTIVE_ACCOUNT",  nil ) ];
   [ account_view_ addSubview: self.accountName ];
   
   self.accountValue = [ self accountLabelWithFrame: value_rect_
                                          textColor: [ UIColor colorWithRed: 212.f / 255 green: 212.f / 255 blue: 212.f / 255 alpha: 1.f ]
                                           fontSize: 36.f ];
   [ self setAccountValueString: [ PFSession sharedSession ].accounts.defaultAccount.name ];
   [ account_view_ addSubview: self.accountValue ];
}

-(void)badgeValueDidChangeNotification:( NSNotification* )notification_
{
   PFMenuItem* sender_item_ = [ notification_ object ];

   if ( sender_item_ == self.currentItem && sender_item_.badgeValue != 0 )
   {
      sender_item_.badgeValue = 0;
      return;
   }

   NSUInteger index_ = [ self.items indexOfObject: sender_item_ ];
   //From separate menu
   if ( index_ == NSNotFound && sender_item_.badgeValue == 0 )
   {
      [ self menuItemWithType: sender_item_.type ].badgeValue = 0;
   }
   else
   {
      [ self.tableView reloadData ];
   }
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];

   [ [ PFSession sharedSession ] addDelegate: self ];

   [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                               selector: @selector( badgeValueDidChangeNotification: )
                                                   name: PFMenuItemBadgeValueDidChangeNotification
                                                 object: nil ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ self.items count ];
}

-(UITableViewCell*)tableView:( UITableView* )table_view_
       cellForRowAtIndexPath:( NSIndexPath* )index_path_
{
   static NSString* cell_identifier_ = @"PFMenuItemCell";
   PFMenuItemCell* cell_ = ( PFMenuItemCell* )[ table_view_ dequeueReusableCellWithIdentifier: cell_identifier_ ];
   
   if ( !cell_ )
   {
      cell_ = [ PFMenuItemCell cell ];
   }

   cell_.menuItem = [ self.items objectAtIndex: index_path_.row ];

   return cell_;
}

#pragma mark - Table view delegate

- (void)tableView:( UITableView* )table_view_ didSelectRowAtIndexPath:(NSIndexPath *)index_path_
{
   PFMenuItem* menu_item_ = [ self.items objectAtIndex: index_path_.row ];

   if ( self.menuController.showRootInProgress )
      return;

   self.currentItem = menu_item_;

   menu_item_.badgeValue = 0;
   
   UIViewController* controller_ = menu_item_.controller;
   if ( controller_ )
   {
      [ self.menuController pushRootController: controller_ animated: YES ];
   }
   else
   {
      [ menu_item_ performAction ];
   }
}

-(PFMenuItem*)menuItemWithType:( PFMenuItemType )type_
{
   return [ self.items firstMatch: ^BOOL( id object_ )
           {
              PFMenuItem* item_ = ( PFMenuItem* )object_;
              return item_.type == type_;
           }];
}

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
   [ self menuItemWithType: PFMenuItemTypeNews ].badgeValue += [ stories_ count ];
}

-(void)session:( PFSession* )session_
didAddPosition:( id< PFPosition > )position_
{
   [ self menuItemWithType: PFMenuItemTypePositions ].badgeValue++;
}

-(void)session:( PFSession*)session_
didSelectDefaultAccount:( id< PFAccount > )account_
{
   [ self setAccountValueString: account_.name ];
}

@end
