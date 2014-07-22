#import "PFTabBarControllerManager.h"

@implementation PFTabBarControllerManager

@synthesize ratesController = _ratesController;
@synthesize tradesController = _tradesController;
@synthesize favoritesController = _favoritesController;
@synthesize historyController = _historyController;
@synthesize newsController = _newsController;

@synthesize tabBarRates = _tabBarRates;
@synthesize tabBarPositions = _tabBarPositions;
@synthesize tabBarHistory = _tabBarHistory;
@synthesize tabBarNews = _tabBarNews;
@synthesize tabBarMail = _tabBarMail;
@synthesize tabBarCalendar = _tabBarCalendar;
@synthesize tabBarFavorites = _tabBarFavorites;
@synthesize tabBarContacts = _tabBarContacts;
@synthesize tabBarExit = _tabBarExit;
@synthesize tabWeb1 = _tabWeb1;
@synthesize tabWeb2 = _tabWeb2;

-(void)dealloc
{
   [ _ratesController release ];
   [ _tradesController release ];
   [ _favoritesController release ];
   [ _historyController release ];
   [ _newsController release ];

   [ _tabBarRates release ];
   [ _tabBarPositions release ];
   [ _tabBarHistory release ];
   [ _tabBarNews release ];
   [ _tabBarMail release ];
   [ _tabBarCalendar release ];
   [ _tabBarFavorites release ];
   [ _tabBarContacts release ];
   [ _tabBarExit release ];
   [ _tabWeb1 release ];
   [ _tabWeb2 release ];

   [ super dealloc ];
}

+(id)manager
{
   PFTabBarControllerManager* manager_ = [ self new ];

   [ [ NSBundle mainBundle ] loadNibNamed: NSStringFromClass( self )
                                    owner: manager_
                                  options: nil ];

   manager_.tabBarFavorites.title = NSLocalizedString(@"TABS_FAVORITES", nil);
	manager_.tabBarContacts.title = NSLocalizedString(@"TABS_CONTACTS", nil);
	manager_.tabBarRates.title = NSLocalizedString(@"TABS_RATES", nil);
	manager_.tabBarPositions.title = NSLocalizedString(@"TABS_POSITIONS", nil);
	manager_.tabBarHistory.title = NSLocalizedString(@"TABS_HISTORY", nil);
	manager_.tabBarNews.title = NSLocalizedString(@"TABS_NEWS", nil);
	manager_.tabBarMail.title = NSLocalizedString(@"TABS_MAIL", nil);
	manager_.tabBarCalendar.title = NSLocalizedString(@"TABS_CALENDAR", nil);

   return manager_;
}

@end
