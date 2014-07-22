#import "PFLevel4QuoteCell.h"
#import "PFSettings.h"
#import "UILabel+Price.h"
#import "NSString+DoubleFormatter.h"

#import <ProFinanceApi/ProFinanceApi.h>

///////////////////////////////////////////////////////////////////////////////////////////////

@implementation PFLevel4QuoteAskCell

-(void)reloadDataWithLevel4Quote: (id<PFLevel4Quote>)level4_quote_
{
   self.valueLabel.userInteractionEnabled = NO;
   
   [ self.valueLabel showPrice: level4_quote_.ask
                     forSymbol: level4_quote_.symbol
                      coloured: YES ];
}

-(IBAction)marketAction: ( id )sender_
{
   [ self.delegate symbolPriceCell: self didAskSelectForLeve4Quote: self.level4Quote ];
}

@end

///////////////////////////////////////////////////////////////////////////////////////////////

@implementation PFLevel4QuoteBidCell

-(void)reloadDataWithLevel4Quote: (id<PFLevel4Quote>)level4_quote_
{
   self.valueLabel.userInteractionEnabled = NO;
   
   [ self.valueLabel showPrice: level4_quote_.bid
                     forSymbol: level4_quote_.symbol
                      coloured: YES ];
}

-(IBAction)marketAction: ( id )sender_
{
   [ self.delegate symbolPriceCell: self didBidSelectForLeve4Quote: self.level4Quote ];
}

@end

///////////////////////////////////////////////////////////////////////////////////////////////

@implementation PFLevel4QuoteLastAndVolumeCell

-(void)reloadDataWithLevel4Quote: (id<PFLevel4Quote>)level4_quote_
{
   [ self.topLabel showPrice: level4_quote_.lastPrice
                   forSymbol: level4_quote_.symbol
                    coloured: YES ];
   
   self.bottomLabel.text = level4_quote_ ? [ NSString stringWithVolume: level4_quote_.volume ] : nil;
}

@end

///////////////////////////////////////////////////////////////////////////////////////////////

@implementation PFLevel4QuoteAskSizeAndBidSizeCell

-(void)reloadDataWithLevel4Quote: (id<PFLevel4Quote>)level4_quote_
{
   double displayed_ask_amount_ = [ PFSettings sharedSettings ].showQuantityInLots ? level4_quote_.askAmount : level4_quote_.askAmount * level4_quote_.symbol.instrument.lotSize;
   double displayed_bid_amount_ = [ PFSettings sharedSettings ].showQuantityInLots ? level4_quote_.bidAmount : level4_quote_.bidAmount * level4_quote_.symbol.instrument.lotSize;
   self.topLabel.text = level4_quote_ ? [ NSString stringWithVolume: displayed_ask_amount_ ] : nil;
   self.bottomLabel.text = level4_quote_ ? [ NSString stringWithVolume: displayed_bid_amount_ ] : nil;
}

@end

///////////////////////////////////////////////////////////////////////////////////////////////

@implementation PFLevel4QuoteDeltaAndGammaCell

-(void)reloadDataWithLevel4Quote: (id<PFLevel4Quote>)level4_quote_
{
   self.topLabel.text =  level4_quote_ ? [ NSString stringWithFormat: @"%f", level4_quote_.delta ] : nil;
   self.bottomLabel.text = level4_quote_ ? [ NSString stringWithFormat: @"%f", level4_quote_.gamma ] : nil;
}

@end

///////////////////////////////////////////////////////////////////////////////////////////////

@implementation PFLevel4QuoteVegaAndThetaCell

-(void)reloadDataWithLevel4Quote: (id<PFLevel4Quote>)level4_quote_
{
   self.topLabel.text =  level4_quote_ ? [ NSString stringWithFormat: @"%f", level4_quote_.vega ] : nil;
   self.bottomLabel.text = level4_quote_ ? [ NSString stringWithFormat: @"%f", level4_quote_.theta ] : nil;
}

@end

///////////////////////////////////////////////////////////////////////////////////////////////