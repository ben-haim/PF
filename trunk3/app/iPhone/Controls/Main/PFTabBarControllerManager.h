#import <UIKit/UIKit.h>

@class MarketWatch;
@class OpenPosWatch;
@class FavoritesCtl;
@class HistoryViewController;
@class PFNewsViewController;

@interface PFTabBarControllerManager : NSObject

@property ( nonatomic, strong ) IBOutlet UITabBarController* tabBarController;

@property ( nonatomic, strong ) IBOutlet MarketWatch* ratesController;
@property ( nonatomic, strong ) IBOutlet OpenPosWatch* tradesController;
@property ( nonatomic, strong ) IBOutlet FavoritesCtl* favoritesController;
@property ( nonatomic, strong ) IBOutlet HistoryViewController* historyController;
@property ( nonatomic, strong ) IBOutlet PFNewsViewController* newsController;


@property ( nonatomic, strong ) IBOutlet UITabBarItem *tabBarRates;
@property ( nonatomic, strong ) IBOutlet UITabBarItem *tabBarPositions;
@property ( nonatomic, strong ) IBOutlet UITabBarItem *tabBarHistory;
@property ( nonatomic, strong ) IBOutlet UITabBarItem *tabBarNews;
@property ( nonatomic, strong ) IBOutlet UITabBarItem *tabBarMail;
@property ( nonatomic, strong ) IBOutlet UITabBarItem *tabBarCalendar;
@property ( nonatomic, strong ) IBOutlet UITabBarItem *tabBarFavorites;
@property ( nonatomic, strong ) IBOutlet UITabBarItem *tabBarContacts;
@property ( nonatomic, strong ) IBOutlet UITabBarItem *tabBarExit;

@property ( nonatomic, strong ) IBOutlet UITabBarItem *tabWeb1;
@property ( nonatomic, strong ) IBOutlet UITabBarItem *tabWeb2;

+(id)manager;

@end
