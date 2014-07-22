#import "PFWatchlistEditorSymbolCell.h"

#import "PFSwitch.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFWatchlistEditorSymbolCell ()

@property ( nonatomic, strong ) id< PFSymbol > currentSymbol;
@property ( nonatomic, strong ) id< PFWatchlist > watchlist;

@end

@implementation PFWatchlistEditorSymbolCell

@synthesize nameLabel;
@synthesize overviewLabel;
@synthesize watchlistSwitch;

@synthesize currentSymbol;
@synthesize watchlist;

+(id)cell
{
   PFWatchlistEditorSymbolCell* cell_ = [ super cell ];
   cell_.watchlistSwitch.onText = NSLocalizedString( @"ACTIVE", nil );
   cell_.watchlistSwitch.offText = NSLocalizedString( @"HIDDEN", nil );
   return cell_;
}

-(id< PFSymbol >)symbol
{
   return self.currentSymbol;
}

-(void)setSymbol:( id< PFSymbol > )symbol_
       watchlist:( id< PFWatchlist > )watchlist_
{
   self.currentSymbol = symbol_;
   self.watchlist = watchlist_;

   self.nameLabel.text = symbol_.name;
   self.overviewLabel.text = symbol_.instrument.overview;
   self.watchlistSwitch.on = [ watchlist_ containsSymbol: symbol_ ];
}

-(IBAction)watchlistAction:( id )sender_
{
   if ( self.watchlistSwitch.on )
   {
      [ self.watchlist addSymbol: self.currentSymbol ];
   }
   else
   {
      [ self.watchlist removeSymbol: self.currentSymbol ];
   }
}

@end
