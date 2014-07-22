#import "UILabel+Price.h"

#import "NSString+DoubleFormatter.h"
#import "UIColor+Skin.h"

#import <ProFinanceApi/ProFinanceApi.h>

@implementation UILabel (Price)

-(void)setPriceString:( NSString* )price_string_
{
   self.text = price_string_;
}

-(UIColor*)colorForQuote:( id< PFQuote > )quote_
{
   switch ( quote_.growthType )
   {
      case PFQuoteGrowthUp:
         return [ UIColor greenTextColor ];
      case PFQuoteGrowthDown:
         return [ UIColor redTextColor ];
      default:
         return [ UIColor mainTextColor ];
   }
}

-(void)showPrice:( PFDouble )price_
       forSymbol:( id< PFSymbol > )symbol_
        coloured:( BOOL )coloured_
{
   if ( coloured_ )
   {
      self.textColor = [ self colorForQuote: symbol_.quote ];
   }

   [ self setPriceString: price_ <= 0.0 ? @"-" : [ NSString stringWithDouble: price_ precision: symbol_.instrument.precision ] ];
}

-(void)showPrice:( PFDouble )price_
       forSymbol:( id< PFSymbol > )symbol_
{
   [ self showPrice: price_ forSymbol: symbol_ coloured: NO ];
}

-(void)showPrice:( PFDouble )price_
       forSymbol:( id< PFSymbol > )symbol_
       withColor:( UIColor* )color_
{
   self.textColor = color_;
   [ self showPrice: price_ forSymbol: symbol_ ];
}

-(void)showAskForSymbol:( id< PFSymbol > )symbol_
{
   self.textColor = [ UIColor redTextColor ];
   [ self showPrice: symbol_.quote.ask forSymbol: symbol_ coloured: NO ];
}

-(void)showBidForSymbol:( id< PFSymbol > )symbol_
{
   self.textColor = [ UIColor blueTextColor ];
   [ self showPrice: symbol_.quote.bid forSymbol: symbol_ coloured: NO ];
}

-(void)showLastForSymbol:( id< PFSymbol > )symbol_
{
   [ self showPrice: symbol_.quote.last forSymbol: symbol_ coloured: YES ];
}

-(void)showColouredValue:( double )value_
               precision:( NSUInteger )precision_
         dashIfValueZero:( BOOL ) is_dash_
{
   [ self showColouredValue: value_ precision: precision_ suffix: nil dashIfValueZero: is_dash_ isDarkCollor: NO ];
}

-(void)showColouredValue:( double )value_
               precision:( NSUInteger )precision_
         dashIfValueZero:( BOOL ) is_dash_
            isDarkCollor:( BOOL ) is_dark_
{
   [ self showColouredValue: value_ precision: precision_ suffix: nil dashIfValueZero: is_dash_ isDarkCollor: is_dark_ ];
}

-(void)showColouredValue:( double )value_
               precision:( NSUInteger )precision_
{
   [ self showColouredValue: value_ precision: precision_ suffix: nil ];
}

-(void)showColouredValue:( double )value_
               precision:( NSUInteger )precision_
                  suffix:( NSString* )suffix_
{
   [ self showColouredValue: value_ precision: precision_ suffix: suffix_ dashIfValueZero: NO isDarkCollor: NO ];
}

-(void)showColouredValue:( double )value_
               precision:( NSUInteger )precision_
                  suffix:( NSString* )suffix_
         dashIfValueZero:( BOOL ) is_dash_
            isDarkCollor:( BOOL ) is_dark_
{
   UIColor* positiveColor = is_dark_ ? [ UIColor positivePriceDarkColor ] : [ UIColor positivePriceColor ];
   UIColor* negativeColor = is_dark_ ? [ UIColor negativePriceDarkColor ] : [ UIColor negativePriceColor ];

   self.textColor = (value_ > 0.0) ? positiveColor : ((value_ == 0.0) ? [ UIColor mainTextColor ] : negativeColor);
   NSString* string_ = (is_dash_ && (value_ == 0.0)) ? @"-" :
                                                       ((precision_ > 0) ? [ NSString stringWithDouble: value_ precision: precision_ ] :
                                                                           [ NSString stringWithAmount: value_ ]);
   self.text = (suffix_.length > 0) ? [ NSString stringWithFormat: @"%@ %@", string_, suffix_ ] : string_;
}

-(void)showPositiveNegativeColouredValue:( double )value_
                               precision:( NSUInteger )precision_
                                currency:( NSString* ) currency_
                       negativeTextColor:( UIColor* ) neg_color_
                       positiveTextColor:( UIColor* ) pos_color_
                           zeroTextColor:( UIColor* ) zero_color_
                         dashIfValueZero:( BOOL ) is_dash_
                          isPositiveSign:( BOOL ) is_sign_
{
   self.textColor = (value_ > 0.0) ? pos_color_ : ((value_ < 0.0) ? neg_color_ : zero_color_);
   self.text = (is_dash_ && (value_ == 0.0)) ? @"-" : [NSString stringWithMoney: value_ andPrecision: precision_];
   if ((value_ > 0.0) && (is_sign_)) self.text = [@"+" stringByAppendingString:  self.text];
   self.text = [self.text stringByAppendingFormat: @" %@", currency_];
}

-(void)showAmount:( double )value_
        precision:( NSUInteger )precision_
         currency:( NSString* )currency_
{
   self.text = [NSString stringWithMoney: value_ andPrecision: precision_];
   self.text = [self.text stringByAppendingFormat: @" %@", currency_];
}

@end
