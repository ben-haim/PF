#import "PFTableViewIntervalItem.h"

#import "PFIndicator.h"

@interface PFTableViewIntervalItem ()

@property ( nonatomic, strong ) PFIndicatorAttributeInterval* interval;

@end

@implementation PFTableViewIntervalItem

@synthesize interval;

-(id)initWithInterval:( PFIndicatorAttributeInterval* )interval_
{
   self = [ super initWithAction: nil title: interval_.title ];
   if ( self )
   {
      self.interval = interval_;
   }
   return self;
}

-(NSString*)value
{
   return [ NSString stringWithFormat: @"%d", (int)self.interval.value ];
}

-(NSUInteger)pickerField:( PFPickerField* )picker_field_
 numberOfRowsInComponent:( NSInteger )component_
{
   return self.interval.max - self.interval.min + 1;
}

-(NSString*)pickerField:( PFPickerField* )picker_field_
            titleForRow:( NSInteger )row_
           forComponent:( NSInteger )component_
{
   return [ NSString stringWithFormat: @"%d", (int)(row_ + self.interval.min) ];
}

-(NSUInteger)pickerField:( PFPickerField* )picker_field_
   currentRowInComponent:( NSInteger )component_
{
   return self.interval.value - self.interval.min;
}

-(void)pickerField:( PFPickerField* )picker_field_
      didSelectRow:( NSInteger )row_
       inComponent:( NSInteger )component_
{
   self.interval.value = self.interval.min + row_;
   picker_field_.text = self.value;

   [ super pickerField: picker_field_ didSelectRow: row_ inComponent: component_ ];
}

@end
