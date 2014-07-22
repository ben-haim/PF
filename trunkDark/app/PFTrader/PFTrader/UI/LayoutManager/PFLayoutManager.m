#import "PFLayoutManager.h"

#import "PFGeneralMenuViewController.h"
#import "PFMenu.h"
#import "PFMenuItem.h"
#import "UIViewController+Wrapper.h"
#import "UIImage+Icons.h"
#import "PFSettings.h"
#import "PFAppDelegate.h"
#import "PFModalWindow.h"
#import "PFNavigationController.h"

#import "PFAccountsViewController.h"
#import "PFPositionsViewController.h"
#import "PFWatchlistViewController.h"
#import "PFNewsViewController.h"
#import "PFChatViewController.h"
#import "PFSettingsViewController.h"
#import "PFMarketOperationsViewController.h"
#import "PFLoginViewController.h"
#import "PFLoadViewController.h"
#import "PFEventLogViewController.h"
#import "PFSecureLogsController.h"
#import "PFChartViewController.h"

//iPad specific
#import "PFGeneralMenuViewController_iPad.h"
#import "PFAccountsViewController_iPad.h"
#import "PFNewsViewController_iPad.h"
#import "PFMarketOperationsViewController_iPad.h"
#import "PFWatchlistViewController_iPad.h"
#import "PFPositionsViewController_iPad.h"
#import "PFLoginViewController_iPad.h"
#import "PFLoadViewController_iPad.h"
#import "PFEventLogViewController_iPad.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFMenuItem (PFLayoutManager)

+(id)menuItemWithWatchlist:( id< PFWatchlist > )watchlist_
            watchlistClass:( Class )watchlist_class_;

+(id)menuItemChartWithWatchlist:( id< PFWatchlist > )watchlist_
                     chartClass:( Class )chart_class_;

+(id)newsItem;
+(id)newsItem_iPad;
+(id)chatItem;
+(id)eventLogItem;
+(id)eventLogItem_iPad;
+(id)secureLogItem;

@end


@implementation PFMenuItem (PFLayoutManager)

+(id)menuItemChartWithWatchlist:( id< PFWatchlist > )watchlist_
                     chartClass:( Class )chart_class_
{
   PFMenuItemControllerBuilder controller_builder_ = ^UIViewController*()
   {
      return [ [ chart_class_ alloc ] initWithSymbol: nil ];
   };
   
   return [ self itemWithControllerBuilder: controller_builder_
                                     title: NSLocalizedString( @"CHART", nil )
                                      icon: [ UIImage chartIcon ] ];
}

+(id)menuItemWithWatchlist:( id< PFWatchlist > )watchlist_
            watchlistClass:( Class )watchlist_class_
{
   PFMenuItemControllerBuilder controller_builder_ = ^UIViewController*()
   {
      return [ [ watchlist_class_ alloc ] initWithWatchlist: watchlist_ ];
   };

   return [ self itemWithControllerBuilder: controller_builder_
                                     title: NSLocalizedString( @"WATCHLIST", nil )
                                      icon: [ UIImage watchlistIcon ] ];
}

+(id)newsItem
{
   PFMenuItem* news_item_ = [ PFMenuItem itemWithNewsControllerClass: [ PFNewsViewController class ] ];
   
   news_item_.visibilityPredicate = ^BOOL( PFMenuItem* item_ )
   {
      return [ PFNewsViewController isAvailable ];
   };
   
   return news_item_;
}

+(id)newsItem_iPad
{
   PFMenuItem* news_item_ = [ PFMenuItem itemWithNewsControllerClass: [ PFNewsViewController_iPad class ] ];
   
   news_item_.visibilityPredicate = ^BOOL( PFMenuItem* item_ )
   {
      return [ PFNewsViewController isAvailable ];
   };
   
   return news_item_;
}

+(id)eventLogItem
{
   PFMenuItem* events_item_ = [ PFMenuItem itemWithEventsControllerClass: [ PFEventLogViewController class ] ];
   
   events_item_.visibilityPredicate = ^BOOL( PFMenuItem* item_ )
   {
      return [ PFEventLogViewController isAvailable ];
   };
   
   return events_item_;
}

+(id)eventLogItem_iPad
{
   PFMenuItem* events_item_ = [ PFMenuItem itemWithEventsControllerClass: [ PFEventLogViewController_iPad class ] ];
   
   events_item_.visibilityPredicate = ^BOOL( PFMenuItem* item_ )
   {
      return [ PFEventLogViewController isAvailable ];
   };
   
   return events_item_;
}

+(id)secureLogItem
{
   PFMenuItem* log_item_ = [ PFMenuItem itemWithSecureLogsControllerClass: [ PFSecureLogsController class ] ];
   
   log_item_.visibilityPredicate = ^BOOL( PFMenuItem* item_ )
   {
      return [ PFSecureLogsController isAvailable ];
   };
   
   return log_item_;
}

+(id)chatItem
{
   PFMenuItem* chat_item_ = [ PFMenuItem itemWithAction: ^
                             {
                                PFNavigationController* navigation_controller_ = [ PFNavigationController navigationControllerWithController: [ PFChatViewController new ] ];
                                navigation_controller_.useCloseButton = YES;
                                
                                [ PFModalWindow showWithNavigationController: navigation_controller_ ];
                             }
                                                  title: NSLocalizedString( @"CHAT", nil )
                                                   icon: [ UIImage chatIcon ] ];
   
   chat_item_.visibilityPredicate = ^BOOL( PFMenuItem* item_ )
   {
      return [ PFChatViewController isAvailable ];
   };
   
   return chat_item_;
}

@end

@interface PFIPadLayoutManager : PFLayoutManager

@end

@implementation PFIPadLayoutManager

-(NSArray*)menuItemsWithWatchlist:( PFWatchlist* )watchlist_
{
   [ [ PFSession sharedSession ] addWatchlist: watchlist_ ];
   
   PFMenu* menu_ = [ PFMenu menuWithItems: @[ [ PFMenuItem menuItemWithWatchlist: watchlist_ watchlistClass: [ PFWatchlistViewController_iPad class ] ]
                                              , [ PFMenuItem itemWithPositionsControllerClass: [ PFPositionsViewController_iPad class ] ]
                                              , [ PFMenuItem itemWithOrdersControllerClass: [ PFMarketOperationsViewController_iPad class ] ]
                                              , [ PFMenuItem itemWithControllerClass: [ PFAccountsViewController_iPad class ]
                                                                               title: NSLocalizedString( @"ACCOUNTS", nil )
                                                                                icon: [ UIImage accountIcon ] ]
                                              , [ PFMenuItem newsItem_iPad ]
                                              , [ PFMenuItem eventLogItem_iPad ]
                                              , [ PFMenuItem secureLogItem ]
                                              , [ PFMenuItem itemWithAction: ^
                                                 {
                                                    PFNavigationController* navigation_controller_ = [ PFNavigationController navigationControllerWithController: [ PFSettingsViewController new ] ];
                                                    navigation_controller_.useCloseButton = YES;
                                                    
                                                    [ PFModalWindow showWithNavigationController: navigation_controller_ ];
                                                 }
                                                                      title: NSLocalizedString( @"SETTINGS", nil )
                                                                       icon: [ UIImage settingsIcon ] ]
                                              , [ PFMenuItem chatItem ]
                                              , [ PFMenuItem itemWithAction: ^{ [ (PFAppDelegate *)[ [ UIApplication sharedApplication ] delegate ] logoutCurrentSession ]; }
                                                                      title: NSLocalizedString( @"LOGOUT", nil )
                                                                       icon: [ UIImage logoutIcon ] ]
                                              ] ];
   
   return menu_.items;
}

-(PFLoginViewController*)loginViewController
{
   return [ PFLoginViewController_iPad new ];
}

-(PFLoadViewController*)loadViewControllerWithLogin:( NSString* )login_
                                           password:( NSString* )password_
                                         serverInfo:( PFServerInfo* )server_info_
{
   return [ [ PFLoadViewController_iPad alloc ] initWithLogin: login_
                                                     password: password_
                                                   serverInfo: server_info_ ];
}

-(UIViewController*)menuViewController
{
   return [ [ PFGeneralMenuViewController_iPad alloc ] initWithTabItems: [ self menuItemsWithWatchlist: [ PFWatchlist watchlistWithId: @"ipad" ] ] selectedTabIndex: 0 ];
}

-(void)updateMenuItems
{
//   PFGeneralMenuViewController* menu_controller_ = ( PFGeneralMenuViewController* )( ( PFAppDelegate* )[ UIApplication sharedApplication ].delegate ).window.rootViewController;
//   [ menu_controller_ updateMenuWithItems: [ self menuItemsWithWatchlist: [ PFWatchlist watchlistWithId: @"top_ipad" ] ] ];
}

-(BOOL)isPaginalGridView
{
   return NO;
}

@end

@interface PFIPhoneLayoutManager : PFLayoutManager

@end

@implementation PFIPhoneLayoutManager

-(PFLoginViewController*)loginViewController
{
   return [ PFLoginViewController new ];
}

-(PFLoadViewController*)loadViewControllerWithLogin:( NSString* )login_
                                           password:( NSString* )password_
                                         serverInfo:( PFServerInfo* )server_info_
{
   return [ [ PFLoadViewController alloc ] initWithLogin: login_
                                                password: password_
                                              serverInfo: server_info_ ];
}

-(UIViewController*)menuViewController
{
   return [ [ PFGeneralMenuViewController alloc ] initWithMenuItems: [ self menuItemsWithWatchlist: [ PFWatchlist watchlistWithId: @"iphone" ] ] ];
}

-(NSArray*)menuItemsWithWatchlist:( PFWatchlist* )watchlist_
{
   [ [ PFSession sharedSession ] addWatchlist: watchlist_ ];
   
   PFMenu* menu_ = [ PFMenu menuWithItems: @[ [ PFMenuItem menuItemWithWatchlist: watchlist_ watchlistClass: [ PFWatchlistViewController class ] ]
                                              , [ PFMenuItem itemWithPositionsControllerClass: [ PFPositionsViewController class ] ]
                                              , [ PFMenuItem itemWithOrdersControllerClass: [ PFMarketOperationsViewController class ] ]
                                              , [ PFMenuItem itemWithControllerClass: [ PFAccountsViewController class ]
                                                                               title: NSLocalizedString( @"ACCOUNTS", nil )
                                                                                icon: [ UIImage accountIcon ] ]
                                              , [ PFMenuItem newsItem ]
                                              , [ PFMenuItem eventLogItem ]
                                              , [ PFMenuItem secureLogItem ]
                                              , [ PFMenuItem itemWithControllerClass: [ PFSettingsViewController class ]
                                                                               title: NSLocalizedString( @"SETTINGS", nil )
                                                                                icon: [ UIImage settingsIcon ] ]
                                              , [ PFMenuItem itemWithAction: ^{ [ (PFAppDelegate *)[ [ UIApplication sharedApplication ] delegate ] logoutCurrentSession ]; }
                                                                      title: NSLocalizedString( @"LOGOUT", nil )
                                                                       icon: [ UIImage logoutIcon ] ]
                                              ] ];
   
   return menu_.items;
}

-(void)updateMenuItems
{
   PFGeneralMenuViewController* menu_controller_ = ( PFGeneralMenuViewController* )( ( PFAppDelegate* )[ UIApplication sharedApplication ].delegate ).window.rootViewController;
   [ menu_controller_ updateMenuWithItems: [ self menuItemsWithWatchlist: [ PFWatchlist watchlistWithId: @"iphone" ] ] ];
}

-(BOOL)isPaginalGridView
{
   return YES;
}

@end

@interface PFLayoutManager()

-(NSArray*)menuItemsWithWatchlist:( PFWatchlist* )watchlist_;

@end

@implementation PFLayoutManager

+(PFLayoutManager*)currentLayoutManager
{
   static PFLayoutManager* layout_manager_ = nil;
   if ( !layout_manager_ )
   {
      layout_manager_ = [ UIDevice currentDevice ].userInterfaceIdiom == UIUserInterfaceIdiomPhone
         ? [ PFIPhoneLayoutManager new ]
         : [ PFIPadLayoutManager new ];
   }
   return layout_manager_;
}

-(PFLoginViewController*)loginViewController
{
   [ self doesNotRecognizeSelector: _cmd ];
   return nil;
}

-(PFLoadViewController*)loadViewControllerWithLogin:( NSString* )login_
                                           password:( NSString* )password_
                                         serverInfo:( PFServerInfo* )server_info_
{
   [ self doesNotRecognizeSelector: _cmd ];
   return nil;
}

-(UIViewController*)menuViewController
{
   [ self doesNotRecognizeSelector: _cmd ];
   return nil;
}

-(NSArray*)menuItemsWithWatchlist:( PFWatchlist* )watchlist_
{
   [ self doesNotRecognizeSelector: _cmd ];
   return nil;
}

-(void)updateMenuItems
{
   [ self doesNotRecognizeSelector: _cmd ];
}

-(BOOL)isPaginalGridView
{
   [ self doesNotRecognizeSelector: _cmd ];
   return NO;
}

-(BOOL)shouldShrinkOnKeyboard
{
   return YES;
}

@end
