#import "PFSymbolCell_iPad.h"
#import "PFSettings.h"
#import "NSString+DoubleFormatter.h"
#import "NSDate+Timestamp.h"
#import "UILabel+Price.h"

#import <ProFinanceApi/ProFinanceApi.h>

/////////////////////////////////////////////////////

@implementation PFSymbolBSizeCell_iPad

-(void)reloadDataWithSymbol:( id< PFSymbol > )symbol_
{
   [ super reloadDataWithSymbol: symbol_ ];
   
   id< PFQuote > quote_ = symbol_.quote;
   double displayed_amount_ = [ PFSettings sharedSettings ].showQuantityInLots ? quote_.bidAmount : quote_.bidAmount * symbol_.instrument.lotSize;
   self.valueLabel.text = quote_ ? [ NSString stringWithAmount: displayed_amount_ ] : nil;
}

@end

/////////////////////////////////////////////////////

@implementation PFSymbolChangePercentCell_iPad

-(void)reloadDataWithSymbol:( id< PFSymbol > )symbol_
{
   [ super reloadDataWithSymbol: symbol_ ];
   
   id< PFQuote > quote_ = symbol_.quote;

   if ( quote_ )
   {
      [ self.valueLabel showColouredValue: symbol_.changePercent precision: 2 ];
   }
   else
   {
      self.valueLabel.text = nil;
   }
}

@end

/////////////////////////////////////////////////////

@implementation PFSymbolASizeCell_iPad

-(void)reloadDataWithSymbol:( id< PFSymbol > )symbol_
{
   [ super reloadDataWithSymbol: symbol_ ];
   
   id< PFQuote > quote_ = symbol_.quote;
   double displayed_amount_ = [ PFSettings sharedSettings ].showQuantityInLots ? quote_.askAmount : quote_.askAmount * symbol_.instrument.lotSize;
   self.valueLabel.text = quote_ ? [ NSString stringWithAmount: displayed_amount_ ] : nil;
}

@end

/////////////////////////////////////////////////////

@implementation PFSymbolChangeCell_iPad

-(void)reloadDataWithSymbol:( id< PFSymbol > )symbol_
{
   [ super reloadDataWithSymbol: symbol_ ];
   
   id< PFQuote > quote_ = symbol_.quote;

   if ( quote_ )
   {
      [ self.valueLabel showColouredValue: symbol_.change precision: 0 ];
   }
   else
   {
      self.valueLabel.text = nil;
   }
}

@end

/////////////////////////////////////////////////////

@implementation PFSymbolLastCell_iPad

-(void)reloadDataWithSymbol:( id< PFSymbol > )symbol_
{
   [ super reloadDataWithSymbol: symbol_ ];
   
   id< PFQuote > quote_ = symbol_.quote;
   self.valueLabel.text = quote_ ? [ NSString stringWithPrice: quote_.last symbol: symbol_ ] : nil;
}

@end
/////////////////////////////////////////////////////

@implementation PFSymbolVolumeCell_iPad

-(void)reloadDataWithSymbol:( id< PFSymbol > )symbol_
{
   [ super reloadDataWithSymbol: symbol_ ];
   
   id< PFQuote > quote_ = symbol_.quote;
   self.valueLabel.text = quote_ ? [ NSString stringWithVolume: quote_.volume ] : nil;
}

@end

/////////////////////////////////////////////////////

@implementation PFSymbolSpreadCell_iPad

-(void)reloadDataWithSymbol:( id< PFSymbol > )symbol_
{
   [ super reloadDataWithSymbol: symbol_ ];
   
   id< PFQuote > quote_ = symbol_.quote;
   self.valueLabel.text = quote_ ? [ NSString stringWithDouble: symbol_.spread precision: 1 ] : nil;
}

@end

/////////////////////////////////////////////////////

@implementation PFSymbolLastUpdateCell_iPad

-(void)reloadDataWithSymbol:( id< PFSymbol > )symbol_
{
   [ super reloadDataWithSymbol: symbol_ ];
   
   id< PFQuote > quote_ = symbol_.quote;

   int last_update_interval_ = (int)[ [ NSDate date ] timeIntervalSinceDate: quote_.localDate ];
   
   if (last_update_interval_ >= 3600 * 24 )
   {
      self.valueLabel.text = [ NSString stringWithFormat: @"%d %@", last_update_interval_ / ( 3600 * 24 ), NSLocalizedString(@"DAYS", nil) ];
   }
   else if ( last_update_interval_ >= 3600 )
   {
      self.valueLabel.text = [ NSString stringWithFormat: @"%d %@", last_update_interval_ / 3600, NSLocalizedString(@"HOURS", nil) ];
   }
   else if ( last_update_interval_ >= 60 )
   {
      self.valueLabel.text = [ NSString stringWithFormat: @"%d %@", last_update_interval_ / 60, NSLocalizedString(@"MINUTES", nil) ];
   }
   else
   {
      self.valueLabel.text = [ NSString stringWithFormat: @"%d %@", last_update_interval_ % 60, NSLocalizedString(@"SECONDS", nil) ];
   }
   //[ quote_.date shortTimestampString ];
}

@end

/////////////////////////////////////////////////////

@implementation PFSymbolOpenCell_iPad

-(void)reloadDataWithSymbol:( id< PFSymbol > )symbol_ 
{
   [ super reloadDataWithSymbol: symbol_ ];
   
   id< PFQuote > quote_ = symbol_.quote;
   self.valueLabel.text = quote_ ? [ NSString stringWithPrice: quote_.open symbol: symbol_ ] : nil;
}

@end

/////////////////////////////////////////////////////

@implementation PFSymbolLowCell_iPad

-(void)reloadDataWithSymbol:( id< PFSymbol > )symbol_
{
   [ super reloadDataWithSymbol: symbol_ ];
   
   id< PFQuote > quote_ = symbol_.quote;
   self.valueLabel.text = quote_ ? [ NSString stringWithPrice: quote_.low symbol: symbol_ ] : nil;
}

@end

/////////////////////////////////////////////////////

@implementation PFSymbolCloseCell_iPad

-(void)reloadDataWithSymbol:( id< PFSymbol > )symbol_
{
   [ super reloadDataWithSymbol: symbol_ ];
   
   id< PFQuote > quote_ = symbol_.quote;
   self.valueLabel.text = quote_ ? [ NSString stringWithPrice: quote_.previousClose symbol: symbol_ ] : nil;
}

@end

/////////////////////////////////////////////////////

@implementation PFSymbolHighCell_iPad

-(void)reloadDataWithSymbol:( id< PFSymbol > )symbol_
{
   [ super reloadDataWithSymbol: symbol_ ];
   
   id< PFQuote > quote_ = symbol_.quote;
   self.valueLabel.text = quote_ ? [ NSString stringWithPrice: quote_.high symbol: symbol_ ] : nil;
}

@end

/////////////////////////////////////////////////////

@implementation PFSymbolSettlementPriceCell_iPad

-(void)reloadDataWithSymbol:( id< PFSymbol > )symbol_
{
   [ super reloadDataWithSymbol: symbol_ ];

   id< PFQuote > quote_ = symbol_.quote;
   self.valueLabel.text = quote_ ? [ NSString stringWithPrice: quote_.settlementPrice symbol: symbol_ ] : nil;
}

@end

/////////////////////////////////////////////////////

@implementation PFSymbolPrevSettlementPriceCell_iPad

-(void)reloadDataWithSymbol:( id< PFSymbol > )symbol_
{
   [ super reloadDataWithSymbol: symbol_ ];

   id< PFQuote > quote_ = symbol_.quote;
   self.valueLabel.text = quote_ ? [ NSString stringWithPrice: quote_.prevSettlementPrice symbol: symbol_ ] : nil;
}

@end