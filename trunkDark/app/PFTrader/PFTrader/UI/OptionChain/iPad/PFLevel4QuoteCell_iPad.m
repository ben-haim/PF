#import "PFLevel4QuoteCell_iPad.h"
#import "PFSettings.h"
#import "UILabel+Price.h"
#import "NSString+DoubleFormatter.h"

#import <ProFinanceApi/ProFinanceApi.h>

@implementation PFLevel4QuoteLastCell

-(void)reloadDataWithLevel4Quote: (id<PFLevel4Quote>)level4_quote_
{
   [ self.valueLabel showPrice: level4_quote_.lastPrice
                     forSymbol: level4_quote_.symbol
                      coloured: YES ];
}

@end

@implementation PFLevel4QuoteChangeCell

-(void)reloadDataWithLevel4Quote: (id<PFLevel4Quote>)level4_quote_
{
   self.valueLabel.text = @"Change";
}

@end

@implementation PFLevel4QuoteTickerCell

-(BOOL)isDynamic
{
   return NO;
}

-(void)reloadDataWithLevel4Quote: (id<PFLevel4Quote>)level4_quote_
{
   self.valueLabel.text = @"Ticker";
}

@end

@implementation PFLevel4QuoteVolumeCell

-(void)reloadDataWithLevel4Quote: (id<PFLevel4Quote>)level4_quote_
{
   self.valueLabel.text = level4_quote_ ? [ NSString stringWithVolume: level4_quote_.volume ] : nil;
}

@end

@implementation PFLevel4QuoteAskSizeCell

-(void)reloadDataWithLevel4Quote: (id<PFLevel4Quote>)level4_quote_
{
   double displayed_ask_amount_ = [ PFSettings sharedSettings ].showQuantityInLots ? level4_quote_.askAmount : level4_quote_.askAmount * level4_quote_.symbol.instrument.lotSize;
   self.valueLabel.text = level4_quote_ ? [ NSString stringWithVolume: displayed_ask_amount_ ] : nil;
}

@end

@implementation PFLevel4QuoteBidSizeCell

-(void)reloadDataWithLevel4Quote: (id<PFLevel4Quote>)level4_quote_
{
   double displayed_bid_amount_ = [ PFSettings sharedSettings ].showQuantityInLots ? level4_quote_.bidAmount : level4_quote_.bidAmount * level4_quote_.symbol.instrument.lotSize;
   self.valueLabel.text = level4_quote_ ? [ NSString stringWithVolume: displayed_bid_amount_ ] : nil;
}

@end

@implementation PFLevel4QuoteOpenCell

-(void)reloadDataWithLevel4Quote: (id<PFLevel4Quote>)level4_quote_
{
   self.valueLabel.text = level4_quote_ ? [ NSString stringWithPrice: level4_quote_.open symbol: level4_quote_.symbol ] : nil;
}

@end

@implementation PFLevel4QuoteHighCell

-(void)reloadDataWithLevel4Quote: (id<PFLevel4Quote>)level4_quote_
{
   self.valueLabel.text = level4_quote_ ? [ NSString stringWithPrice: level4_quote_.high symbol: level4_quote_.symbol ] : nil;
}

@end

@implementation PFLevel4QuoteLowCell

-(void)reloadDataWithLevel4Quote: (id<PFLevel4Quote>)level4_quote_
{
   self.valueLabel.text = level4_quote_ ? [ NSString stringWithPrice: level4_quote_.low symbol: level4_quote_.symbol ] : nil;
}

@end

@implementation PFLevel4QuoteCloseCell

-(void)reloadDataWithLevel4Quote: (id<PFLevel4Quote>)level4_quote_
{
   self.valueLabel.text = level4_quote_ ? [ NSString stringWithPrice: level4_quote_.close symbol: level4_quote_.symbol ] : nil;
}

@end

@implementation PFLevel4QuoteDeltaCell

-(void)reloadDataWithLevel4Quote: (id<PFLevel4Quote>)level4_quote_
{
   self.valueLabel.text = level4_quote_ ? [ NSString stringWithFormat: @"%f", level4_quote_.delta ] : nil;
}

@end

@implementation PFLevel4QuoteGammaCell

-(void)reloadDataWithLevel4Quote: (id<PFLevel4Quote>)level4_quote_
{
   self.valueLabel.text = level4_quote_ ? [ NSString stringWithFormat: @"%f", level4_quote_.gamma ] : nil;
}

@end

@implementation PFLevel4QuoteVegaCell

-(void)reloadDataWithLevel4Quote: (id<PFLevel4Quote>)level4_quote_
{
   self.valueLabel.text = level4_quote_ ? [ NSString stringWithFormat: @"%f", level4_quote_.vega ] : nil;
}

@end

@implementation PFLevel4QuoteThetaCell

-(void)reloadDataWithLevel4Quote: (id<PFLevel4Quote>)level4_quote_
{
   self.valueLabel.text = level4_quote_ ? [ NSString stringWithFormat: @"%f", level4_quote_.theta ] : nil;
}

@end
