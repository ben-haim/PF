#import "PFSymbolCell.h"
#import "PFSettings.h"
#import "NSString+DoubleFormatter.h"
#import "NSDate+Timestamp.h"
#import "UILabel+Price.h"

#import <ProFinanceApi/ProFinanceApi.h>

/////////////////////////////////////////////////////

@implementation PFSymbolPriceCell

@synthesize priceButton;
@synthesize delegate;

+(NSString*)nibName
{
   return @"PFSymbolPriceCell";
}

-(void)reloadDataWithSymbol:( id< PFSymbol > )symbol_
{
   self.valueLabel.userInteractionEnabled = NO;

   [ super reloadDataWithSymbol: symbol_ ];
}

-(IBAction)marketAction:( id )sender_
{
   [ self doesNotRecognizeSelector: _cmd ];
}

@end

/////////////////////////////////////////////////////

@implementation PFSymbolAskCell

-(void)reloadDataWithSymbol:( id< PFSymbol > )symbol_
{
   [ super reloadDataWithSymbol: symbol_ ];

   [ self.valueLabel showAskForSymbol: symbol_ ];
}

-(IBAction)marketAction:( id )sender_
{
   [ self.delegate symbolPriceCell: self buySymbol: self.symbol ];
}

@end

/////////////////////////////////////////////////////

@implementation PFSymbolBidCell

-(void)reloadDataWithSymbol:( id< PFSymbol > )symbol_
{
   [ super reloadDataWithSymbol: symbol_ ];
   
   [ self.valueLabel showBidForSymbol: symbol_ ];
}

-(IBAction)marketAction:( id )sender_
{
   [ self.delegate symbolPriceCell: self sellSymbol: self.symbol ];
}

@end

/////////////////////////////////////////////////////

@implementation PFSymbolBSizeCell

-(void)reloadDataWithSymbol:( id< PFSymbol > )symbol_
{
   [ super reloadDataWithSymbol: symbol_ ];

   id< PFQuote > quote_ = symbol_.quote;

   double displayed_amount_ = [ PFSettings sharedSettings ].showQuantityInLots ? quote_.bidAmount : quote_.bidAmount * symbol_.instrument.lotSize;
   self.topLabel.text = quote_ ? [ NSString stringWithAmount: displayed_amount_ ] : nil;
   
   if ( quote_ )
   {
      [ self.bottomLabel showColouredValue: symbol_.changePercent precision: 2 ];
   }
   else
   {
      self.bottomLabel.text = nil;
   }
}

@end

/////////////////////////////////////////////////////

@implementation PFSymbolASizeCell

-(void)reloadDataWithSymbol:( id< PFSymbol > )symbol_
{
   [ super reloadDataWithSymbol: symbol_ ];

   id< PFQuote > quote_ = symbol_.quote;
   double displayed_amount_ = [ PFSettings sharedSettings ].showQuantityInLots ? quote_.askAmount : quote_.askAmount * symbol_.instrument.lotSize;
   self.topLabel.text = quote_ ? [ NSString stringWithAmount: displayed_amount_ ] : nil;

   if ( quote_ )
   {
      [ self.bottomLabel showColouredValue: symbol_.change precision: 0 ];
   }
   else
   {
      self.bottomLabel.text = nil;
   }
}

@end

/////////////////////////////////////////////////////

@implementation PFSymbolLastCell

-(void)reloadDataWithSymbol:( id< PFSymbol > )symbol_
{
   [ super reloadDataWithSymbol: symbol_ ];

   id< PFQuote > quote_ = symbol_.quote;
   
   self.topLabel.text = quote_ ? [ NSString stringWithPrice: quote_.last symbol: symbol_ ] : nil;
   self.bottomLabel.text = quote_ ? [ NSString stringWithVolume: quote_.volume ] : nil;
}

@end

/////////////////////////////////////////////////////

@implementation PFSymbolSpreadCell

-(void)reloadDataWithSymbol:( id< PFSymbol > )symbol_
{
   [ super reloadDataWithSymbol: symbol_ ];

   id< PFQuote > quote_ = symbol_.quote;

   self.topLabel.text = quote_ ? [ NSString stringWithDouble: symbol_.spread precision: 1 ] : nil;
   
   NSInteger last_update_interval_ = (NSInteger)[ [ NSDate date ] timeIntervalSinceDate: quote_.localDate ];
   
   if (last_update_interval_ >= 3600 * 24 )
   {
      self.bottomLabel.text = [ NSString stringWithFormat: @"%d %@", (int)last_update_interval_ / ( 3600 * 24 ), NSLocalizedString(@"DAYS", nil) ];
   }
   else if ( last_update_interval_ >= 3600 )
   {
      self.bottomLabel.text = [ NSString stringWithFormat: @"%d %@", (int)last_update_interval_ / 3600, NSLocalizedString(@"HOURS", nil) ];
   }
   else if ( last_update_interval_ >= 60 )
   {
      self.bottomLabel.text = [ NSString stringWithFormat: @"%d %@", (int)last_update_interval_ / 60, NSLocalizedString(@"MINUTES", nil) ];
   }
   else
   {
      self.bottomLabel.text = [ NSString stringWithFormat: @"%d %@", (int)last_update_interval_ % 60, NSLocalizedString(@"SECONDS", nil) ];
   }
   //[ quote_.date shortTimestampString ];
}

@end


/////////////////////////////////////////////////////

@implementation PFSymbolOpenCell

-(void)reloadDataWithSymbol:( id< PFSymbol > )symbol_
{
   [ super reloadDataWithSymbol: symbol_ ];

   id< PFQuote > quote_ = symbol_.quote;
   
   self.topLabel.text = quote_ ? [ NSString stringWithPrice: quote_.open symbol: symbol_ ] : nil;
   self.bottomLabel.text = quote_ ? [ NSString stringWithPrice: quote_.low symbol: symbol_ ] : nil;
}

@end

/////////////////////////////////////////////////////

@implementation PFSymbolCloseCell

-(void)reloadDataWithSymbol:( id< PFSymbol > )symbol_
{
   [ super reloadDataWithSymbol: symbol_ ];

   id< PFQuote > quote_ = symbol_.quote;
   
   self.topLabel.text = quote_ ? [ NSString stringWithPrice: quote_.previousClose symbol: symbol_ ] : nil;
   self.bottomLabel.text = quote_ ? [ NSString stringWithPrice: quote_.high symbol: symbol_ ] : nil;
}

@end

/////////////////////////////////////////////////////

@implementation PFSymbolSettlementPriceCell

-(void)reloadDataWithSymbol:( id< PFSymbol > )symbol_
{
   [ super reloadDataWithSymbol: symbol_ ];

   id< PFQuote > quote_ = symbol_.quote;

   self.topLabel.text = quote_ ? [ NSString stringWithPrice: quote_.settlementPrice symbol: symbol_ ] : nil;
   self.bottomLabel.text = quote_ ? [ NSString stringWithPrice: quote_.prevSettlementPrice symbol: symbol_ ] : nil;
}

@end

/////////////////////////////////////////////////////

@implementation PFSymbolOpenInterestCell

-(void)reloadDataWithSymbol:( id< PFSymbol > )symbol_
{
   [ super reloadDataWithSymbol: symbol_ ];
   
   id< PFQuote > quote_ = symbol_.quote;
   
   self.valueLabel.text = quote_.openInterest > 0 ? [ NSString stringWithAmount: quote_.openInterest ] : @"-";
}

@end
