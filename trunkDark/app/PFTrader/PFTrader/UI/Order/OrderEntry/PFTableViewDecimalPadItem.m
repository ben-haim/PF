#import "PFTableViewDecimalPadItem.h"

#import "PFTableViewDecimalPadCell.h"
#import "NSString+DoubleFormatter.h"

@interface PFTableViewDecimalPadItem () 

@property ( nonatomic, assign ) double doubleValue;
@property ( nonatomic, assign ) double minValue;
@property ( nonatomic, assign ) double precision;

@end

@implementation PFTableViewDecimalPadItem

@synthesize doubleValue;
@synthesize minValue;
@synthesize step;
@synthesize precision;
@synthesize delegate;

-(id)initWithName: (NSString*)name_
            value: (double)value_
         minValue: (double)min_value_
             step: (double)step_
{
   int precision_ = 1;
   
   if ( step_ >= 1 )
   {
      precision_ = 0;
   }
   else if ( step_ != 0.0 )
   {
      int new_precision_ = ceil(fabs(log10(step_)));
      
      if ( new_precision_ > 1)
      {
         precision_ = new_precision_;
      }
   }
   
   self = [ super initWithAction: nil
                           title: name_
                           value: [ NSString stringWithDouble: value_ precision: precision_ ] ];
   
   if ( self )
   {
      self.doubleValue = value_;
      self.minValue = min_value_;
      self.step = step_;
      self.precision = precision_;
   }
   return self;
}

-(void)setValue:( NSString* )value_
{
   if (self.step > 0 )
   {
      double double_value_ = round( [ value_ doubleValue ] / self.step) * self.step;
      self.doubleValue = double_value_ > self.minValue ? double_value_ : self.minValue;
      
      [ super setValue: [ NSString stringWithDouble: self.doubleValue precision: self.precision ] ];
   }
   else
   {
      [ super setValue: value_ ];
   }
   
   if ( self.delegate )
   {
      [ self.delegate decimalPadItemValueChanged ];
   }
}

-(Class)cellClass
{
   return [ PFTableViewDecimalPadCell class ];
}

@end
