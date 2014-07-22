#import "PFLayoutManager.h"

#import "PFAccountsViewController.h"
#import "PFPositionsViewController.h"
#import "PFWatchlistViewController.h"
#import "PFNewsViewController.h"
#import "PFChatViewController.h"
#import "PFSettingsViewController.h"
#import "PFMarketOperationsViewController.h"
#import "PFScriptsViewController.h"
#import "PFLoginViewController.h"
#import "PFLoadViewController.h"
#import "PFEventLogViewController.h"
#import "PFSecureLogsController.h"
#import "PFChartViewController.h"

//iPad specific
#import "PFAccountsViewController_iPad.h"
#import "PFNewsViewController_iPad.h"
#import "PFMarketOperationsViewController_iPad.h"
#import "PFWatchlistViewController_iPad.h"
#import "PFPositionsViewController_iPad.h"
#import "PFLoginViewController_iPad.h"
#import "PFLoadViewController_iPad.h"
#import "PFEventLogViewController_iPad.h"
#import "PFChartViewController_iPad.h"
#import "PFSettingsViewController_iPad.h"

#import "PFMenu.h"
#import "PFMenuItem.h"

#import "PFTraderSplittedViewController.h"

#import "DDMenuController+PFTrader.h"

#import "UIViewController+Wrapper.h"
#import "UIImage+Icons.h"

#import "PFAppDelegate.h"

#import "PFSettings.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFMenuItem (PFLayoutManager)

+(id)menuItemWithWatchlist:( id< PFWatchlist > )watchlist_
            watchlistClass:( Class )watchlist_class_;

+(id)menuItemChartWithWatchlist:( id< PFWatchlist > )watchlist_
                     chartClass:( Class )chart_class_;

+(id)scriptsItem;
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
      return [ [ chart_class_ alloc ] initSeparateChartWithSymbol: nil andSymbols: watchlist_.symbols ];
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

+(id)scriptsItem
{
   PFMenuItem* scripts_item_ = [ self itemWithControllerClass: [ PFScriptsViewController class ]
                                                        title: NSLocalizedString( @"SCRIPTS", nil )
                                                         icon: [ UIImage scriptsIcon ] ];
   
   scripts_item_.visibilityPredicate = ^BOOL( PFMenuItem* item_ )
   {
      return [ PFScriptsViewController isAvailable ];
   };
   
   return scripts_item_;
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
   PFMenuItem* chat_item_ = [ PFMenuItem itemWithChatControllerClass: [ PFChatViewController class ] ];
   
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
                    , [ PFMenuItem menuItemChartWithWatchlist: watchlist_ chartClass: [ PFChartViewController_iPad class ] ]
                    , [ PFMenuItem itemWithPositionsControllerClass: [ PFPositionsViewController_iPad class ] ]
                    , [ PFMenuItem itemWithControllerClass: [ PFMarketOperationsViewController_iPad class ]
                                                     title: NSLocalizedString( @"ORDERS", nil )
                                                      icon: [ UIImage orderIcon ] ]
                    , [ PFMenuItem scriptsItem ]
                    , [ PFMenuItem itemWithControllerClass: [ PFAccountsViewController_iPad class ]
                                                     title: NSLocalizedString( @"ACCOUNTS", nil )
                                                      icon: [ UIImage accountIcon ] ]
                    , [ PFMenuItem newsItem_iPad ]
                    , [ PFMenuItem chatItem ]
                    , [ PFMenuItem eventLogItem_iPad ]
                    , [ PFMenuItem secureLogItem ]
                    , [ PFMenuItem itemWithControllerClass: [ PFSettingsViewController_iPad class ]
                                                     title: NSLocalizedString( @"SETTINGS", nil )
                                                      icon: [ UIImage settingsIcon ] ]
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
   PFWatchlist* top_watchlist_ = [ PFWatchlist watchlistWithId: @"top_ipad" ];
   PFWatchlist* bottom_watchlist_ = [ PFWatchlist watchlistWithId: @"bottom_ipad" ];

   DDMenuController* top_menu_controller_ = [ DDMenuController traderMenuControllerWithItems: [ self menuItemsWithWatchlist: top_watchlist_ ] ];
   DDMenuController* bottom_menu_controller_ = [ DDMenuController traderMenuControllerWithItems: [ self menuItemsWithWatchlist: bottom_watchlist_ ] ];

   //init delegate and after this push controllers
   PFTraderSplittedViewController* main_controller_
   = [ PFTraderSplittedViewController splittedControllerWithTopMenu: top_menu_controller_
                                                         bottomMenu: bottom_menu_controller_ ];

   [ top_menu_controller_ pushRootController: [ [ PFWatchlistViewController_iPad alloc ] initWithWatchlist: top_watchlist_ ] animated: NO ];
   [ bottom_menu_controller_ pushRootController: [ PFAccountsViewController_iPad new ] animated: NO ];

   return main_controller_;
}

-(void)updateMenuItems
{
   PFTraderSplittedViewController* controller_ = ( PFTraderSplittedViewController* )( ( PFAppDelegate* )[ UIApplication sharedApplication ].delegate ).window.rootViewController;
   
   [ ( DDMenuController* )controller_.topViewController updateMenuWithItems: [ self menuItemsWithWatchlist: [ PFWatchlist watchlistWithId: @"top_ipad" ] ] ];
   [ ( DDMenuController* )controller_.bottomViewController updateMenuWithItems: [ self menuItemsWithWatchlist: [ PFWatchlist watchlistWithId: @"bottom_ipad" ] ] ];
}

-(BOOL)isPaginalGridView
{
   return NO;
}

-(BOOL)shouldShrinkOnKeyboard
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
   PFWatchlist* iphone_watchlist_ = [ PFWatchlist watchlistWithId: @"iphone" ];
   
   return [ DDMenuController traderMenuControllerWithItems: [ self menuItemsWithWatchlist: iphone_watchlist_ ]
                                            rootController: [ [ PFWatchlistViewController alloc ] initWithWatchlist: iphone_watchlist_ ] ];
}

-(NSArray*)menuItemsWithWatchlist:( PFWatchlist* )watchlist_
{
   [ [ PFSession sharedSession ] addWatchlist: watchlist_ ];
   
   PFMenu* menu_ = [ PFMenu menuWithItems: @[ [ PFMenuItem menuItemWithWatchlist: watchlist_ watchlistClass: [ PFWatchlistViewController class ] ]
                                              , [ PFMenuItem menuItemChartWithWatchlist: watchlist_ chartClass: [ PFChartViewController class ] ]
                                              , [ PFMenuItem itemWithPositionsControllerClass: [ PFPositionsViewController class ] ]
                                              , [ PFMenuItem itemWithControllerClass: [ PFMarketOperationsViewController class ]
                                                                               title: NSLocalizedString( @"ORDERS", nil )
                                                                                icon: [ UIImage orderIcon ] ]
                                              , [ PFMenuItem scriptsItem ]
                                              , [ PFMenuItem itemWithControllerClass: [ PFAccountsViewController class ]
                                                                               title: NSLocalizedString( @"ACCOUNTS", nil )
                                                                                icon: [ UIImage accountIcon ] ]
                                              , [ PFMenuItem newsItem ]
                                              , [ PFMenuItem chatItem ]
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
   DDMenuController* menu_controller_ = ( DDMenuController* )( ( PFAppDelegate* )[ UIApplication sharedApplication ].delegate ).window.rootViewController;
   [ menu_controller_ updateMenuWithItems: [ self menuItemsWithWatchlist: [ PFWatchlist watchlistWithId: @"iphone" ] ] ];
}

-(BOOL)isPaginalGridView
{
   return YES;
}

-(BOOL)shouldShrinkOnKeyboard
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
   [ self doesNotRecognizeSelector: _cmd ];
   return NO;
}

@end
