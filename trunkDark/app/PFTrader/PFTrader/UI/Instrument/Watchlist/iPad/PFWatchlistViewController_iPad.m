#import "PFWatchlistViewController_iPad.h"
#import "PFWatchlistViewController.h"
#import "PFChoicesViewController.h"
#import "PFChartViewController_iPad.h"
#import "PFMarketDepthViewController.h"
#import "PFSymbolInfoTabsViewController.h"
#import "PFWatchlistInfoView.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFWatchlistViewController_iPad () < PFWatchlistViewControllerDelegate >

@end

@implementation PFWatchlistViewController_iPad

-(id)initWithWatchlist:( id< PFWatchlist > )watchlist_
{
   PFWatchlistViewController* watchlist_controller_ = [ [ PFWatchlistViewController alloc ] initWithWatchlist: watchlist_ ];
   watchlist_controller_.delegate = self;
   
   self = [ super initWithMasterController: watchlist_controller_ ];
   
   if ( self )
   {
      self.title = NSLocalizedString( @"WATCHLIST", nil );
   }
   
   return self;
}

#pragma mark - PFWatchlistViewControllerDelegate

-(void)watchlistViewController:( PFWatchlistViewController* )controller_
               didSelectSymbol:( id< PFSymbol > )symbol_
{
   if ( symbol_ )
   {
      PFChartViewController_iPad* chart_controller_ = [ [ PFChartViewController_iPad alloc ] initWithSybol: symbol_
                                                                                               andInfoView: [ PFWatchlistInfoView watchlistInfoViewWithSymbol: symbol_ ] ];
      chart_controller_.chartOnTop = YES;
      
      PFChoicesViewControllerSource* chart_source_ = [ PFChoicesViewControllerSource sourceWithTitle: NSLocalizedString( @"CHART", nil )
                                                                                          controller: chart_controller_ ];
      PFChoicesViewControllerSource* depth_source_ = [ PFChoicesViewControllerSource sourceWithTitle: NSLocalizedString( @"MARKET_DEPTH", nil )
                                                                                          controller: [ [ PFMarketDepthViewController alloc ] initWithSymbol: symbol_ ] ];
      PFChoicesViewControllerSource* info_source_ = [ PFChoicesViewControllerSource sourceWithTitle: NSLocalizedString( @"SYMBOL_INFO", nil )
                                                                                         controller: [ [ PFSymbolInfoTabsViewController alloc ] initWithSymbol: symbol_ ] ];
      
      PFChoicesViewController* choices_controller_ = [ PFChoicesViewController choicesControllerWithSources: @[ chart_source_, depth_source_, info_source_ ]
                                                                                                      title: [ symbol_.name stringByAppendingFormat: @" %@", symbol_.overview ] ];
      chart_controller_.ownedController = choices_controller_;
      
      [ self showDetailController: choices_controller_ ];
   }
   else
   {
      [ self showDetailController: nil ];
   }
}

@end
