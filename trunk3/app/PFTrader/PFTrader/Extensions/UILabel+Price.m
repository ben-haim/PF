#import "UILabel+Price.h"

#import "NSString+DoubleFormatter.h"
#import "UIColor+Skin.h"

#import <ProFinanceApi/ProFinanceApi.h>

#import <TTTAttributedLabel/TTTAttributedLabel.h>

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
         return [ UIColor positivePriceColor ];
      case PFQuoteGrowthDown:
         return [ UIColor negativePriceColor ];
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

   self.font = [ UIFont systemFontOfSize: 14.f ];
   
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
   self.textColor = [ UIColor colorWithRed: 153.f / 255 green: 0.f blue: 0.f alpha: 1.f ];
   [ self showPrice: symbol_.quote.ask forSymbol: symbol_ coloured: NO ];
}

-(void)showBidForSymbol:( id< PFSymbol > )symbol_
{
   self.textColor = [ UIColor colorWithRed: 102.f / 255 green: 153.f / 255 blue: 204.f / 255 alpha: 1.f ];
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
   [ self showColouredValue: value_ precision: precision_ suffix: nil dashIfValueZero: is_dash_ ];
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
   [self showColouredValue: value_ precision: precision_ suffix: suffix_ dashIfValueZero: NO];
}

-(void)showColouredValue:( double )value_
               precision:( NSUInteger )precision_
                  suffix:( NSString* )suffix_
         dashIfValueZero:( BOOL ) is_dash_
{
   self.textColor = (value_ > 0.0) ? [ UIColor positivePriceColor ] : ((value_ == 0.0) ? [ UIColor mainTextColor ] : [ UIColor negativePriceColor ]);
   NSString* string_ = (is_dash_ && (value_ == 0.0)) ? @"-" :
                                                       ((precision_ > 0) ? [ NSString stringWithDouble: value_ precision: precision_ ] :
                                                                           [ NSString stringWithAmount: value_ ]);
   self.text = (suffix_.length > 0) ? [ NSString stringWithFormat: @"%@ %@", string_, suffix_ ] : string_;
}

@end

@implementation TTTAttributedLabel (Price)

-(void)setPriceString:( NSString* )price_string_
{
   [ self setText: price_string_
afterInheritingLabelAttributesAndConfiguringWithBlock:
    ^NSMutableAttributedString*( NSMutableAttributedString* attributed_string_ )
    {
       static NSInteger format_end_offset_ = 3;
       static NSInteger format_length_ = 2;

       if ( [ attributed_string_ length ] < format_end_offset_ )
          return attributed_string_;

       NSRange range_ = NSMakeRange( [ attributed_string_ length ] - format_end_offset_, format_length_ );

       UIFont* system_font_ = [ UIFont systemFontOfSize: 18.f ];

       CTFontRef font_ = CTFontCreateWithName( (__bridge CFStringRef)system_font_.fontName
                                              , system_font_.pointSize
                                              , NULL );

       [ attributed_string_ addAttribute: (NSString *)kCTFontAttributeName
                                   value: (__bridge id)font_
                                   range: range_ ];

       CFRelease(font_);
       return attributed_string_;
    }];
}

@end
